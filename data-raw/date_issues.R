# Find all dates with issues - rest for an hour im between 1900 requests

# Setup ---------------------------------------------------------------------------------------------------------------------------------------------------

library(astropic)
library(ratelimitr)
library(lubridate)
library(purrr)


# Write Funtion -------------------------------------------------------------------------------------------------------------------------------------------------


try_date <- function(date_string) {

  url <- astropic:::make_url(query = list(date = date_string))
  rsp <- httr::GET(url)
  code <- httr::status_code(rsp)
  limit <- astropic:::rate_limit(rsp) #  Hourly Limit: 2,000 requests per hour

  print(limit)

  if(code == 500) {
    return(date_string)
  }

  else{
    return(NA_character_)
  }
}


# Find missing dates --------------------------------------------------------------------------------------------------------------------------------------

try_date_lim <- limit_rate(try_date, rate(n = 1940, period = 3600))

dates <- seq(ymd("2007-01-01"), ymd("2024-01-31"), by = "days") %>%
  as.character()

dates_w_issues <- map_chr(dates, try_date_lim)
dates_w_issues <- unique(dates_w_issues)[complete.cases(unique(dates_w_issues))]

# Output dates --------------------------------------------------------------------------------------------------------------------------------------

usethis::use_data(dates_w_issues, overwrite = TRUE)

