"""py_03_variance_analysis.py -- variance ratios S1/S4 (raw 2.11x vs corrected 1.62x)."""
import os
import numpy as np
import pandas as pd
from scipy import stats

from py_00_setup import (SEG_NAMES, EXPECTED_RAW_RATIO,
                         EXPECTED_CORRECTED_RATIO, RATIO_TOL_REL, OUT_TAB,
                         setup_logging)


def analyse(summary):
    log = setup_logging("03_variance")
    rows = []
    for measure, col, expected in [
            ("Raw F0 variance", "f0_var", EXPECTED_RAW_RATIO),
            ("Pitch-corrected (proxy: f0_var_med)", "f0_var_med",
             EXPECTED_CORRECTED_RATIO)]:
        v = summary.set_index("seg").loc[SEG_NAMES, col].values
        ratio = v[0] / v[3]
        ok = abs(ratio - expected) / expected <= RATIO_TOL_REL
        log.info("%s: S1=%.1f S4=%.1f ratio=%.3fx (paper %.2fx) -> %s",
                 measure, v[0], v[3], ratio, expected, "OK" if ok else "MISMATCH")
        rows.append({"measure": measure, "var_S1": v[0], "var_S4": v[3],
                     "ratio": ratio, "paper_ratio": expected,
                     "status": "OK" if ok else "MISMATCH"})
    tab = pd.DataFrame(rows)
    tab.to_csv(os.path.join(OUT_TAB, "variance_ratios.csv"), index=False)

    trends = []
    x = np.arange(1, 5)
    for measure, col in [("raw", "f0_var"), ("corrected_proxy", "f0_var_med")]:
        y = summary.set_index("seg").loc[SEG_NAMES, col].values.astype(float)
        rho, p = stats.spearmanr(x, y)
        slope, sp, _, _, _ = stats.linregress(x, np.log(y))
        trends.append({"measure": measure, "spearman_rho": rho,
                       "spearman_p": p, "log_slope": slope, "slope_p": sp})
    tt = pd.DataFrame(trends)
    tt.to_csv(os.path.join(OUT_TAB, "variance_trends.csv"), index=False)
    print(tab.to_string(index=False))
    print(tt.to_string(index=False))
    return tab, tt


if __name__ == "__main__":
    from py_01_load_data import load_all
    from py_02_segment_summary import summarize
    feats, f0, _, _ = load_all()
    summary, _ = summarize(feats, f0)
    analyse(summary)
