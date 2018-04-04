#' @title get_apod
#' @description FUNCTION_DESCRIPTION
#' @param query Query you want
#' @param print if print = TRUE: Print out how where you are with the APOD API rate limit
#' Defaults to not printing anything.
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @export

get_apod <- function(query = NULL, print = FALSE) {
  url <- make_url(query = query)
  r <- httr::GET(url)
  r_list <- from_js(r)
  if(print) print(paste("Your remaining API request limit this hour is", rate_limit(r)))
  return(tibble::as_tibble(r_list))
}
