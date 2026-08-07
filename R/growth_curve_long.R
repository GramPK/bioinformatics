library(tidyverse)
library(growthcurver)

##########################################
input_path = "FILE PATH"
symbol_size = 5
axis_text_size = 17
axis_title_text_size = 18
x_scale = c(0, 96)
legend_position = c(0.1, 0.9)
legend_text_size = 13
color = c("#212c3e", "#d95d5b", "#8e99ab")
##########################################

# Input .csv file format (example)
# | name | rep | time | OD600 |
# |------|-----|------|-------|
# | glucose | 1 | 0 | 0.01 |
# | glucose | 2 | 0 | 0.03 |
# | fructose | 1 | 0 | 0.02 |
# | fructose | 2 | 0 | 0.04 |

# Read data
OD_raw = read_csv(input_path) %>%
  select(name, rep, time, OD600) %>%
  drop_na(OD600)

OD_summary = OD_raw %>%
  group_by(time, name) %>%
  summarise(n = n(),
            mean_OD = mean(OD600),
            SD_OD = sd(OD600),
            .groups = "drop"
            )

# Fit growth curve
name = unique(OD_summary$name)

fit_list = vector(mode = "list", length = length(name))

for (i in seq_along(name)) {
  data = OD_summary %>%
    filter(name == name[i]) %>%
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
    name = name[i]
  )
  }

OD_fit = bind_rows(fit_list)

# Make a figure
ggplot(OD_summary, aes(x = time, y = mean_OD, color = name)) + 
  geom_point(size = symbol_size) +
  scale_color_manual(values = color) + 
  geom_line(
    data = OD_fit, 
    aes(x = time, y = fit_growth, color = name), 
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
u_list = OD_raw %>%
  group_by(name, rep) %>%
  arrange(time, .by_group = TRUE) %>%
  group_modify(~ {
    fit = SummarizeGrowth(.x$time, .x$OD600)
    tibble(u = fit$vals$r)
    }) %>%
  ungroup()

u_summary = u_list %>%
  group_by(name) %>%
  summarise(
    n = n(), 
    mean_u = mean(u, na.rm = TRUE), 
    SD_u = sd(u, na.rm = TRUE),
    .groups = "drop"
  )

u_summary
