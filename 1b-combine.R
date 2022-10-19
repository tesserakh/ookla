library(purrr)

f <- list.files("data", pattern = "quarterly.rds", full.names = TRUE)
d <- map_df(f, ~readRDS(.x))
# Save resume to RDS and CSV
filename <- "data/ASEAN_trend_quarterly"
saveRDS(d, paste0(filename, ".rds"))
write.csv(x = d,
          file = paste0(filename, ".csv"),
          row.names = FALSE)
