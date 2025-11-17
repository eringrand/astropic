#' @title get_apod
#' @description This function retrieves data from the APOD API.
#' @param query Query you want
#' #' The query parameters are described on the [APOD API Github page](https://github.com/nasa/apod-api)
#' - `date` A string in YYYY-MM-DD format indicating the date of the APOD image (example: 2014-11-03).  Defaults to today's date.  Must be after 1995-06-16, the first day an APOD picture was posted.  There are no images for tomorrow available through this API.
#' - `hd` A boolean parameter indicating whether or not high-resolution images should be returned. This is present for legacy purposes, it is always ignored by the service and high-resolution urls are returned regardless.
#' - `count` A positive integer, no greater than 100. If this is specified then `count` randomly chosen images will be returned in a JSON array. Cannot be used in conjunction with `date` or `start_date` and `end_date`.
#' - `start_date` A string in YYYY-MM-DD format indicating the start of a date range. All images in the range from `start_date` to `end_date` will be returned in a JSON array. Cannot be used with `date`.
#' - `end_date` A string in YYYY-MM-DD format indicating that end of a date range. If `start_date` is specified without an `end_date` then `end_date` defaults to the current date.
#' @param print if print = TRUE: Print out how where you are with the APOD API rate limit
#' Defaults to not printing anything.
#' @return Returns a \code{tibble} containing
#' - copyright: image copyright, if not public domain
#' - date: Date of the image
#' - explanation: The supplied text explanation of the image,
#' may have some HTML text still in it
#' - hdurl: The url for the high-resolution image
#' - media_type: The type of media returned. May either be 'image' or 'video' depending on content
#' - service_version
#' - title: The title of image
#' - url The url of image
#' If there is an error with any images, there will also be an error column.
#' @examples get_apod()
#' @export

get_apod <- function(query = NULL, print = FALSE) {
  url <- make_url(query = query)
  r <- httr::GET(url)
  r_list <- from_js(r)
  if (print) print(paste("Your remaining API request limit this hour is", rate_limit(r))) #  Hourly Limit: 1,000 requests per hour
  return(tibble::as_tibble(r_list))
}
