library(dplyr)
library(purrr)
library(tidyr)
library(lubridate)
library(janitor)
library(astropic)

# Some dates just don't work - likely because the files are not videos or pictures - e.g. flash anitmations
error_dates <- tibble::tibble(date = c("2007-05-22", "2007-12-18", "2008-12-31", "2009-04-05",
                 "2009-04-13", "2009-06-29", "2009-08-10", "2010-01-20",
                 "2010-01-24", "2010-05-10", "2010-05-26", "2010-06-08",
                 "2010-07-25", "2010-08-25", "2010-12-15", "2011-01-23",
                 "2011-02-01", "2011-02-22", "2011-03-07", "2012-03-12",
                 "2012-05-23", "2014-01-12", "2014-02-10",
                 "2018-10-07")
                 ) |>
  mutate(year = year(ymd(date)))


# Start at Jan 1st and end on Dec 31st ------------------------------------
hist_apod_func <- function(y) {
  print(y)
  start_date <- ymd(paste0(y, "-01-01"))
  end_date <- ymd(paste0(y, "-12-31"))

  # Finds dates that ERROR in year
  errors <- error_dates |>
    filter(year == y) |>
    mutate(date = ymd(date)) |>
    arrange(date) |>
    pull(date)

  err_len <- length(errors)
  x <- c()

  # Create start/end ranges around ERROR dates
  if(err_len == 0) { # If there are no errors, treat as normal
    x$range0 <- list(start_date = start_date, end_date = end_date)
  }
  # if there are errors, but Jan 1 and Dec 31 are both not errors
  else if(!start_date %in% errors & !end_date %in% errors) {
    x$range0 <- list(start_date = start_date, end_date = errors[1] - 1)
    x$rangeN <- list(start_date = errors[err_len] + 1, end_date = end_date)

    for(i in seq_len(err_len - 1)) {
      name <- paste0("range", i)
      x[[name]] <- list(start_date = errors[i] + 1, end_date = errors[i + 1] - 1)
    }
  }
  # if Dec 31 is the only error
  else if(end_date %in% errors & err_len == 1) {
    x$range0 <- list(start_date = start_date, end_date = end_date - 1)
  }
  # if Jan 1 is the only error
  else if(start_date %in% errors & err_len == 1) {
    x$range0 <- list(start_date = start_date - 1, end_date = end_date)
  }
  # if both start and end are in the errors, then start from earliest date possible
  else if(start_date %in% errors & end_date %in% errors) {
    for(i in seq_len(err_len - 1)) {
      name <- paste0("range", i)
      x[[name]] <- list(start_date = errors[i] + 1, end_date = errors[i + 1] - 1)
    }
  }
  return(map_dfr(x, ~get_apod(query = .x)))
}



# Run for each Year from 2007 - 2017 ------
year_list <- seq(2019L, 2019L, 1)

# create safe function

# WARNING: this can take a long time
hist_apod <- map_dfr(year_list, hist_apod_func)



# Push Data to Data/Folder
usethis::use_data(hist_apod, overwrite = FALSE)
