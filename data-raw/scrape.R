library(astropic)
library(lubridate)
library(readr)

# Set up what days we want data
today <- today()

days_wanted <- seq(start_date, today, by = 1)

date <- as.Date(today)
print(date)

if(file.exists(glue::glue("rds/{date}.csv"))) {
    next
}

today_pic <- get_apod(query = list(end_date = today))

# Write out data
readr::write_rds(today_pic, glue::glue("data-raw/rds/{date}.rds"))
