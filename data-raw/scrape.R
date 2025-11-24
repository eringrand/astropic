library(astropic)
library(lubridate)
library(readr)

# Set up what days we want data
today <- today() - 1
today_pic <- get_apod(query = list(date = today))

# Write out data
readr::write_rds(today_pic, glue::glue("data-raw/rds/{date}.rds"))