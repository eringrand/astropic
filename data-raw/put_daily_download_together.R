library(dplyr)
library(purrr)
library(lubridate)
library(readr)

rm("hist_apod")

# Some dates just don't work - likely because the files are not videos or pictures - e.g. flash animations
error_dates <- read_rds("data-raw/dates_w_issues.rds") |> 
  filter(code == "404") |> 
  mutate(year = year(ymd(date))) |> 
  filter(! is.na(date))

data_dates <- hist_apod |> 
  distinct(date) |> 
  pull(date)

dates_with_img <- map_dfr(list.files("data-raw/rds", full.names = TRUE), read_rds) |>
  distinct(date) |>
  mutate(date = ymd(date)) |>
  pull(date) 

days_wanted <- seq(ymd("2007-01-01"), today(), by = 1)

days_missing <- setdiff(days_wanted, dates_with_img) |>
  setdiff(ymd(pull(error_dates, date))) |>
  as.Date()

days_missing

hist_apod_extra <- map_dfr(list.files("data-raw/rds", full.names = TRUE), read_rds) |>
  distinct()

hist_apod <- hist_apod |> 
  bind_rows(hist_apod_extra) |> 
  distinct()

# Push Data to Data/Folder
usethis::use_data(hist_apod, overwrite = TRUE)