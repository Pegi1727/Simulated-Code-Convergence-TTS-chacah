
# Simulated-Code-Convergence-TTS-chacah

Simulated Code-Convergence in Synthetic Vocal Performance

This repository accompanies the research paper **"Simulated Code-Convergence in Synthetic Vocal Performance,"** which investigates how synthetic speech systems (TTS) handle **code-convergence**—the stylistic alignment of vocal features across different language or dialectic codes—using Burna Boy and Travis Scott as primary case studies.

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.22669208.svg)](https://doi.org/10.5281/zenodo.22669208)
[![GitHub Release](https://img.shields.io/badge/release-v0.1.0-blue)](https://github.com/Pegi1727/Simulated-Code-Convergence-TTS-chacah/releases)

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

## 🧠 Conclusion & Discussion

This study demonstrates that **synthetic vocal systems**—although *functionally inert* with respect to social intention—systematically reproduce measurable **code-convergence** patterns. Through the application of the **Code Co-Presence Index (CCI)** and multi-stage acoustic variance analysis, we establish three central findings:

1.  **Convergence is Quantifiable:** The proposed metric provides a robust, token-level measure of stylistic alignment between synthetic outputs and target dialectic codes, effectively bridging acoustics and sociolinguistic theory.
2.  **Convergence is Robust:** While raw synthesis exhibits elevated variance ($2.11\times$), pitch-correction substantially normalizes the signal to a stable ratio of $1.62\times$, demonstrating that convergence persists beyond recording-level noise and is not merely a tracking artifact.
3.  **Synthetics Reflect—Not Produce—Social Meaning:** Confirming the thesis of **Algorithmic Indexicality**, the observed convergence reflects the *indexical field* of the training data (Artists: Burna Boy, Travis Scott) rather than emergent sociolinguistic agency within the system itself.

### 🎯 Contributions
| Contribution | Description |
| :--- | :--- |
| **Methodological** | A 6-stage pipeline for synthetic code-convergence measurement |
| **Theoretical** | Formal integration of Communication Accommodation Theory (CAT) into TTS analysis |
| **Practical** | Open, reproducible dataset for future work in synthetic sociolinguistics |

### 📎 Limitations & Future Work
- **Corpus Scope:** Currently limited to two artist-centric codes; future work will expand to multi-dialect and gender-parametric synthesis.
- **Neural Architectures:** The analysis is agnostic to the underlying TTS architecture; extending to diffusion-based vocoders is a natural next step.
- **Perceptual Validation:** The hypothesis would be strengthened by listening tests (ABX laddering) to correlate acoustic convergence with perceived stylistic mimicry.

> *This work contributes a formal, measurable foundation for the emerging field of **Synthetic Sociolinguistics**, opening the door to research on how algorithmic voices reshape — yet never autonomously intend — social style.*

---
## 📜 Citation

If you use this dataset, methodology, or figures in your academic research, please cite:

> **Merrikhi, P. (2026).** *Simulated Code-Convergence in Synthetic Vocal Performance.* Working Paper / Synthetic Sociolinguistics Repository. Available at: [10.5281/zenodo.22669208](https://doi.org/10.5281/zenodo.22669208)
---




## 📁 Repository Structure
```text
.
├── Figures/
│   ├── ga.png                           # Graphical Abstract
│   ├── 1.png                            # Figure 1: Methodology Flowchart (6-Stage Pipeline)
│   ├── 2.png                            # Figure 2: Code Co-Presence Index (CCI) Distribution
│   ├── 3.png                            # Figure 3: F0 Pitch Contour & Trajectories
│   ├── 4.png                            # Figure 4: Acoustic Variance Ratios (Raw vs. Filtered vs. Corrected)
│   ├── 5.png                            # Figure 5: Multi-Feature Heatmap (RMS, SC, ZCR)
│   ├── f0_median_filter_comparison.png  # F0 Median Filtering Comparison
│   └── f0_visual_inspection.png         # Visual Inspection of F0 Contours
│
├── data/
│   ├── raw/
│   │   ├── feats.npz                    # Primary acoustic frame-level feature arrays
│   │   ├── f0.npy                       # Raw fundamental frequency trajectory
│   │   ├── features.npz                 # Secondary/Master acoustic feature arrays
│   │   └── y.npy                        # Synthesized audio waveform array
│   ├── processed/
│   │   ├── acoustic_summary.csv         # Summary statistics across segments S1–S4
│   │   ├── f0_hz.csv                    # Calibrated fundamental frequency (Hz)
│   │   ├── feats_frame_features.csv     # Tabular frame-level acoustic features
│   │   ├── features_master_frame_features.csv # Aggregated multi-feature dataset
│   │   ├── y_waveform.csv               # Exported waveform amplitude series
│   │   └── acoustic_feature_data.xlsx   # Consolidated Excel workbook
│   └── demo/
│       ├── code_counts_demo.csv         # Synthetic demo corpus for CCI benchmarking
│       └── data_dictionary.csv          # Metadata and acoustic variable codebook
│
├── codes/
│   ├── R/
│   │   ├── 00_setup.R                   # Environment setup and CRAN dependencies
│   │   ├── 01_load_data_csv.R           # CSV ingestion and validation pipeline
│   │   ├── 01b_load_data_npz.R          # NPZ/NPY binary data interface
│   │   ├── 02_segment_summary.R         # Segment-level parametric aggregation
│   │   ├── 03_variance_analysis.R       # Acoustic variance ratio computation
