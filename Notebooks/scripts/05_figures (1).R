## =====================================================================
## 05_figures.R — publication figures -> out/figures/*.png (300 dpi)
## fig1 frame-level feature time series (4 panels)
## fig2 voiced F0 distribution by segment S1-S4
## fig3 variance decline + S1/S4 ratios (raw vs pitch-corrected)
## fig4 CCI_s trajectory across windows
## fig5 z-scored segment-level metric heatmap
## fig6 raw F0 contour with rolling-median overlay and 169-Hz marker
## =====================================================================
source("00_setup.R")

rds_csv <- file.path(OUT_TAB, "dat_csv.rds")
rds_npz <- file.path(OUT_TAB, "dat_npz.rds")
dat <- if (file.exists(rds_csv)) readRDS(rds_csv) else
  if (file.exists(rds_npz)) readRDS(rds_npz) else
    stop("Ingest data first (01 or 01b).", call. = FALSE)

summ   <- readr::read_csv(file.path(OUT_TAB, "acoustic_summary_r.csv"),
                          show_col_types = FALSE)
ratios <- readr::read_csv(file.path(OUT_TAB, "variance_ratios.csv"),
                          show_col_types = FALSE)
cci    <- readr::read_csv(file.path(OUT_TAB, "cci_window_results.csv"),
                          show_col_types = FALSE)
feats  <- dat$feats %>%
  mutate(voiced = !is.na(f0_hz),
         seg = factor(paste0("S", findInterval(frame_time_s, SEG_BOUNDS_S,
                                               all.inside = TRUE)),
                      levels = SEG_NAMES))

## ---- fig 1 : frame-level acoustic features ---------------------------------
f1a <- feats %>% slice(seq(1L, n(), by = 2L)) %>%
  ggplot(aes(frame_time_s, rms)) +
  geom_line(alpha = 0.35, linewidth = 0.3) +
  labs(x = "Time (s)", y = "RMS") + theme_paper()
f1b <- feats %>% slice(seq(1L, n(), by = 2L)) %>%
  ggplot(aes(frame_time_s, spectral_centroid_hz)) +
  geom_line(alpha = 0.35, linewidth = 0.3, colour = "#1b7837") +
  labs(x = "Time (s)", y = "Spectral centroid (Hz)") + theme_paper()
f1c <- feats %>% slice(seq(1L, n(), by = 2L)) %>%
  ggplot(aes(frame_time_s, zcr)) +
  geom_line(alpha = 0.35, linewidth = 0.3, colour = "#762a83") +
  labs(x = "Time (s)", y = "ZCR") + theme_paper()
f1d <- feats %>% slice(seq(1L, n(), by = 2L)) %>%
  ggplot(aes(frame_time_s, f0_hz, colour = voiced)) +
  geom_point(size = 0.4, alpha = 0.4) +
  scale_colour_manual(values = c("TRUE" = "#2166ac", "FALSE" = "grey70")) +
  labs(x = "Time (s)", y = "F0 (Hz)", colour = "voiced") + theme_paper()
fig1 <- (f1a | f1b) / (f1c | f1d) +
  patchwork::plot_annotation(
    title = "Frame-level acoustic features (hop ~93 ms, sr = 16 kHz)")
ggsave(file.path(OUT_FIG, "fig1_frame_features.png"), fig1,
       width = 10, height = 7, dpi = 300)

## ---- fig 2 : voiced F0 by segment -------------------------------------------
fig2 <- feats %>% filter(voiced) %>%
  ggplot(aes(seg, f0_hz, fill = seg)) +
  geom_violin(alpha = 0.55) +
  geom_boxplot(width = 0.15, outlier.shape = NA, alpha = 0.8) +
  geom_hline(yintercept = HARMONIC_169_HZ, linetype = 2,
             colour = "firebrick", linewidth = 0.5) +
  labs(x = "Segment", y = "Voiced F0 (Hz)",
       title = "F0 distribution across segments (S1 -> S4)",
       subtitle = "Dashed line: 169-Hz harmonic artifact") +
  theme_paper() + theme(legend.position = "none")
ggsave(file.path(OUT_FIG, "fig2_f0_by_segment.png"), fig2,
       width = 7.5, height = 5.5, dpi = 300)

## ---- fig 3 : variance decline and ratios --------------------------------------
var_long <- summ %>%
  select(seg, raw = f0_var, corrected = f0_var_hemed) %>%
  tidyr::pivot_longer(-seg, names_to = "measure", values_to = "variance") %>%
  group_by(measure) %>%
  mutate(norm = variance / variance[seg == "S1"]) %>%
  ungroup()

p3a <- var_long %>%
  ggplot(aes(seg, norm, colour = measure, group = measure)) +
  geom_line(linewidth = 0.8) +
  geom_point(size = 2.4) +
  geom_hline(yintercept = 1, linetype = 3) +
  scale_colour_manual(values = c(raw = "#2166ac", corrected = "#1b7837"),
                      labels = c(raw = "Raw F0",
                                 corrected = "Pitch-corrected")) +
  labs(x = "Segment", y = "Variance (S1 = 1)",
       title = "F0 variance decline S1 -> S4",
       colour = NULL) + theme_paper()

