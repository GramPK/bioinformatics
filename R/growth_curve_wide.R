library(tidyverse)
library(growthcurver)

#################################
input_path = "FILE PATH"
symbol_size = 4
axis_text_size = 15
axis_title_text_size = 17
x_scale = c(0, 96)
legend_position = c(0.1, 0.9)
legend_text_size = 13
color = c("#d95d5b", "#8e99ab")
#################################

# Input .csv file format (example)
# | time | glucose_1 | glucose_2 | glucose_3 | fructose_1 | fructose_2 | fructose_3 |
# |------|-----------|-----------|-----------|------------|------------|------------|
# | 0 | 0.02 | 0.03 | 0.01 | 0.02 | 0.02 | 0.01 |

# Read data
OD_raw = read_csv(input_path)

OD_summary = pivot_longer(
  OD_raw, 
  cols = -time, 
  names_to = "condition", 
  values_to = "OD600",
  values_drop_na = TRUE
  ) %>%
  mutate(condition = str_remove(condition, "_\\d+$")) %>%
  group_by(time, condition) %>%
  summarise(n = n(), 
            mean_OD = mean(OD600), 
            SD_OD = sd(OD600), 
            .groups = "drop"
            )

# Fit growth curve
condition = unique(OD_summary$condition)

fit_list = vector(mode = "list", length = length(condition))

for (i in seq_along(condition)) {
  data = OD_summary %>%
    filter(condition == condition[i]) %>%
    arrange(time)
  fit = SummarizeGrowth(data$time, data$mean_OD)
  k = fit$vals$k
  n0 = fit$vals$n0
  r = fit$vals$r
  t = seq(min(data$time), max(data$time), length.out = 200)
  curve = k / (1 + ((k - n0) / n0) * exp(-r * t))
  fit_list[[i]] = data.frame(
    time = t, 
    fit_growth = curve, 
    condition = condition[i]
  )
  }

OD_fit = bind_rows(fit_list)

# Make a figure
ggplot(OD_summary, aes(x = time, y = mean_OD, color = condition)) + 
  geom_point(size = symbol_size) +
  scale_color_manual(values = color) + 
  geom_line(
    data = OD_fit, 
    aes(x = time, y = fit_growth, color = condition), 
    linewidth = 0.5
    ) +
  geom_errorbar(aes(ymin = mean_OD - SD_OD, ymax = mean_OD + SD_OD)) + 
  xlab("Time (h)") +
  ylab("OD600") +
  scale_x_continuous(limits = x_scale) + 
  theme(
    panel.background = element_rect(fill = "white"),
    panel.border = element_rect(fill = "black", linewidth = 0.5),
    axis.text = element_text(size = axis_text_size),
    axis.title = element_text(size = axis_title_text_size),
    legend.title = element_blank(),
    legend.position = legend_position,
    legend.text = element_text(size = legend_text_size)
    )

# Calculate specific growth rates
sample = colnames(OD_raw)[colnames(OD_raw) != "time"]

u_list = data.frame(condition = sample, u = NA_real_)

for (i in seq_along(sample)) {
  data = data.frame(
    time = OD_raw$time, 
    OD600 = OD_raw[[sample[i]]]
  ) %>%
    filter(complete.cases(.))
  u_list$u[i] = SummarizeGrowth(data$time, data$OD600)$vals$r
}

sample_u = mutate(
  u_list, 
  condition = str_remove(u_list$condition, "_\\d+$")
  )

group_by(sample_u, condition) %>%
  summarise(n = n(), mean_u = mean(u), SD_u = sd(u), .groups = "drop")
