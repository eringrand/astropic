#' @docType package
#' @name apodR
#' @importFrom dplyr %>%
#' @importFrom httr GET content headers
#' @keywords internal
NULL
#' quiets concerns of R CMD check re: the .'s that appear in pipelines
#' and the "n" that is produced by dplyr::count() in a pipeline
if(getRversion() >= "2.15.1") utils::globalVariables(c(".", "n"))
