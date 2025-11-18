# Find all dates with issues - rest for an hour in between 1900 requests
try_date <- function(date_string) {
  url <- astropic:::make_url(query = list(date = date_string))
  rsp <- httr::GET(url)
  code <- httr::status_code(rsp)
  limit <- astropic:::rate_limit(rsp)
  if(code == 500) {
    return(date_string)
  }
  else{
    return(NA_character_)
  }
}

try_date_lim <- ratelimitr::limit_rate(try_date, rate(n = 1999, period = 3600))

dates <- seq(lubridate::ymd("2007-01-01"), lubridate::today(), by = "days") |>
  as.character()

dates_w_issues <- purrr::map_chr(dates, try_date_lim)
readr::write_rds(dates_w_issues, here::here("data-raw/dates_w_issues.csv"))
