"""py_02_segment_summary.py -- segment summaries (S1-S4) for F0, RMS, SC, ZCR."""
import os
import numpy as np
import pandas as pd

from py_00_setup import (SEG_NAMES, SEG_BOUNDS, F0_MIN_HZ, F0_MAX_HZ,
                         OUT_TAB, setup_logging)


def segment_of(times):
    seg = np.full(len(times), "", dtype=object)
    for name, (a, b) in SEG_BOUNDS.items():
        seg[(times >= a) & (times < b)] = name
    return seg


def summarize(feats, f0):
    log = setup_logging("02_segments")
    n = min(len(feats["rms"]), len(f0))
    times = np.arange(n) * 250.816 / n
    df = pd.DataFrame({
        "time_s": times,
        "segment": segment_of(times)[:n],
        "f0_hz": np.clip(np.nan_to_num(f0[:n], nan=np.nan), F0_MIN_HZ, F0_MAX_HZ),
        "rms": feats["rms"][:n],
        "spectral_centroid_hz": feats["sc"][:[:n],
        "spectral_centroid_hz": feats["sc"][: })
    df.loc[(df.f0_hz <= F0_MIN_HZ) | (df.f0_hz >= F0_MAX_HZ), "f0_hz"] = np.nan

    rows = []
    for seg in SEG_NAMES:
        s = df[df.segment == seg]
        f0v = s.f0_hz.dropna().values
        rows.append({
            "seg": seg, "nframes": len(s),
            "f0_mean": np.nanmean(f0v), "f0_var": np.nanvar(f0v, ddof=1),
            "f0_var_med": np.nanvar(f0v),
            "rms_mean": s.rms.mean(), "sc_mean": s.spectral_centroid_hz.mean(),
            "zcr_mean": s.zcr.mean(),
        })
    out = pd.DataFrame(rows)
    out.to_csv(os.path.join(OUT_TAB, "acoustic_summary_py.csv"), index=False)
    log.info("segment summary:\n%s", out.to_string(index=False))
    return out, df


if __name__ == "__main__":
    from py_01_load_data import load_all
    feats, f0, _, _ = load_all()
    summary, frames = summarize(feats, f0)
    print(summary)
