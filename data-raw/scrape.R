library(astropic)
library(lubridate)
library(readr)

# Set up what days we want data
start_date <- ymd("2007-01-01")
today <- today() - 1

days_wanted <- seq(start_date, today, by = 1)

date <- as.Date(today)
print(date)

if(file.exists(glue::glue("rds/{date}.csv"))) {
    next
}

today_pic <- get_apod(query = list(date = today))

# Write out data
readr::write_rds(today_pic, glue::glue("data-raw/rds/{date}.rds"))


