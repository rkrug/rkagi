# tests/testthat/test-search-simple.R

testthat::test_that("kagi_search_once() works (recorded with vcr)", {
  skip_if_no_kagi_key()
  skip_on_cran_if_recording()

  vcr::local_cassette("test-search-simple")

  testthat::skip_if_not_installed("vcr")

  res <- kagi_search_once(
    q = "openalex api",
    limit = 1,
    api_key = Sys.getenv("KAGI_API_KEY")
  )
  testthat::expect_s3_class(res, "kagi_search_results")
  hits <- kagi_hits(res)
  testthat::expect_s3_class(hits, "tbl_df")
  testthat::expect_true(nrow(hits) >= 0)
})