ratios_plot <- ratios %>%
  mutate(label = sprintf("%.2fx", ratio))
p3b <- ratios_plot %>%
  ggplot(aes(measure, ratio, fill = measure)) +
  geom_col(alpha = 0.85, width = 0.6) +
  geom_text(aes(label = label), vjust = -0.4, fontface = "bold") +
  geom_hline(yintercept = 1, linetype = 3) +
  coord_cartesian(ylim = c(0, max(ratios_plot$ratio, na.rm = TRUE) * 1.15)) +
  scale_fill_manual(values = c("#2166ac", "#1b7837")) +
  scale_x_discrete(labels = c("Raw F0 variance" = "Raw",
                              "Pitch-corrected (harmonic + rolling-median)" =
                                "Pitch-corrected")) +
  labs(x = NULL, y = "S1 / S4 variance ratio",
       title = "Convergence ratios (paper: 2.11x / 1.62x)") +
  theme_paper() + theme(legend.position = "none")
fig3 <- p3a | p3b
ggsave(file.path(OUT_FIG, "fig3_variance_ratios.png"), fig3,
       width = 10.5, height = 4.8, dpi = 300)

## ---- fig 4 : CCI_s trajectory --------------------------------------------------
fig4 <- cci %>%
  ggplot(aes(window_idx, CCI_s)) +
  geom_line(colour = "grey60", linewidth = 0.5) +
  geom_point(aes(colour = segment), size = 2.2, alpha = 0.9) +
  geom_smooth(method = "lm", se = TRUE, colour = "black",
              linetype = "dashed", linewidth = 0.6, alpha = 0.12) +
  scale_x_continuous(breaks = function(lim) pretty(lim)) +
  labs(x = "Window index", y = expression(CCI[s]),
       colour = "Segment",
       title = "Code co-presence trajectory (rising CCI_s = convergence)") +
  theme_paper()
ggsave(file.path(OUT_FIG, "fig4_cci_trajectory.png"), fig4,
       width = 8, height = 5.2, dpi = 300)

## ---- fig 5 : z-scored segment-metric heatmap ------------------------------------
mcols <- c("f0_var", "f0_var_med", "f0_var_iqr",
           "f0_var_he169", "f0_var_hemed")
hm <- summ %>%
  select(seg, dplyr::all_of(mcols)) %>%
  tidyr::pivot_longer(-seg, names_to = "metric", values_to = "value") %>%
  group_by(metric) %>%
  mutate(z = if (sd(value, na.rm = TRUE) > 0)
    as.numeric(scale(value)) else 0) %>%
  ungroup() %>%
  mutate(metric = factor(metric, levels = rev(mcols)),
         seg    = factor(seg, levels = SEG_NAMES))

fig5 <- hm %>%
  ggplot(aes(seg, metric, fill = z)) +
  geom_tile(colour = "white", linewidth = 0.8) +
  geom_text(aes(label = sprintf("%.0f", value)), size = 3.2) +
  scale_fill_gradient2(low = "#2166ac", mid = "white", high = "#b2182b",
                       midpoint = 0, name = "z-score") +
  labs(x = "Segment", y = NULL,
       title = "Segment-level F0 variance metrics (z-scored per row)") +
  theme_paper() + theme(axis.text.y = element_text(size = 8))
ggsave(file.path(OUT_FIG, "fig5_segment_heatmap.png"), fig5,
       width = 7.5, height = 4.6, dpi = 300)

## ---- fig 6 : F0 contour with median filter ---------------------------------------
f0_draw <- feats %>%
  mutate(med = zoo::rollmedian(f0_hz, MED_K, fill = NA))
fig6 <- f0_draw %>%
  ggplot(aes(frame_time_s)) +
  geom_line(aes(y = f0_hz), colour = "grey55", alpha = 0.5, linewidth = 0.3) +
  geom_line(aes(y = med),   colour = "#1b7837", linewidth = 0.6,
            na.rm = TRUE) +
  geom_hline(yintercept = HARMONIC_169_HZ, linetype = 2,
             colour = "firebrick", linewidth = 0.5) +
  geom_vline(xintercept = SEG_BOUNDS_S[2:(N_SEG)], linetype = 3,
             colour = "grey40") +
  labs(x = "Time (s)", y = "F0 (Hz)",
       title = "F0 contour with rolling-median overlay",
       subtitle = "Green: median-filtered (k = 5); red dashed: 169-Hz artifact") +
  theme_paper()
ggsave(file.path(OUT_FIG, "fig6_f0_median_overlay.png"), fig6,
       width = 10, height = 4.6, dpi = 300)

cat("05_figures.R : saved 6 figures in", OUT_FIG, "\n")
