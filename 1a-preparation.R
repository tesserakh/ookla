library(sf)
library(purrr)
library(dplyr)
library(lubridate)

# NATIONWIDE AVERAGE INTERNET SPEED QUARTERLY
# 
# Listing data files
# The data have been clipped by AoI (Indonesia region)
# See "data" path for more detail
region <- "VNM"
path <- paste0(sprintf("data/%s/", region), c("fixed", "mobile"))
f <- map(path, ~{
  files <- list.files(
    path = .x,
    pattern = "shp",
    full.names = TRUE)
  return(files)
})
f <- do.call(c, f)

# Load the data
# I used this flow due to memory limitation
# You can also directly import all the data to a list first, then reshape
trend <- map_df(f, ~{
  p <- sprintf("^data/%s/(.+)/.+shp$", region)
  t <- gsub(p, "\\1", .x)
  d <- ymd(gsub("^.+(\\d{4}-\\d{2}-\\d{2})\\.shp$", "\\1", .x))
  data <- read_sf(.x)
  data <- data %>% 
    st_drop_geometry() %>% 
    summarise(n_tiles = n(),
              avg_d_mbps = weighted.mean(avg_d_kbps / 1000, tests),
              avg_u_mbps = weighted.mean(avg_u_kbps / 1000, tests),
              tests = sum(tests)) %>% 
    mutate(quart_start = d, type = t, .before = 1)
  return(data)
})

trend <- trend %>% 
  mutate(quarter = sprintf("Q%s", quarter(quart_start)), .after = 1) %>%
  mutate(country = region)

# Save resume to RDS and CSV
filename <- sprintf("data/%s_trend_quarterly", region)
saveRDS(trend, paste0(filename, ".rds"))
write.csv(x = trend,
          file = paste0(filename, ".csv"),
          row.names = FALSE)
