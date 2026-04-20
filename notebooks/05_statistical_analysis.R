library(tidyverse)
library(viridis)

df <- read_csv("~/marine-biodiversity-analysis/data/orcinus_orca_clean.csv")
cat("Records loaded:", nrow(df), "\n")

yearly <- df %>%
  filter(!is.na(date_year)) %>%
  group_by(date_year) %>%
  summarise(count = n()) %>%
  arrange(date_year)

print(yearly)

mann_kendall <- function(x) {
  n <- length(x)
  s <- 0
  for (i in 1:(n-1)) {
    for (j in (i+1):n) {
      s <- s + sign(x[j] - x[i])
    }
  }
  var_s <- n*(n-1)*(2*n+5)/18
  z <- ifelse(s > 0, (s-1)/sqrt(var_s),
              ifelse(s < 0, (s+1)/sqrt(var_s), 0))
  p_value <- 2*(1-pnorm(abs(z)))
  
  cat("Mann-Kendall Test\n")
  cat("S statistic:", s, "\n")
  cat("Z score:", round(z, 4), "\n")
  cat("p-value:", round(p_value, 6), "\n")
  cat("Trend:", ifelse(p_value < 0.05, 
                       ifelse(s > 0, "Significant INCREASING trend", "Significant DECREASING trend"),
                       "No significant trend"), "\n")
}

mann_kendall(yearly$count)

ggplot(yearly, aes(x = date_year, y = count)) +
  geom_bar(stat = "identity", fill = "#1a6b8a", alpha = 0.8) +
  geom_smooth(method = "loess", color = "#e31a1c", se = TRUE) +
  labs(
    title = "Orcinus orca — Annual Occurrence Records (OBIS)",
    subtitle = "Mann-Kendall: Z = 9.81, p < 0.001 — Significant increasing trend",
    x = "Year",
    y = "Number of Records"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = 14))

ggsave("~/marine-biodiversity-analysis/figures/05_temporal_trend_R.png", 
       dpi = 150, width = 12, height = 6)

df_hemi <- df %>%
  filter(!is.na(decimalLatitude)) %>%
  mutate(hemisphere = ifelse(decimalLatitude >= 0, "Northern", "Southern"))

# Resumen por hemisferio
df_hemi %>%
  group_by(hemisphere) %>%
  summarise(
    count = n(),
    mean_lat = round(mean(decimalLatitude), 2),
    sd_lat = round(sd(decimalLatitude), 2)
  ) %>%
  print()

# Visualización
ggplot(df_hemi, aes(x = decimalLatitude, fill = hemisphere)) +
  geom_histogram(bins = 60, alpha = 0.8, position = "identity") +
  scale_fill_manual(values = c("Northern" = "#1a6b8a", "Southern" = "#e31a1c")) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "black", linewidth = 0.8) +
  labs(
    title = "Orcinus orca — Latitudinal Distribution by Hemisphere",
    x = "Latitude",
    y = "Number of Records",
    fill = "Hemisphere"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = 14))

ggsave("~/marine-biodiversity-analysis/figures/06_latitudinal_hemispheres_R.png",
       dpi = 150, width = 12, height = 6)