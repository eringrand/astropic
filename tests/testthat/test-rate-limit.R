context("rate_limit")

test_that("rate_limit returns rate_limit data", {
  skip_on_cran()

  url <- make_url(query = NULL)
  r <- httr::GET(url)
  x <- rate_limit(r)

  expect_equal(is.numeric(x), TRUE)
})

