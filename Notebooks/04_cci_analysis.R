## =====================================================================
## 04_cci_analysis.R — Code Co-Presence Index (CCI_s)
## CCI_s(window) = 1 - |A - B| / (A + B)
## where A and B are the token counts (or durations) of the two
## co-present codes inside the window:
##   1 = perfectly balanced co-presence ; 0 = a single code only.
## A per-window trajectory is tested for a rising (convergence) trend.
##
## Input (real data, optional):
##   data/code_counts.csv  -> window_id, segment, code_a, code_b
##   data/code_tokens.csv  -> window_id, segment, code, tokens  (long form)
## Fallback: data/demo/code_counts_demo.csv ships with the repo so the
## pipeline runs end-to-end before real annotations are inserted.
## =====================================================================
source("00_setup.R")

cci_s <- function(A, B) {
  ifelse(A + B == 0, NA_real_, 1 - abs(A - B) / (A + B))
}

find_input <- function(...) {
  for (p in list(...)) if (file.exists(p)) return(p)
  NULL
}

wide_path <- find_input(file.path(DATA_DIR, "code_counts.csv"),
                        file.path(ROOT, "data", "code_counts.csv"))
long_path <- find_input(file.path(DATA_DIR, "code_tokens.csv"),
                        file.path(ROOT, "data", "code_tokens.csv"))
demo_path <- file.path(ROOT, "data", "demo", "code_counts_demo.csv")

if (!is.null(wide_path)) {
  cc <- readr::read_csv(wide_path, show_col_types = FALSE)
  if (!all(c("window_id", "segment", "code_a", "code_b") %in% names(cc)))
    stop("code_counts.csv must contain: window_id, segment, code_a, code_b",
         call. = FALSE)
} else if (!is.null(long_path)) {
  cc <- readr::read_csv(long_path, show_col_types = FALSE) %>%
    tidyr::pivot_wider(id_cols = c(window_id, segment),
                       names_from = code, values_from = tokens,
                       values_fill = 0)
  code_cols <- setdiff(names(cc), c("window_id", "segment"))
  stopifnot(length(code_cols) == 2L)
  cc <- cc[, c("window_id", "segment", code_cols)]
  names(cc)[3:4] <- c("code_a", "code_b")
} else {
  message("04 : no real annotation file found -> using DEMO data (",
          demo_path, "). Replace data/demo/code_counts_demo.csv with real",
          " annotations (see README_R.md) before publishing results.")
  cc <- readr::read_csv(demo_path, show_col_types = FALSE)
}

res <- cc %>%
  mutate(CCI_s = cci_s(code_a, code_b)) %>%
  arrange(window_id) %>%
  mutate(window_idx = dplyr::row_number())
readr::write_csv(res, file.path(OUT_TAB, "cci_window_results.csv"))

seg_cci <- res %>%
  group_by(segment) %>%
  summarise(n_windows = n(),
            CCI_mean = mean(CCI_s, na.rm = TRUE),
            CCI_sd   = sd(CCI_s, na.rm = TRUE), .groups = "drop")
readr::write_csv(seg_cci, file.path(OUT_TAB, "cci_segment_summary.csv"))

## ---- convergence tests (co-presence should grow across windows) ------------
w  <- res %>% filter(is.finite(CCI_s))
conv <- tibble(n_windows = nrow(w))
if (nrow(w) >= 3) {
  fit <- lm(CCI_s ~ window_idx, data = w)
  sp  <- suppressWarnings(cor.test(w$window_idx, w$CCI_s,
                                   method = "spearman"))
  half  <- floor(nrow(w) / 2)
  d_val <- if (half >= 2 && (nrow(w) - half) >= 2)
    cohens_d(w$CCI_s[seq_len(half)], w$CCI_s[(half + 1):nrow(w)]) else NA_real_
  conv <- conv %>%
    mutate(lm_slope = unname(coef(fit)[2L]),
           lm_p     = broom::tidy(fit)$p.value[2L],
           spearman_rho = unname(sp$estimate),
           spearman_p   = sp$p.value,
           cohen_d_late_vs_early = d_val)
} else {
  conv <- conv %>% mutate(lm_slope = NA_real_, lm_p = NA_real_,
                          spearman_rho = NA_real_, spearman_p = NA_real_,
                          cohen_d_late_vs_early = NA_real_)
}
readr::write_csv(conv, file.path(OUT_TAB, "cci_convergence.csv"))
cat("04_cci_analysis.R : CCI_s computed for", nrow(res), "windows.\n")
print(as.data.frame(seg_cci))
print(as.data.frame(conv))
