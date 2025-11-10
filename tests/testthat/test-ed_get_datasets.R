test_that("ed_get_datasets returns expected structure", {
  skip_if_offline()

  result <- ed_get_datasets(quiet = TRUE)

  expect_s3_class(result, "data.frame")
  expect_named(
    result,
    c("dataset", "total_downloads", "last_modified", "is_private", "is_gated")
  )
  expect_type(result$dataset, "character")
  expect_type(result$total_downloads, "integer")
  expect_type(result$last_modified, "character")
  expect_type(result$is_private, "logical")
  expect_type(result$is_gated, "logical")
})

test_that("ed_get_datasets returns at least one dataset", {
  skip_if_offline()

  result <- ed_get_datasets(quiet = TRUE)

  expect_gt(nrow(result), 0)
})

test_that("ed_get_datasets shows informational messages when quiet = FALSE", {
  skip_if_offline()

  expect_message(
    ed_get_datasets(quiet = FALSE),
    "Fetching dataset list from"
  )

  expect_message(
    ed_get_datasets(quiet = FALSE),
    "Found .+ datasets"
  )
})

test_that("ed_get_datasets suppresses messages when quiet = TRUE", {
  skip_if_offline()

  expect_silent(ed_get_datasets(quiet = TRUE))
})

test_that("ed_get_datasets handles API errors gracefully", {
  mockery::stub(ed_get_datasets, "httr2::request", function(url) {
    list(perform = function() stop("Network error"))
  })

  mockery::stub(ed_get_datasets, "httr2::req_perform", function(req) {
    stop("Network error")
  })

  expect_error(
    ed_get_datasets(quiet = TRUE),
    "Failed to retrieve dataset list"
  )
})

test_that("ed_get_datasets uses correct API endpoint", {
  skip_if_offline()

  # Capture the URL being used
  called_url <- NULL

  mockery::stub(ed_get_datasets, "httr2::request", function(url) {
    called_url <<- url
    httr2::request(url)
  })

  ed_get_datasets(quiet = TRUE)

  expect_equal(
    called_url,
    "https://huggingface.co/api/datasets?author=econdataverse"
  )
})

test_that("ed_get_datasets dataset IDs are properly formatted", {
  skip_if_offline()

  result <- ed_get_datasets(quiet = TRUE)

  # Dataset IDs should contain the organization prefix
  expect_true(all(grepl("^econdataverse/", result$dataset)))
})

test_that("ed_get_datasets last_modified dates are valid", {
  skip_if_offline()

  result <- ed_get_datasets(quiet = TRUE)

  # Check that dates can be parsed
  parsed_dates <- as.POSIXct(result$last_modified, format = "%Y-%m-%dT%H:%M:%S")
  expect_true(all(!is.na(parsed_dates)))
})

test_that("ed_get_datasets respects quiet parameter type", {
  skip_if_offline()

  # Should work with logical
  expect_no_error(ed_get_datasets(quiet = TRUE))
  expect_no_error(ed_get_datasets(quiet = FALSE))

  # Should handle non-logical (R will coerce)
  expect_no_error(ed_get_datasets(quiet = 1))
  expect_no_error(ed_get_datasets(quiet = 0))
})

test_that("ed_get_datasets download counts are non-negative", {
  skip_if_offline()

  result <- ed_get_datasets(quiet = TRUE)

  expect_true(all(result$total_downloads >= 0))
})

test_that("ed_get_datasets boolean columns contain only TRUE/FALSE", {
  skip_if_offline()

  result <- ed_get_datasets(quiet = TRUE)

  expect_true(all(result$is_private %in% c(TRUE, FALSE)))
  expect_true(all(result$is_gated %in% c(TRUE, FALSE)))
})
