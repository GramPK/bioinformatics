library(tidyverse)

##########################################
input_path = "FILE PATH"
vial_vol = FLASK VOLUME (L)  # L
culture_vol = MEDIA VOLUME (L)  # L
culture_temp = 37  # Celcius degree
symbol_size = 5
axis_text_size = 17
axis_title_text_size = 18
x_scale = c(0, 96)
legend_position = c(0.1, 0.9)
legend_text_size = 13
color = c("#212c3e", "#d95d5b", "#8e99ab")

# Strandard curve
std = tribble(
  ~conc, ~area, ~ISTD,
  conc_1, area_1, ISTD_1,
  conc_2, area_2, ISTD_2,
  conc_3, area_3, ISTD_3,
  conc_4, area_4, ISTD_4,
  conc_5, area_5, ISTD_5
) %>%
  mutate(norm_area = area/ISTD) %>%
  lm(norm_area ~ conc, data = .)
##########################################

# Input .csv file format (example)
# | name | rep | time | OD600 | S |
# |------|-----|------|-------|---|
# | CO2 | 1 | 0 | 0.01 | 2680.3 |
# | CO2 | 2 | 0 | 0.03 | 2900.1 |

# Read data
# Ideal gas law n = PV/(RT). R = (L*atm/mmol/K)	0.000082
raw = read_csv(input_path) %>%
  mutate(
    mmol=(S/S_ISTD-coef(std[1])[1])/coef(std[1])[2]*(vial_vol-culture_vol)/0.000082/(273.15 + culture_temp)
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
