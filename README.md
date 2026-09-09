Simulated-Code-Convergence-TTS-chacah
Simulated Code-Convergence in Synthetic Vocal Performance

This repository accompanies the research paper “Simulated Code-Convergence in Synthetic Vocal Performance,” which investigates how synthetic speech systems (TTS) handle code-convergence—the stylistic alignment of vocal features across different language or dialectic codes—using Burna Boy and Travis Scott as primary case studies.

Graphical Abstract


Key Results

Metric	Raw	Median-Filtered	Pitch-Corrected
Variance Ratio	2.11×	2.60×	1.62×

CCI Component	Value
Code Co-Presence Index (max. convergence)	1.0
Complete code dominance	0.0
The corrected variance ratio confirms that synthetic convergence is robust beyond recording-level noise.

Methodology (Figure 1)
The technical pipeline is defined across 6 stages — from signal acquisition to synthesis verification.



Figure 1: Six-stage methodological workflow (Acquisition → Stylistic Analysis → Convergence Modeling → Synthesis → Verification → Evaluation).

Results (Figures 2–5)

Figure	Content	File
Figure 2	CCI bar chart across song segments	Figures/2.png
Figure 3	F0 pitch contour mapping	Figures/3.png
Figure 4	Variance ratios (Raw/Median/Corrected)	Figures/4.png
Figure 5	Feature heatmap (RMS, SC, ZCR)	Figures/5.png
Data Structure
📁 /Figures/ — Visual Assets

File	Description
1.png	Methodology flowchart (6 stages)
2.png	CCI bar chart
3.png	F0 pitch contour
4.png	Variance ratio comparison
5.png	Feature heatmap
ga.png	Graphical Abstract
f0_median_filter_comparison.png	Median filter comparison
f0_visual_inspection.png	Visual F0 inspection
📁 /data/ — Research Data

File	Description
acoustic_feature_data.xlsx	Master workbook (6 sheets)
acoustic_summary.csv	Aggregated statistical summary
data_dictionary.csv	Field-level metadata
features_master_frame_features.csv	Frame-level master features (RMS, SC, ZCR)
feats_frame_features.csv	Frame-level spectral features
f0_hz.csv	Fundamental frequency (Hz), 10 ms hop
y_waveform.csv	Normalized raw waveform indices
Code Co-Presence Index (CCI)
We define convergence with the following balance metric:

CCI
𝑠
=
1
−
∣
Tokens
Code 
𝐴
−
Tokens
Code 
𝐵
∣
Tokens
Code 
𝐴
+
Tokens
Code 
𝐵
CCI 
s
​
 =1− 
Tokens 
Code A
​
 +Tokens 
Code B
​
 
∣Tokens 
Code A
​
 −Tokens 
Code B
​
 ∣
​
 

Usage
Load the master feature set in Python:

python
import pandas as pd

df = pd.read_csv('data/features_master_frame_features.csv')
print(df.head())
Reproduce the F0 contour:

python
import pandas as pd
import matplotlib.pyplot as plt

f0 = pd.read_csv('data/f0_hz.csv')
plt.plot(f0['frame_index'], f0['f0_hz'])
plt.xlabel('Frame (10 ms)')
plt.ylabel('F0 (Hz)')
plt.show()
Requirements
bash
pip install numpy pandas matplotlib seaborn
Citation
If you use this dataset or any figures in your research, please cite the forthcoming paper:

“Simulated Code-Convergence in Synthetic Vocal Performance.” (Author: Pegah Merrikhi)

License
© Pegah Merrikhi — Research use only.

