"""py_05_figures.py -- publication figures (matplotlib/seaborn)."""
import os
import numpy as np
import pandas as pd
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import seaborn as sns

from py_00_setup import OUT_FIG, OUT_TAB, setup_logging

sns.set_theme(style="whitegrid", context="paper")
DPI = 300


def make_figures(summary, frames, cci=None):
    log = setup_logging("05_figures")

    # Fig 1: F0 mean per segment
    fig, ax = plt.subplots(figsize=(5, 3.2))
    sns.barplot(data=summary, x="seg", y="f0_mean", ax=ax, color="#4c72b0")
    ax.set_xlabel("Segment"); ax.set_ylabel("Mean F0 (Hz)")
    ax.set_title("Mean F0 per segment")
    fig.tight_layout(); fig.savefig(os.path.join(OUT_FIG, "fig1_f0_mean.png"), dpi=DPI); plt.close(fig)

    # Fig 2: variance per segment
    fig, ax = plt.subplots(figsize=(5, 3.2))
    s = summary.melt(id_vars="seg", value_vars=["f0_var", "f0_var_med"],
                     var_name="measure", value_name="variance")
    sns.barplot(data=s, x="seg", y="variance", hue="measure", ax=ax)
    ax.set_xlabel("Segment"); ax.set_ylabel("F0 variance (Hz$^2$)")
    ax.set_title("F0 variance: raw vs corrected proxy")
    fig.tight_layout(); fig.savefig(os.path.join(OUT_FIG, "fig2_f0_variance.png"), dpi=DPI); plt.close(fig)

    # Fig 3: RMS / centroid / ZCR per segment
    fig, axes = plt.subplots(1, 3, figsize=(10, 3.2))
    for ax, col, lab in zip(axes, ["rms_mean", "sc_mean", "zcr_mean"],
                            ["RMS", "Spectral centroid (Hz)", "ZCR"]):
        sns.barplot(data=summary, x="seg", y=col, ax=ax, color="#55a868")
        ax.set_xlabel("Segment"); ax.set_ylabel(lab)
    fig.suptitle("Acoustic features per segment")
    fig.tight_layout(); fig.savefig(os.path.join(OUT_FIG, "fig3_features.png"), dpi=DPI); plt.close(fig)

    # Fig 4: F0 trajectory over time
    fig, ax = plt.subplots(figsize=(8,     fig, ax = plt.subplots(figsize=(8, _hz, lw=0.4, color="#c44e52")
    ax.set_xlabel("Time (s)"); ax.set_ylabel("F0 (Hz)")
    ax.set_title("F0 trajectory (pitch-corrected range)")
    fig.tight_layout(); fig.savefig(os.path.join(OUT_FIG, "fig4_f0_trajectory.png"), dpi=DPI); plt.close(fig)

    # Fig 5: CCI trajectory
    if cci is not None and "CCI_s" in cci:
        fig, ax = plt.subplots(figsize=(6, 3.2))
        sns.lineplot(data=cci, x="window_idx", y="CCI_s", marker="o", ax=ax)
        ax.set_xlabel("Window"); ax.set_ylabel("CCI$_s$")
        ax.set_title("Code Co-Presence Index across windows")
        fig.tight_layout(); fig.savefig(os.path.join(OUT_FIG, "fig5_cci.png"), dpi=DPI); plt.close(fig)

    log.info("figures written to %s", OUT_FIG)


if __name__ == "__main__":
    from py_01_load_data import load_all
    from py_02_segment_summary import summarize
    feats, f0, _, _ = load_all()
    summary, frames = summarize(feats, f0)
    cci = None
    p = os.path.join(OUT_TAB, "cci_window_results.csv")
    if os.path.exists(p):
        cci = pd.read_csv(p)
    make_figures(summary, frames, cci)
    print("figures:", sorted(os.listdir(OUT_FIG)))
