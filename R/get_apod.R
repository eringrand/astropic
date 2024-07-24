#' @title get_apod
#' @description This function retrieves data from the APOD API.
#' @param query Query you want
#' The query parameters are described on the [APOD API Github page](https://github.com/nasa/apod-api)
#' - `date` A string in YYYY-MM-DD format indicating the date of the APOD image (example: 2014-11-03). Defaults to today's date. Must be after 1995-06-16, the first day an APOD picture was posted. There are no images for tomorrow available through this API.
#' - `concept_tags` A Boolean True|False indicating whether concept tags should be returned with the rest of the response. The concept tags are not necessarily included in the explanation, but rather derived from common search tags that are associated with the description text. (Better than just pure text search.) Defaults to False.
#' - `count` A positive integer, no greater than 100. If this is specified then count randomly chosen images will be returned in a JSON array. Cannot be used in conjunction with date or `start_date` and `end_date`.
#' - `start_date` A string in YYYY-MM-DD format indicating the start of a date range. All images in the range from `start_date` to end_date will be returned in a JSON array. Cannot be used with date.
#' - `end_date` A string in YYYY-MM-DD format indicating that end of a date range. If `start_date` is specified without an `end_date` then `end_date` defaults to the current date.
#' - `thumbs` A Boolean parameter True|False indicating whether the API should return a thumbnail image URL for video files. If set to True, the API returns URL of video thumbnail. If an APOD is not a video, this parameter is ignored.
#' @param print if print = TRUE: Print out how where you are with the APOD API rate limit. Defaults to not printing anything.
#' @return Returns a \code{tibble} containing
#' - `date` Date of image. Included in response because of default values.
#' - `explanation` The supplied text explanation of the image.
#' - `hdurl` The URL for any high-resolution image for that day. Will be omitted in the response IF it does not exist originally at APOD.
#' - `media_type` The type of media (data) returned. May either be 'image' or 'video' depending on content.
#' - `service_version` The service version used.
#' - `title` The title of the image.
#' - `url` The URL of the APOD image or video of the day.

#' Others:
#' - `resource` A dictionary describing the image_set or planet that the response illustrates, completely determined by the structured endpoint.
#' - `concept_tags` A Boolean reflection of the supplied option. Included in response because of default values.
#' - `concepts` The most relevant concepts within the text explanation. Only supplied if concept_tags is set to True.
#' - `thumbnail_url` The URL of thumbnail of the video.
#' - `copyright` The name of the copyright holder.

#' If there is an error with any images, there will also be an error column.
#' @examples get_apod()
#' @export

get_apod <- function(query = NULL, print = FALSE) {

  url <- make_url(query = query)
  r <- httr::GET(url)
  r_list <- from_js(r)

  if (print) print(paste("Your remaining API request limit this hour is", rate_limit(r))) #  Hourly Limit: 2,000 requests per hour

    return(tibble::as_tibble(r_list))
}
