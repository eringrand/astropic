#' make_url
#' @param query The query you are GETing
#' @return URL used in httr call
#' @keywords internal
#' @noRd

check_query <- function(query) {
  check <- dplyr::case_when(is.null(query) ~ TRUE,
            "count" %in% names(query) & "start_date" %in% names(query) ~ FALSE,
            "count" %in% names(query) & "end_date" %in% names(query) ~ FALSE,
            "count" %in% names(query) & "date" %in% names(query) ~ FALSE,
            "start_date" %in% names(query) & "date" %in% names(query) ~ FALSE,
            "end_date" %in% names(query) & "date" %in% names(query) ~ FALSE,
            length(setdiff(names(query), c("start_date", "end_date", "date", "count"))) > 0 ~ FALSE,
            length(setdiff(names(query), c("start_date", "end_date", "date", "count"))) == 0 ~ TRUE
            )

}

make_url <- function(query = NULL) {
  if (! check_query(query)) {
    stop("Query contains information not allowed by API")
  }

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
  if(! is_response(rsp)) {
    stop("no response", call. = FALSE)
  }

  if (! is_json(rsp)) {
    stop("API did not return json", call. = FALSE)
  }


  if (httr::status_code(rsp) != 200 && httr::status_code(rsp) != 500) {
    stop(
      sprintf(
        "API request failed [%s]\n%s\n<%s>",
        httr::status_code(rsp),
        rsp$message,
        rsp$documentation_url
      )
    )
  }

  rsp <- httr::content(rsp, as = "text", encoding = "UTF-8")
  rsp <- jsonlite::fromJSON(rsp)

  return(rsp)
}




## ----------------------------------------------------------------------------##
##                                 check data                                 ##
## ----------------------------------------------------------------------------##

is_response <- function(x) {
  inherits(x, "response")
}

is_json <- function(x) {
  grepl("application/json", x$headers[["content-type"]])
}

rate_limit <- function(r) {
  as.numeric(httr::headers(r)$`x-ratelimit-remaining`)
}

nasa_key <- function() {
  pat <- Sys.getenv("NASA_KEY")

  if (identical(pat, "")) {
    stop("Set your envvar NASA_KEY to your NASA API access token.
         Use 'usethis::edit_r_environ()'
         to edit your environ file then restart R.")
  }

  pat
}

