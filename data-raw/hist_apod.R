library(dplyr)
library(purrr)
library(tidyr)
library(lubridate)
library(janitor)
library(astropic)

safeapod <- safely(get_apod)

# Some dates just don't work - likely because the files are not videos or pictures - e.g. flash animations
error_dates <- read_rds("data-raw/dates_w_issues.rds") |> 
  filter(code == "404")  
  
data_dates <- hist_apod |> 
  distinct(date) 

do_not_want_dates <- bind_rows(data_dates, error_dates) |> 
  select(date) |> 
  mutate(year = year(ymd(date)),
         date = ymd(date)
         ) |>
  filter(! is.na(date))

# Start at Jan 1st and end on Dec 31st ------------------------------------
hist_apod_func <- function(y) {
  start_date <- ymd(paste0(y, "-01-01"))
  end_date <- ymd(paste0(y, "-12-31"))

  # Finds dates that ERROR in year
  errors <- do_not_want_dates |>
    filter(year == y) |>
    arrange(date) |>
    pull(date)

  err_len <- length(errors)
  x <- c()

  # Create start/end ranges around ERROR dates
  if(err_len == 0) { # If there are no errors, treat as normal
    x$range0 <- list(start_date = start_date, end_date = end_date)

  # if there are errors, but Jan 1 and Dec 31 are both not errors
  } else if(!start_date %in% errors & !end_date %in% errors) {
    x$range0 <- list(start_date = start_date, end_date = errors[1] - 1)
    x$rangeN <- list(start_date = errors[err_len] + 1, end_date = end_date)

    for(i in seq_len(err_len - 1)) {
      name <- paste0("range", i)
      x[[name]] <- list(start_date = errors[i] + 1, end_date = errors[i + 1] - 1)
    }

  # if Dec 31 is the only error
  } else if(end_date %in% errors & err_len == 1) {
    x$range0 <- list(start_date = start_date, end_date = end_date - 1)

  # if Jan 1 is the only error
  } else if(start_date %in% errors & err_len == 1) {
    x$range0 <- list(start_date = start_date - 1, end_date = end_date)
  # if both start and end are in the errors, then start from earliest date possible
  } else if(start_date %in% errors & end_date %in% errors) {
    for(i in seq_len(err_len - 1)) {
      name <- paste0("range", i)
      x[[name]] <- list(start_date = errors[i] + 1, end_date = errors[i + 1] - 1)
    }
  }
  
  return(map(x, ~safeapod(query = .x)))
}

hist_apod_func_lim <- ratelimitr::limit_rate(hist_apod_func, ratelimitr::rate(n = 1500, period = 3600))

# Run for each Year from 2007 ------
year_list <- seq(2007, 2025, 1)

# WARNING: this can take a long time depending on the date range
hist_apod_missing <- map_dfr(year_list, hist_apod_func_lim)
write_rds(hist_apod_missing, "data-raw/rds/hist_OLD_apod_missing.rds")