library(dplyr)
library(purrr)
library(apodR)


# Start at Jan 1st and end on Dec 31st ------------------------------------
hist_apod <- function(year) {
 start_date <- paste0(year, "-01-01")
 end_date <- paste0(year, "-12-31")
 return(get_apod(start_date, end_date))
}


# Run for each Year from 2007 - 2017 pausing for API time limits ----------

Sys.sleep(3600)
year7 <- hist_apod(2007)
year8 <- hist_apod(2008)
Sys.sleep(3600)
year9 <- hist_apod(2009)
year10 <- hist_apod(2010)
Sys.sleep(3600)
year11 <- hist_apod(2011)
year12 <- hist_apod(2012)
Sys.sleep(3600)
year13 <- hist_apod(2013)
year14 <- hist_apod(2014)
Sys.sleep(3600)
year15 <- hist_apod(2015)
year16 <- hist_apod(2016)
Sys.sleep(3600)
year17 <- hist_apod(2017)

# Check every date worked -------
check_dates <- function(year, obj) {
  start_date <- paste0(year, "-01-01")
  end_date <- paste0(year, "-12-31")
  date_list <- seq(lubridate::ymd(start_date), lubridate::ymd(end_date), by = "days") %>%
    map_chr(as.character)
  miss <- setdiff(date_list, obj$date)
  return(miss)
}


# Create set of Problem Dates ----------
hist_list <- list(year7, year8, year9, year10, year11, year12, year13, year14, year15, year16, year17)
year_list <- seq(2007L, 2017L, 1)

errs <- tibble::tibble(year  = year_list, obj = hist_list) %>%
  mutate(missing_cols = map2(year, obj, check_dates)) %>%
  tidyr::unnest(missing_cols) %>%
  filter(!is.na(missing_cols))

errs



# Combine Together --------------------------------------------------------

hist_apod <- bind_rows(year7, year8, year9, year10, year11, year12, year13, year14, year15, year16, year17) %>%
  select(-error) %>%
  filter(!is.na(date))

usethis::use_data(hist_apod, overwrite = TRUE)
usethis::use_data(year7, overwrite = TRUE)
usethis::use_data(year8, overwrite = TRUE)
usethis::use_data(year9, overwrite = TRUE)
usethis::use_data(year10, overwrite = TRUE)
usethis::use_data(year11, overwrite = TRUE)
usethis::use_data(year13, overwrite = TRUE)
usethis::use_data(year14, overwrite = TRUE)
usethis::use_data(year15, overwrite = TRUE)
usethis::use_data(year16, overwrite = TRUE)
usethis::use_data(year17, overwrite = TRUE)
