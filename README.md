
# Simulated-Code-Convergence-TTS-chacah

Simulated Code-Convergence in Synthetic Vocal Performance

This repository accompanies the research paper **"Simulated Code-Convergence in Synthetic Vocal Performance,"** which investigates how synthetic speech systems (TTS) handle **code-convergence**—the stylistic alignment of vocal features across different language or dialectic codes—using Burna Boy and Travis Scott as primary case studies.

---

## 🎨 Graphical Abstract

![Graphical Abstract](Figures/ga.png)

---


## 📊 Empirical Analysis & Results

The following tables summarize the quantitative findings regarding acoustic stability and code-convergence indices.

### 1. Acoustic Stability & Variance Ratios
This table demonstrates the impact of signal processing on variance, confirming that convergence is a robust phenomenon.

| Analysis Stage | Variance Ratio ($\sigma^2_{conv} / \sigma^2_{target}$) | Signal Integrity | Status |
| :--- | :---: | :---: | :---: |
| **Raw Synthesis** | $2.11\times$ | High Noise / Unfiltered | ⚠️ Unstable |
| **Median-Filtered** | $2.60\times$ | Optimized for Outliers | ✅ Refined |
| **Pitch-Corrected (Final)** | $\mathbf{1.62\times}$ | **Robust Convergence** | ⭐ **Optimal** |

<br>

### 2. Code Co-Presence Index (CCI) Metrics
---
The CCI measures the degree of stylistic alignment between the synthetic output and the target linguistic codes.

| Convergence State | $\text{CCI}_s$ Value | Acoustic Interpretation | Sociolinguistic Meaning |
| :--- | :---: | :--- | :--- |
| **Perfect Convergence** | `1.00` | Balanced Code Presence | Maximum stylistic mimicry |
| **Moderate Convergence** | `0.50 - 0.85` | Partial Code Interaction | Hybrid stylistic profile |
| **Minimal Convergence** | `0.10 - 0.45` | Code Dominance | Weak convergence detected |
| **Absolute Dominance** | `0.00` | Single-Code Output | No stylistic convergence |
---
## 🔬 Methodology Pipeline

The technical framework operates across **6 distinct stages**—from signal acquisition to synthetic convergence verification.

![Methodology](Figures/1.png)
**Figure 1:** Six-stage methodological workflow (Acquisition → Stylistic Analysis → Convergence Modeling → Synthesis → Verification → Evaluation).

---

## 📈 Visual Empirical Evidence

| Figure | Content / Description | File Location |
| :---: | :--- | :--- |
| **Figure 2** | Code Co-Presence Index (CCI) distribution across segments | `Figures/2.png` |
| **Figure 3** | F0 pitch contour and tracking trajectories | `Figures/3.png` |
| **Figure 4** | Acoustic variance ratios across filtering stages | `Figures/4.png` |
| **Figure 5** | Multi-feature heatmap (RMS, SC, ZCR) | `Figures/5.png` |

---

## 📁 Repository Structure
```text
.
├── Figures/
│   ├── ga.png                           # Graphical Abstract
│   ├── 1.png                            # Figure 1: Methodology Flowchart
│   ├── 2.png                            # Figure 2: CCI Bar Chart
│   ├── 3.png                            # Figure 3: F0 Pitch Contour
│   ├── 4.png                            # Figure 4: Variance Ratios
│   ├── 5.png                            # Figure 5: Feature Heatmap
│   ├── f0_median_filter_comparison.png  # Diagnostic: Median Filter Analysis
│   └── f0_visual_inspection.png         # Diagnostic: Visual F0 Inspection
├── data/
│   ├── acoustic_feature_data.xlsx       # Master Excel Workbook (6 Sheets)
│   ├── acoustic_summary.csv             # Summary Statistics Table
│   ├── data_dictionary.csv              # Full Field Metadata
│   ├── features_master_frame_features.csv # Master Frame-Level Features
│   ├── feats_frame_features.csv         # Core Acoustic Features (RMS, SC, ZCR)
│   ├── f0_hz.csv                        # Extracted Fundamental Frequency (10 ms hop)
│   └── y_waveform.csv                   # Normalized Waveform Time-Series
└── README.md
