# Find all dates with issues - rest for an hour in between 900 requests
library(ratelimitr)
library(lubridate)
library(purrr)

try_date <- function(date_string) {
  url <- astropic:::make_url(query = list(date = date_string))
  rsp <- httr::GET(url)
  code <- httr::status_code(rsp)
  limit <- astropic:::rate_limit(rsp) #  Hourly Limit: 1,000 requests per hour
  if(code == 500) {
    return(date_string)
  }
  else{
    return(NA_character_)
  }
}

try_date_lim <- limit_rate(try_date, rate(n = 999, period = 3600))

dates <- seq(ymd("2007-01-01"), today(), by = "days") |>
  as.character()

dates_w_issues <- map_chr(dates, try_date_lim)
readr::write_rds(dates_w_issues, here::here("data-raw/dates_w_issues.csv"))
