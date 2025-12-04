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

data(hist_apod) 

data_dates <- hist_apod |> 
  distinct(date) |> 
  mutate(date = ymd(date)) |>
  pull(date)

apod_daily <- map_dfr(list.files("data-raw/rds", full.names = TRUE), read_rds) 

dates_with_img <- apod_daily |> 
  distinct(date) |>
  mutate(date = ymd(date)) |>
  pull(date) 

days_wanted <- seq(ymd("2007-01-01"), today(), by = 1)

days_missing <- setdiff(days_wanted, dates_with_img) |>
  setdiff(ymd(pull(error_dates, date))) |>
  setdiff(data_dates) |> 
  as.Date()

if(length(days_missing) > 0) {
  days_missing_dat <- map_dfr(days_missing, ~get_apod(query = list(date = .x)))
  
  hist_apod <- hist_apod |> 
    bind_rows(x) |> 
    distinct()
}

hist_apod <- hist_apod |> 
  bind_rows(apod_daily) |> 
  distinct()

hist_apod |>
  janitor::get_dupes(date)

# Push Data to Data/Fdate# Push Data to Data/Folder
usethis::use_data(hist_apod, overwrite = TRUE)
