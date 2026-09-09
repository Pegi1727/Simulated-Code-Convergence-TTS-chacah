## =====================================================================
## 02_segment_summary.R — S1-S4 acoustic summary (re-computation in R)
## Reproduces acoustic_summary.csv from frame data:
##   * 4 equal-time segments over DURATION_S seconds
##   * F0 variance under four filter strategies:
##       raw | IQR-outlier removal | 169-Hz harmonic removal |
##       rolling-median (+harmonic removal)  [= "pitch-corrected"]
## If the shipped acoustic_summary.csv exists, both versions are compared.
## =====================================================================
source("00_setup.R")

rds_csv <- file.path(OUT_TAB, "dat_csv.rds")
rds_npz <- file.path(OUT_TAB, "dat_npz.rds")
dat <- if (file.exists(rds_csv)) readRDS(rds_csv) else
  if (file.exists(rds_npz)) readRDS(rds_npz) else
    stop("Run 01_load_data_csv.R or 01b_load_data_npz.R first.", call. = FALSE)

frame_data <- dat$feats %>%
  mutate(seg    = factor(paste0("S", findInterval(frame_time_s, SEG_BOUNDS_S,
                                                  all.inside = TRUE)),
                         levels = SEG_NAMES),
         voiced = !is.na(f0_hz),
         harm   = voiced & abs(f0_hz - HARMONIC_169_HZ) <= HARMONIC_TOL_HZ)

med_sm <- function(x) zoo::rollmedian(x, k = MED_K, fill = NA)

segment_stats <- function(d) {
  fv  <- d$f0_hz[d$voiced]
  fv_iqr <- if (length(fv) > 1) {
    q  <- quantile(fv, probs = c(0.25, 0.75), na.rm = TRUE)
    lo <- q[[1L]] - 1.5 * diff(q)
    hi <- q[[2L]] + 1.5 * diff(q)
    fv[fv >= lo & fv <= hi]
  } else numeric(0)
  kept <- d[d$voiced & !d$harm, , drop = FALSE]
  data.frame(
    start = min(d$frame_time_s), end = max(d$frame_time_s),
    nframes = nrow(d),
    f0_mean  = mean(fv),
    f0_var   = var(fv),
    f0_var_med = var(med_sm(d$f0_hz)[d$voiced & !is.na(med_sm(d$f0_hz))]),
    f0_var_iqr = if (length(fv_iqr) > 1) var(fv_iqr) else NA_real_,
    rms_mean = mean(d$rms),
    sc_mean  = mean(d$spectral_centroid_hz),
    zcr_mean = mean(d$zcr),
    he169_count = sum(d$harm),
    f0_var_he169 = if (nrow(kept) > 1) var(kept$f0_hz) else NA_real_,
    hemed_count  = nrow(kept),
    f0_var_hemed = if (nrow(kept) > 1)
      var(med_sm(kept$f0_hz), na.rm = TRUE) else NA_real_
  )
}

summ <- frame_data %>%
  split(.$seg) %>%
  lapply(segment_stats) %>%
  dplyr::bind_rows(.id = "seg")

readr::write_csv(summ, file.path(OUT_TAB, "acoustic_summary_r.csv"))

## ---- compare with the shipped summary (when available) ---------------------
if (!is.null(dat$summary)) {
  num_cols <- intersect(names(dat$summary), names(summ))
  num_cols <- setdiff(num_cols, "seg")
  cmp <- dplyr::inner_join(dat$summary, summ, by = "seg",
                           suffix = c(".orig", ".r"))
  max_dev <- 0
  for (v in num_cols) {
    dev <- max(abs(cmp[[paste0(v, ".orig")]] - cmp[[paste0(v, ".r")]]),
               na.rm = TRUE)
    max_dev <- max(max_dev, dev)
  }
  cat(sprintf(paste0("02_segment_summary.R : recomputed S1-S4 summary; ",
                     "max abs. deviation from shipped CSV = %.4g\n"),
              max_dev))
} else {
  cat("02_segment_summary.R : recomputed S1-S4 summary (shipped CSV absent).\n")
}
print(as.data.frame(summ))
