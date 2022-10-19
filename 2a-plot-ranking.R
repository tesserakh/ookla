library(dplyr)
library(ggplot2)
library(ggbump)
library(lubridate)

# Load data
trend <- readRDS("data/ASEAN_trend_quarterly.rds")

data <- trend %>% 
  filter(type == "fixed") %>% 
  select(date = quart_start, country, speed = avg_d_mbps) %>% 
  group_by(date) %>% 
  mutate(ranking = dense_rank(desc(speed))) %>% 
  ungroup() %>% 
  mutate(label_speed = paste(sprintf("%.1f", round(speed, 1)), "Mbps")) %>% 
  mutate(name = case_when(country == "BRN" ~ "Brunei",
                          country == "IDN" ~ "Indonesia",
                          country == "KHM" ~ "Cambodia",
                          country == "LAO" ~ "Laos",
                          country == "MMR" ~ "Myanmar",
                          country == "MYS" ~ "Malaysia",
                          country == "PHL" ~ "Philippines",
                          country == "SGP" ~ "Singapore",
                          country == "THA" ~ "Thailand",
                          country == "VNM" ~ "Vietnam"),
         .after = 1)

nation_col = c(
  "#007f4e", # Brunei
  "#e12729", # Indonesia
  "#3f3b3b", # Cambodia
  "#f58231", # Laos
  "#2f89fc", # Myanmar
  "#ffc200", # Malaysia
  "#4f3da5", # Philippine
  "#ac3f21", # Singapore
  "#f5587b", # Thailand
  "#a17488"  # Vietnam
)

ggplot(data, aes(date, ranking, col = country)) +
  geom_bump(size = 1.5) +
  geom_point(
    data = ~subset(., date == max(date) | date == min(date)),
    shape = 21, size = 6, stroke = 1.25, fill = "white"
  ) +
  # countries text label in the beginning
  geom_text(
    data = ~subset(., date == min(date)),
    aes(
      x = date %m-% period("1 month"),
      y = ranking,
      label = name, 
      color = factor(country)
    ),
    hjust = 1,
    family = "Lato"
  ) +
  # countries text label in the end
  geom_text(
    data = ~subset(., date == max(date)),
    aes(
      x = date %m+% period("1 month"),
      y = ranking,
      label = name, 
      color = factor(country)
    ),
    hjust = 0,
    family = "Lato"
  ) +
  # ranking label in the circle
  geom_text(
    data = ~subset(., date == max(date) | date == min(date)),
    aes(label = ranking),
    size = 3.5,
    family = "Lato",
    fontface = "bold"
  ) +
  # internet speed label
  geom_label(
    data = ~subset(., date == max(date)),
    aes(
      x = as.Date("2022-01-01"),
      y = ranking,
      label = label_speed
    ),
    size = 4,
    family = "Lato",
    fontface = "bold"
  ) +
  # scale and axis
  scale_x_date(date_breaks = "1 year", date_labels = "%Y", sec.axis = dup_axis()) +
  scale_y_reverse(breaks = seq(0, 10, by = 1)) +
  scale_colour_manual(values = nation_col) +
  coord_cartesian(clip = "off") +
  expand_limits(x = c(min(data$date) %m-% period(2, "month"), 
                      max(data$date) %m+% period(2, "month"))) +
  # theme
  theme_minimal() +
  theme(
    axis.title = element_blank(),
    axis.text.x = element_text(family = "Lato", size = 16, color = "grey60"),
    axis.text.y = element_blank(),
    panel.grid.major.x = element_line(colour = "grey60", linetype = "dotted", size = 0.6),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = "none",
    # panel.background = element_rect(fill = "grey80", color = NA)
  )

#ggsave("plot/plot-rank.png", width = 1080, height = 497, units = "px")