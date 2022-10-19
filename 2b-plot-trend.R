#library(sf)
#library(purrr)
library(dplyr)
library(lubridate)
library(ggplot2)
library(scales)

# Tutorial: https://www.ookla.com/articles/best-ookla-open-data-projects-2021

# Load data
trend <- readRDS("data/IDN_trend_quarterly.rds")

lab_text <- trend %>% 
  filter(quart_start == max(quart_start)) %>% 
  mutate(label = "Mbps",
         x = quart_start,
         y_d = avg_d_mbps,
         y_u = avg_u_mbps) %>% 
  select(type, label, x, y_d, y_u)

# Define colors and size
col_download <- colorspace::lighten("#2653af")
col_upload <- colorspace::lighten("#d45769")
graph_line_width = 0.9

# Set some global theme default
theme_set(theme_minimal())
theme_update(text = element_text(family = "Lato", color = "#464a62"))
theme_update(plot.title = element_text(hjust = 0.5, face = "bold"))
theme_update(plot.subtitle = element_text(hjust = 0.5))

# Wired / Mobile Network Performance, Indonesia
# Ookla® Open Datasets | 2022
data_filter = "mobile" # mobile|fixed 
ggplot(
  data = trend %>% filter(type == data_filter), 
  aes(x = quart_start)) +
  # Graph download speed
  geom_line(
    aes(y = avg_d_mbps),
    color = col_download,
    lwd = graph_line_width) +
  geom_point(
    aes(y = avg_d_mbps),
    color = col_download) +
  # Graph upload speed
  geom_line(
    aes(y = avg_u_mbps),
    color = col_upload,
    lwd = graph_line_width) +
  geom_point(
    aes(y = avg_u_mbps),
    color = col_upload) +
  # Label quarter
  geom_text(
    aes(y = avg_d_mbps + 0.5, label = quarter),
    color = col_download,
    size = 3.2) +
  geom_text(
    # for mobile start here
    data = trend %>% filter(type == data_filter) %>% filter(year(quart_start)!=2019),
    # end of mobile section
    aes(y = avg_u_mbps + 0.5, label = quarter),
    color = col_upload,
    size = 3.2) +
  # Label value
  geom_text(
    aes(y = avg_d_mbps - 0.6, label = sprintf("%.1f", round(avg_d_mbps, 1))),
    color = col_download,
    size = 4.5) +
  geom_text(
    aes(y = avg_u_mbps - 0.6, label = sprintf("%.1f", round(avg_u_mbps, 1))), 
    color = col_upload, 
    size = 4.5) +
  # Label Mbps
  geom_text(
    data = lab_text %>% filter(type == data_filter),
    aes(x = x, y = y_d, label = label),
    color = col_download,
    size = 4,
    nudge_x = 55,
    nudge_y = -0.6
  ) +
  geom_text(
    data = lab_text %>% filter(type == data_filter),
    aes(x = x, y = y_u, label = label),
    color = col_upload,
    size = 4,
    nudge_x = 55,
    nudge_y = -0.6
  ) +
  # Axis
  scale_x_date(date_labels = "%Y", breaks = "year", sec.axis = dup_axis()) +
  labs(x = NULL, y = NULL) +
  # Theme update
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    panel.grid.major.x = element_line(colour = "grey85", linetype = "dashed"),
    axis.text.x = element_text(
      hjust = -0.2,
      size = 14,
      face = "bold",
      family = "Lato",
      color = "grey70"),
    axis.text.y = element_blank()
  )
