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

#year7 <- hist_apod(2007)
#year8 <- hist_apod(2008)
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


# Combine Together --------------------------------------------------------

hist_apod <- bind_rows(year7, year8, year9, year10, year11, year12, year13, year14, year15, year16, year17)

usethis::use_data(hist_apod, overwrite = TRUE)
