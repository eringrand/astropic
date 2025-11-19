context("get_apod")

test_that("get_apod returns data frame", {
  skip_on_cran()
  apod <- get_apod()
  
  expect_equal(is.data.frame(apod), TRUE)
  expect_named(apod)
  expect_true(all(c("explanation", "title", "date") %in% names(apod)))
  expect_equal(nrow(apod), 1)
  expect_equal(ncol(apod), 5)
})


test_that("get_apod returns error with a bad input", {
  skip_on_cran()

  expect_error(get_apod(list(date = "2019-02-31"))) # Date doesn't exsist
  expect_error(get_apod(list(end_date = "2019-01-30"))) # Need both a START and END date
  expect_error(get_apod(list(type = "galaxy")))
  #TODO get this to work
  # expect_failure(get_apod("galaxy"), "All components of query must be named") 
})
