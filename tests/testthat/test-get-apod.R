context("get_apod")

test_that("get_apod return data frame", {
  skip_on_cran()

  apod <- get_apod()

  expect_equal(is.data.frame(apod), TRUE)
  expect_named(apod)
  expect_true(all(c("explanation", "title", "date") %in% names(apod)))
  expect_equal(nrow(apod), 1)
  expect_equal(ncol(apod), 7)
})
