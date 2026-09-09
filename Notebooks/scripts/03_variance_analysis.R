## =====================================================================
## 03_variance_analysis.R — variance shrinkage & paper-ratio checks
## Tests whether F0 variance decreases from S1 to S4 (acoustic
## convergence), for the raw and the pitch-corrected (harmonic removal
## + rolling median) series, and compares the S1/S4 ratios against the
## values reported in the paper (raw 2.11x, pitch-corrected 1.62x).
## =====================================================================
source("00_setup.R")

summ <- readr::read_csv(file.path(OUT_TAB, "acoustic_summary_r.csv"),
                        show_col_types = FALSE) %>%
  mutate(seg = factor(seg, levels = SEG_NAMES)) %>%
  arrange(seg)

ratio_table <- tibble(
  measure = c("Raw F0 variance",
              "Pitch-corrected (harmonic + rolling-median)"),
  column  = c("f0_var", "f0_var_hemed"),
  var_S1  = NA_real_, var_S4 = NA_real_, ratio = NA_real_
)
for (i in seq_len(nrow(ratio_table))) {
  col <- ratio_table$column[i]
  v   <- summ[[col]]
  ratio_table$var_S1[i] <- v[summ$seg == "S1"]
  ratio_table$var_S4[i] <- v[summ$seg == "S4"]
  ratio_table$ratio[i]  <- v[summ$seg == "S1"] / v[summ$seg == "S4"]
}
readr::write_csv(ratio_table, file.path(OUT_TAB, "variance_ratios.csv"))

## ---- sanity check against the paper values ---------------------------------
check_ratio <- function(got, expected, label) {
  ok <- is.finite(got) &&
    abs(got - expected) / expected <= RATIO_TOL_REL
  message(sprintf("03 : %s ratio = %.3fx  (paper reports %.2fx) -> %s",
                  label, got, expected, if (ok) "OK" else
                    "MISMATCH - inspect filters / constants in 00_setup.R"))
  invisible(ok)
}
raw_r  <- ratio_table$ratio[1]
corr_r <- ratio_table$ratio[2]
check_ratio(raw_r,  EXPECT_RAW_RATIO,       "raw F0 variance")
check_ratio(corr_r, EXPECT_CORRECTED_RATIO, "pitch-corrected F0 variance")

## ---- monotonic trend across S1 -> S4 ---------------------------------------
vcols  <- c(raw = "f0_var", corrected = "f0_var_hemed")
trends <- list()
for (i in seq_along(vcols)) {
  nm <- names(vcols)[i]
  y  <- summ[[vcols[[i]]]]
  if (all(is.finite(y))) {
    sp  <- suppressWarnings(cor.test(seq_along(y), y, method = "spearman"))
    fit <- lm(log(y) ~ seq_along(y))
    sl  <- broom::tidy(fit) %>%
      filter(term == "seq_along(y)")
    trends[[nm]] <- tibble(measure = nm,
                           spearman_rho = unname(sp$estimate),
                           spearman_p   = sp$p.value,
                           log_slope    = sl$estimate,
                           slope_p      = sl$p.value)
  }
}
trend_tab <- dplyr::bind_rows(trends)
readr::write_csv(trend_tab, file.path(OUT_TAB, "variance_trends.csv"))
print(as.data.frame(ratio_table))
print(as.data.frame(trend_tab))
