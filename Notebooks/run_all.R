## =====================================================================
## run_all.R — end-to-end execution of the R pipeline
## 1. ingest data (CSV if present, otherwise raw .npz/.npy via reticulate)
## 2. segment summary -> variance analysis -> CCI -> figures
## 3. knit analysis_notebook.Rmd to out/analysis_notebook.html
## =====================================================================

if (file.exists(file.path("github_data", "feats_frame_features.csv")) ||
    file.exists("feats_frame_features.csv")) {
  source("01_load_data_csv.R")
} else {
  message("run_all.R : CSV exports not found - trying reticulate fallback ...")
  source("01b_load_data_npz.R")
}
source("02_segment_summary.R")
source("03_variance_analysis.R")
source("04_cci_analysis.R")
source("05_figures.R")

if (requireNamespace("rmarkdown", quietly = TRUE)) {
  rmarkdown::render("analysis_notebook.Rmd",
                    output_format = "html_document",
                    output_dir = "out",
                    quiet = FALSE)
  message("run_all.R : HTML report written to out/analysis_notebook.html")
} else {
  message("run_all.R : package 'rmarkdown' missing - open analysis_notebook.Rmd in RStudio and knit manually.")
}
cat("run_all.R : pipeline finished.\n")
