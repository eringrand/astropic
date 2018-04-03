#' Query Parameters
#' Parameter 	Type 	Default 	Description
#' date 	YYYY-MM-DD 	today 	The date of the APOD image to retrieve
#' hd 	bool 	False 	Retrieve the URL for the high resolution image
#' api_key 	string 	DEMO_KEY 	api.nasa.gov key for expanded usage
#'

#' make_url
#' @param date The date you are interested in recieving APOD information from. The APOD API can only call one date at a time.
#' @return URL used in httr call.
#' @keywords internal
#' @noRd

make_url <- function(date = NULL) {
  if(is.null(date)) {
    date <- Sys.Date()
  }
  hostname <- "api.nasa.gov/planetary/apod"
  api_key <- "QLAzwCGQOkNxaFpWFAu2OMTWUME4YC2IIBMFqgW1"
  scheme <-"https"
  paste0(scheme, "://", hostname, "?", "api_key=", api_key, "&date=", date)
}


#' make_url
#' @param rsp The api call result
#' @return List of results from API call
#' @keywords internal
#' @noRd

from_js <- function(rsp) {
  stopifnot(is_response(rsp))
  if (!is_json(rsp)) {
   stop("API did not return json", call. = FALSE)
  }
  rsp <- httr::content(rsp, as = "text", encoding = "UTF-8")
  rsp <- jsonlite::fromJSON(rsp)
}



##----------------------------------------------------------------------------##
##                                 check data                                 ##
##----------------------------------------------------------------------------##

is_response <- function(x) {
  inherits(x, "response")
}

is_json <- function(x) {
  grepl("application/json", x$headers[["content-type"]])
}

remaining_rate_limit <- function(r) {
  httr::headers(r)$`x-ratelimit-remaining`
}


