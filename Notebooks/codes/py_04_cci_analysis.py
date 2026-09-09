"""py_04_cci_analysis.py -- Code Co-Presence Index CCI_s = 1 - |A-B|/(A+B)."""
import os
import numpy as np
import pandas as pd
from scipy import stats

from py_00_setup import GITHUB_DIR, DEMO_CCI_CSV, OUT_TAB, setup_logging


def cci_s(a, b):
    a = np.asarray(a, float); b = np.asarray(b, float)
    denom = a + b
    return np.where(denom > 0, 1 - np.abs(a - b) / np.where(denom > 0, denom, 1), np.nan)


def load_counts():
    log = setup_logging("04_cci")
    for name in ("code_counts.csv", "code_tokens.csv"):
        if os.path.exists(os.path.join(GITHUB_DIR, name)):
            df = pd.read_csv(os.path.join(GITHUB_DIR, name))
            log.info("using real annotations: %s", name)
            return df
    df = pd.read_csv(DEMO_CCI_CSV, comment="#")
    log.info("no real annotations -> demo data %s", DEMO_CCI_CSV)
    return df


def analyse(cc):
    log = setup_logging("04_cci")
    if {"code", "tokens"} <= set(cc.columns):  # long form
        cc = cc.pivot_table(index=["window_id", "segment"], columns="code",
                            values="tokens", aggfunc="sum", fill_value=0).reset_index()
        cols = [c for c in cc.columns if c not in ("window_id", "segment")]
        cc = cc.rename(columns={cols[0]: "code_a", cols[1]: "code_b"})
    cc["CCI_s"] = cci_s(cc["code_a"], cc["code_b"])
    cc = cc.sort_values("window_id").reset_index(drop=True)
    cc["window_idx"] = np.arange(1, len(cc) + 1)
    cc.to_csv(os.path.join(OUT_TAB, "cci_window_results.csv"), index=False)

    seg = (cc.groupby("segment")["CCI_s"]
             .agg(n_windows="count", CCI_mean="mean", CCI_sd="std").reset_index())
    seg.to_csv(os.path.join(OUT_TAB, "cci_segment_summary.csv"), index=False)

    w = cc.dropna(subset=["CCI_s"])
    conv = {}
    if len(w) >= 3:
        rho, p = stats.spearmanr(w.window_idx, w.CCI_s)
        slope, sp, *_ = stats.linregress(w.window_idx, w.CCI_s)
        conv = {"spearman_rho": rho, "spearman_p": p,
                "slope": slope, "slope_p": sp}
        log.info("convergence trend: rho=%.3f (p=%.4f), slope=%.5f (p=%.5f)",
                 rho, p, slope, sp)
    print(seg.to_string(index=False))
    return cc, seg, conv


if __name__ == "__main__":
    cc = load_counts()
    analyse(cc)
