#' Internal Functions --------------------------------------------------------------------------------------------------------------------------------------
#' @keywords internal
nasa_key <- function() {
  pat <- Sys.getenv("NASA_KEY")
  if (identical(pat, "")) {
    stop("Please set envvar NASA_KEY to your NASA API access token",
         call. = FALSE
    )
  }
  pat
}


#' Query Parameters
#' Parameter 	Type 	Default 	Description
#' `date` 	YYYY-MM-DD 	today 	The date of the APOD image to retrieve
#' `hd` 	bool 	False 	Retrieve the URL for the high resolution image
#' `api_key` 	string 	DEMO_KEY 	api.nasa.gov key for expanded usage

#' make_url
#' @param query The query you are GETing
#' @return URL used in httr call
#' @keywords internal
#' @noRd

make_url <- function(query = NULL) {
  if (is.null(query)) {
    query <- list(api_key = nasa_key())
  } else {
    query$api_key <- nasa_key()
  }

  url <- structure(
    list(
      scheme = "https",
      hostname = "api.nasa.gov",
      path = "planetary/apod",
      port = NULL,
      parms = NULL,
      fragment = NULL,
      username = NULL,
      password = NULL,
      query = query
    ),
    class = "url"
  )

  return(httr::build_url(url))
}




#' from_js
#' @param rsp The api call result
#' @return List of results from API call
#' @keywords internal
#' @noRd

from_js <- function(rsp) {

  stopifnot(is_response(rsp))

  if (httr::status_code(rsp) == 500 | httr::status_code(rsp) != 200) {
    stop(
      sprintf(
        "API request failed [%s]\n%s\n<%s>",
        httr::status_code(rsp),
        rsp$message,
        rsp$documentation_url
      ),
      call. = FALSE
    )
  }

  if (!is_json(rsp)) {
    stop("API did not return json", call. = FALSE)
  }

  rsp <- httr::content(rsp, as = "text", encoding = "UTF-8")
  rsp <- jsonlite::fromJSON(rsp)

  return(rsp)
}



## ----------------------------------------------------------------------------##
##                                 check data                                  ##
## ----------------------------------------------------------------------------##

is_response <- function(x) {
  inherits(x, "response")
}

is_json <- function(x) {
  grepl("application/json", x$headers[["content-type"]])
}

rate_limit <- function(r) {
  httr::headers(r)$`x-ratelimit-remaining`
}
