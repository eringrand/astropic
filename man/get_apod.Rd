% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_apod.R
\name{get_apod}
\alias{get_apod}
\title{get_apod}
\usage{
get_apod(query = NULL, print = FALSE)
}
\arguments{
\item{query}{Query you want
#' The query parameters are described on the \href{https://github.com/nasa/apod-api}{APOD API Github page}
\itemize{
\item \code{date} A string in YYYY-MM-DD format indicating the date of the APOD image (example: 2014-11-03).  Defaults to today's date.  Must be after 1995-06-16, the first day an APOD picture was posted.  There are no images for tomorrow available through this API.
\item \code{hd} A boolean parameter indicating whether or not high-resolution images should be returned. This is present for legacy purposes, it is always ignored by the service and high-resolution urls are returned regardless.
\item \code{count} A positive integer, no greater than 100. If this is specified then \code{count} randomly chosen images will be returned in a JSON array. Cannot be used in conjunction with \code{date} or \code{start_date} and \code{end_date}.
\item \code{start_date} A string in YYYY-MM-DD format indicating the start of a date range. All images in the range from \code{start_date} to \code{end_date} will be returned in a JSON array. Cannot be used with \code{date}.
\item \code{end_date} A string in YYYY-MM-DD format indicating that end of a date range. If \code{start_date} is specified without an \code{end_date} then \code{end_date} defaults to the current date.
}}

\item{print}{if print = TRUE: Print out how where you are with the APOD API rate limit
Defaults to not printing anything.}
}
\value{
Returns a \code{tibble} containing
\itemize{
\item copyright: image copyright, if not public domain
\item date: Date of the image
\item explanation: The supplied text explanation of the image,
may have some HTML text still in it
\item hdurl: The url for the high-resolution image
\item media_type: The type of media returned. May either be 'image' or 'video' depending on content
\item service_version
\item title: The title of image
\item url The url of image
If there is an error with any images, there will also be an error column.
}
}
\description{
This function retrieves data from the APOD API.
}
