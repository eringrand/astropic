#' @title get_apod
#' @description FUNCTION_DESCRIPTION
#' @param start_date starting date you'd like to look at
#' @param end_date end date you'd like to look at, Default: NULL
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @export

get_apod <- function(start_date = NULL, end_date = NULL) {
  if(is.null(end_date) & is.null(start_date)) {
    start_date <- Sys.Date()
  }

  if(is.null(end_date)) {
    end_date = start_date
  }

  if(start_date == end_date) {
    days_list <- start_date
  } else {
    days_list <- seq(lubridate::ymd(start_date), lubridate::ymd(end_date), by = "days")
  }

  if(length(days_list) > 1000) {
     stop("Number of Days is larger than API limit", call. = FALSE)
   }

 url_list <- purrr::map_chr(days_list, make_url)
 return(purrr::map_dfr(url_list, one_apod))
}


#' @title one APOD image at time
#' @description Connects to the APOD API to get data back on one image at a time, given a url.
#' @param url URL to send to API, constructed with make_url
#' @noRd

one_apod <- function(url, print = FALSE) {
  r <- httr::GET(url)
  limit <- remaining_rate_limit(r)
  if(print) print(paste("Your remaining API request limit this hour is", limit))
  r_list <- from_js(r)
  return(tibble::as_tibble(r_list))
}
