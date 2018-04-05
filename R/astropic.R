#' @docType package
#' @name astropic
#' @importFrom dplyr %>%
#' @importFrom httr GET content headers
#' @keywords internal
NULL
#' quiets concerns of R CMD check re: the .'s that appear in pipelines
if(getRversion() >= "2.15.1") utils::globalVariables(c("."))
