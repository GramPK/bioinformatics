library(tidyverse)

##########################################
input_path = "FILE PATH"
culture_vol = CULTURE VOLUME  # L
symbol_size = 5
axis_text_size = 17
axis_title_text_size = 18
x_scale = c(0, 96)
y_scale = c(0, 2.2)
legend_position = c(0.1, 0.7)
legend_text_size = 13
color = c("#212c3e", "#d95d5b", "#8e99ab")

std = tribble(
  ~conc, ~area, ~ISTD,
  conc1, area1, ISTD1,
  conc2, area2, ISTD2,
  conc3, area3, ISTD3,
  conc4, area4, ISTD4,
  conc5, area5, ISTD5
) %>%
  mutate(norm_area = area/ISTD) %>%
  lm(norm_area ~ conc, data = .)
##########################################

# Input .csv file format (example)
# | name | rep | time | OD600 | S | S_ISTD |
# |------|-----|------|-------|---|--------|
# | glucose | 1 | 0 | 0.01 | 30.0 | 10.3 |
# | glucose | 2 | 0 | 0.03 | 31.2 | 12.1 |

# Read data
raw = read_csv(input_path) %>%
  mutate(
    mmol=(S/S_ISTD-coef(std[1])[1])/coef(std[1])[2]*culture_vol
    )

summary = raw %>%
  group_by(time, name) %>%
  summarise(n = n(), mean = mean(mmol), SD = sd(mmol), .groups = "drop")

# Make a figure
ggplot(summary, aes(x = time, y = mean, color = name)) + 
  geom_point(size = symbol_size) +
  scale_color_manual(values = color) + 
  geom_line(linewidth = 0.5) +
  geom_errorbar(aes(ymin = mean - SD, ymax = mean + SD)) + 
  xlab("Time (h)") +
  scale_x_continuous(limits = x_scale) + 
  scale_y_continuous(limits = y_scale) +
  theme(
    panel.background = element_rect(fill = "white"),
    panel.border = element_rect(fill = "black", linewidth = 0.5),
    axis.text = element_text(size = axis_text_size),
    axis.title = element_text(size = axis_title_text_size),
    legend.title = element_blank(),
    legend.position = legend_position,
    legend.text = element_text(size = legend_text_size)
    )

# Calculate S consumption rates (qS, mmol/h/g CDW)
rate = raw %>%
  group_by(name, rep) %>%
  arrange(time) %>%
  mutate(
    qS = (lag(mmol) - mmol) / (time - lag(time)) / (OD600 + lag(OD600)) * 2
    )
