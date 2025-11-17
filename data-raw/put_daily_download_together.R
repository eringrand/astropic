library(dplyr)
library(purrr)
library(lubridate)

dates_with_img <- map_dfr(list.files("data-raw/rds", full.names = TRUE), read_rds) |>
  distinct(date) |>
  mutate(date = ymd(date)) |>
  pull(date)

days_wanted <- seq(ymd("2007-01-01"), today(), by = 1)

# days_missing <- setdiff(days_wanted, dates_with_img) |>
#   setdiff(ymd(pull(error_dates, date))) |>
#   as.Date()

hist_apod <- map_dfr(list.files("data-raw/rds", full.names = TRUE), read_rds) |>
  distinct()

# Push Data to Data/Folder
usethis::use_data(hist_apod, overwrite = TRUE)
