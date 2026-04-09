testthat::test_that("query constructors return expected classes", {
  sq <- kagiPro::query_search("biodiversity", expand = FALSE)
  testthat::expect_type(sq, "list")
  testthat::expect_s3_class(sq[[1]], "kagi_query_search")

  ew <- kagiPro::query_enrich_web("biodiversity", expand = FALSE)
  testthat::expect_type(ew, "list")
  testthat::expect_s3_class(ew[[1]], "kagi_query_enrich_web")

  en <- kagiPro::query_enrich_news("biodiversity", expand = FALSE)
  testthat::expect_type(en, "list")
  testthat::expect_s3_class(en[[1]], "kagi_query_enrich_news")

  sm <- kagiPro::query_summarize(text = "A short text.", cache = FALSE)
  testthat::expect_type(sm, "list")
  testthat::expect_s3_class(sm[[1]], "kagi_query_summarize")
  testthat::expect_type(sm[[1]]$cache, "logical")
  testthat::expect_false(sm[[1]]$cache)

  fg <- kagiPro::query_fastgpt("What is biodiversity?")
  testthat::expect_type(fg, "list")
  testthat::expect_s3_class(fg[[1]], "kagi_query_fastgpt")
  testthat::expect_true(fg[[1]]$web_search)
})

testthat::test_that("query_fastgpt enforces current API constraint", {
  testthat::expect_error(
    kagiPro::query_fastgpt("test", web_search = FALSE),
    "currently not supported"
  )
})

testthat::test_that("open_search_query returns encoded URL", {
  opened <- NULL
  testthat::local_mocked_bindings(
    browseURL = function(url) {
      opened <<- url
      invisible(TRUE)
    },
    .package = "utils"
  )

  url <- kagiPro::open_search_query("a b")
  testthat::expect_equal(url, "https://kagi.com/search?q=a%20b")
  testthat::expect_equal(opened, url)
})

testthat::test_that("kagi_connection constructor creates expected class", {
  conn <- kagiPro::kagi_connection(api_key = "dummy-kagi-key")
  testthat::expect_s3_class(conn, "kagi_connection")
})

testthat::test_that("kagi_request errors on invalid query class", {
  conn <- kagiPro::kagi_connection(api_key = "dummy-kagi-key")
  out <- tempfile("kagiPro-bad-query-")
  dir.create(out, recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(out, recursive = TRUE), add = TRUE)
  testthat::expect_error(
    kagiPro::kagi_request(
      connection = conn,
      query = structure("bad", class = "not_a_query"),
      output = out
    ),
    "must be of class"
  )
})

testthat::test_that("search request is recorded with vcr", {
  testthat::skip_if_not_installed("vcr")
  skip_on_cran_if_recording()
  key <- api_key_for_cassette("kagi-search-request")
  conn <- kagiPro::kagi_connection(api_key = key)
  q <- kagiPro::query_search("openalex api", expand = FALSE)
  out <- tempfile("kagiPro-search-")
  dir.create(out, recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(out, recursive = TRUE), add = TRUE)

  vcr::use_cassette("kagi-search-request", {
    path <- kagiPro::kagi_request(
      connection = conn,
      query = q,
      limit = 1,
      output = out,
      overwrite = TRUE
    )
    testthat::expect_true(dir.exists(path))
  })

  files <- list.files(out, pattern = "^search_[0-9]+\\.json$", full.names = TRUE)
  testthat::expect_gte(length(files), 1)
})

testthat::test_that("enrich web request is recorded with vcr", {
  testthat::skip_if_not_installed("vcr")
  skip_on_cran_if_recording()
  key <- api_key_for_cassette("kagi-enrich-web-request")
  conn <- kagiPro::kagi_connection(api_key = key)
  q <- kagiPro::query_enrich_web("open data", expand = FALSE)
  out <- tempfile("kagiPro-enrich-web-")
  dir.create(out, recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(out, recursive = TRUE), add = TRUE)

  vcr::use_cassette("kagi-enrich-web-request", {
    path <- kagiPro::kagi_request(
      connection = conn,
      query = q,
      output = out,
      overwrite = TRUE
    )
    testthat::expect_true(dir.exists(path))
  })

  files <- list.files(out, pattern = "^enrich_web_[0-9]+\\.json$", full.names = TRUE)
  testthat::expect_gte(length(files), 1)
})

testthat::test_that("enrich news request is recorded with vcr", {
  testthat::skip_if_not_installed("vcr")
  skip_on_cran_if_recording()
  key <- api_key_for_cassette("kagi-enrich-news-request")
  conn <- kagiPro::kagi_connection(api_key = key)
  q <- kagiPro::query_enrich_news("climate policy", expand = FALSE)
  out <- tempfile("kagiPro-enrich-news-")
  dir.create(out, recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(out, recursive = TRUE), add = TRUE)

  vcr::use_cassette("kagi-enrich-news-request", {
    path <- kagiPro::kagi_request(
      connection = conn,
      query = q,
      output = out,
      overwrite = TRUE
    )
    testthat::expect_true(dir.exists(path))
  })

  files <- list.files(out, pattern = "^enrich_news_[0-9]+\\.json$", full.names = TRUE)
  testthat::expect_gte(length(files), 1)
})

testthat::test_that("summarize request is recorded with vcr", {
  testthat::skip_if_not_installed("vcr")
  skip_on_cran_if_recording()
  key <- api_key_for_cassette("kagi-summarize-request")
  conn <- kagiPro::kagi_connection(api_key = key)
  q <- kagiPro::query_summarize(
    text = paste(
      "Biodiversity underpins ecosystem services such as pollination, soil fertility,",
      "water purification, and climate regulation.",
      "Habitat loss, pollution, invasive species, and climate change are accelerating",
      "species decline across terrestrial and marine ecosystems.",
      "Protecting biodiversity improves food security, public health, and resilience",
      "of social and economic systems to environmental shocks."
    ),
    engine = "cecil",
    summary_type = "summary",
    target_language = "EN",
    cache = TRUE
  )
  out <- tempfile("kagiPro-summarize-")
  dir.create(out, recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(out, recursive = TRUE), add = TRUE)

  withCallingHandlers(
    vcr::use_cassette("kagi-summarize-request", {
      path <- kagiPro::kagi_request(
        connection = conn,
        query = q,
        output = out,
        overwrite = TRUE,
        error_mode = "write_dummy"
      )
      testthat::expect_true(dir.exists(path))
    }),
    warning = function(w) {
      if (grepl("Kagi request failed for endpoint `summarize`", conditionMessage(w))) {
        invokeRestart("muffleWarning")
      }
    }
  )

  files <- list.files(out, pattern = "^summarize_[0-9]+\\.json$", full.names = TRUE)
  testthat::expect_gte(length(files), 1)
  payload <- jsonlite::fromJSON(files[[1]], simplifyVector = FALSE)
  payload_id <- payload$meta$id
  if (is.null(payload_id)) {
    payload_id <- ""
  }
  if (grepl("^error_", payload_id)) {
    testthat::expect_null(payload$data$output)
    testthat::expect_equal(payload$data$tokens, 0L)
  } else {
    testthat::expect_true(is.character(payload$data$output))
    testthat::expect_true(nzchar(payload$data$output))
  }
})

testthat::test_that("fastgpt request is recorded with vcr", {
  testthat::skip_if_not_installed("vcr")
  skip_on_cran_if_recording()
  key <- api_key_for_cassette("kagi-fastgpt-request")
  conn <- kagiPro::kagi_connection(api_key = key)
  q <- kagiPro::query_fastgpt(
    query = "What is Python 3.11?",
    cache = TRUE,
    web_search = TRUE
  )
  out <- tempfile("kagiPro-fastgpt-")
  dir.create(out, recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(out, recursive = TRUE), add = TRUE)

  vcr::use_cassette("kagi-fastgpt-request", {
    path <- kagiPro::kagi_request(
      connection = conn,
      query = q,
      output = out,
      overwrite = TRUE
    )
    testthat::expect_true(dir.exists(path))
  })

  files <- list.files(out, pattern = "^fastgpt_[0-9]+\\.json$", full.names = TRUE)
  testthat::expect_gte(length(files), 1)
})

testthat::test_that("kagi_request_parquet converts local json exports", {
  in_dir <- tempfile("kagiPro-json-")
  out_dir <- tempfile("kagiPro-parquet-")
  dir.create(in_dir, recursive = TRUE, showWarnings = FALSE)
  dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(in_dir, recursive = TRUE), add = TRUE)
  on.exit(unlink(out_dir, recursive = TRUE), add = TRUE)

  payload <- list(
    meta = list(id = "x", node = "test", ms = 1),
    data = list(
      list(t = 0, url = "https://example.com", title = "Example", snippet = "S")
    )
  )
  jsonlite::write_json(
    payload,
    path = file.path(in_dir, "search_1.json"),
    auto_unbox = TRUE
  )

  res <- kagiPro::kagi_request_parquet(
    input_json = in_dir,
    output = out_dir,
    overwrite = TRUE,
    verbose = FALSE
  )

  testthat::expect_true(dir.exists(res))
  parquet_files <- list.files(res, recursive = TRUE, full.names = TRUE, pattern = "\\.parquet$")
  testthat::expect_true(length(parquet_files) > 0)

  con <- DBI::dbConnect(duckdb::duckdb())
  on.exit(DBI::dbDisconnect(con, shutdown = TRUE), add = TRUE)
  cols <- DBI::dbGetQuery(
    con,
    sprintf("SELECT * FROM read_parquet('%s') LIMIT 1", parquet_files[[1]])
  )
  testthat::expect_true("id" %in% names(cols))
  testthat::expect_match(cols$id[[1]], "^SEARCH_")
})

testthat::test_that("kagi_request_parquet uses endpoint-prefixed ids for enrich outputs", {
  payload <- list(
    meta = list(id = "x", node = "test", ms = 1),
    data = list(
      list(t = 0, url = "https://example.com/a", title = "A"),
      list(t = 1, url = "https://example.com/b", title = "B")
    )
  )

  in_web <- tempfile("kagiPro-json-enrich-web-")
  out_web <- tempfile("kagiPro-parquet-enrich-web-")
  dir.create(in_web, recursive = TRUE, showWarnings = FALSE)
  dir.create(out_web, recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(in_web, recursive = TRUE), add = TRUE)
  on.exit(unlink(out_web, recursive = TRUE), add = TRUE)

  jsonlite::write_json(
    payload,
    path = file.path(in_web, "enrich_web_1.json"),
    auto_unbox = TRUE
  )

  kagiPro::kagi_request_parquet(
    input_json = in_web,
    output = out_web,
    overwrite = TRUE,
    verbose = FALSE
  )

  parquet_web <- list.files(out_web, recursive = TRUE, full.names = TRUE, pattern = "\\.parquet$")
  testthat::expect_true(length(parquet_web) > 0)

  con <- DBI::dbConnect(duckdb::duckdb())
  on.exit(DBI::dbDisconnect(con, shutdown = TRUE), add = TRUE)
  ids_web <- DBI::dbGetQuery(
    con,
    sprintf("SELECT DISTINCT id FROM read_parquet('%s')", parquet_web[[1]])
  )$id
  testthat::expect_true(all(grepl("^ENRICH_WEB_", ids_web)))

  in_news <- tempfile("kagiPro-json-enrich-news-")
  out_news <- tempfile("kagiPro-parquet-enrich-news-")
  dir.create(in_news, recursive = TRUE, showWarnings = FALSE)
  dir.create(out_news, recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(in_news, recursive = TRUE), add = TRUE)
  on.exit(unlink(out_news, recursive = TRUE), add = TRUE)

  jsonlite::write_json(
    payload,
    path = file.path(in_news, "enrich_news_1.json"),
    auto_unbox = TRUE
  )

  kagiPro::kagi_request_parquet(
    input_json = in_news,
    output = out_news,
    overwrite = TRUE,
    verbose = FALSE
  )

  parquet_news <- list.files(out_news, recursive = TRUE, full.names = TRUE, pattern = "\\.parquet$")
  testthat::expect_true(length(parquet_news) > 0)
  ids_news <- DBI::dbGetQuery(
    con,
    sprintf("SELECT DISTINCT id FROM read_parquet('%s')", parquet_news[[1]])
  )$id
  testthat::expect_true(all(grepl("^ENRICH_NEWS_", ids_news)))
})

testthat::test_that("kagi_request_parquet can add abstracts for supported endpoints", {
  in_dir <- tempfile("kagiPro-json-add-abstract-")
  out_dir <- tempfile("kagiPro-parquet-add-abstract-")
  dir.create(in_dir, recursive = TRUE, showWarnings = FALSE)
  dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(in_dir, recursive = TRUE), add = TRUE)
  on.exit(unlink(out_dir, recursive = TRUE), add = TRUE)

  payload <- list(
    meta = list(id = "x", node = "test", ms = 1),
    data = list(
      list(t = 0, url = "https://example.com", title = "Example", snippet = "S")
    )
  )
  jsonlite::write_json(
    payload,
    path = file.path(in_dir, "search_1.json"),
    auto_unbox = TRUE
  )

  add_called <- FALSE
  testthat::local_mocked_bindings(
    kagi_connection = function(...) structure(list(), class = "kagi_connection"),
    add_sbstract_to_parquet = function(connection, input_parquet, output, overwrite, ...) {
      add_called <<- TRUE
      testthat::expect_s3_class(connection, "kagi_connection")
      testthat::expect_equal(normalizePath(input_parquet), normalizePath(out_dir))
      testthat::expect_equal(normalizePath(output), normalizePath(out_dir))
      testthat::expect_true(overwrite)
      invisible(output)
    },
    .package = "kagiPro"
  )

  kagiPro::kagi_request_parquet(
    input_json = in_dir,
    output = out_dir,
    overwrite = TRUE,
    verbose = FALSE,
    add_abstract = TRUE
  )

  testthat::expect_true(add_called)
})

testthat::test_that("kagi_request_parquet warns for add_abstract on unsupported endpoints", {
  in_dir <- tempfile("kagiPro-json-add-abstract-unsupported-")
  out_dir <- tempfile("kagiPro-parquet-add-abstract-unsupported-")
  dir.create(in_dir, recursive = TRUE, showWarnings = FALSE)
  dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(in_dir, recursive = TRUE), add = TRUE)
  on.exit(unlink(out_dir, recursive = TRUE), add = TRUE)

  payload <- list(
    meta = list(id = "sum1", node = "test", ms = 1),
    data = list(output = "Summary", tokens = 10L, title = "", authors = NULL)
  )
  jsonlite::write_json(
    payload,
    path = file.path(in_dir, "summarize_1.json"),
    auto_unbox = TRUE,
    null = "null"
  )

  add_called <- FALSE
  testthat::local_mocked_bindings(
    kagi_connection = function(...) structure(list(), class = "kagi_connection"),
    add_sbstract_to_parquet = function(...) {
      add_called <<- TRUE
      invisible(NULL)
    },
    .package = "kagiPro"
  )

  testthat::expect_warning(
    kagiPro::kagi_request_parquet(
      input_json = in_dir,
      output = out_dir,
      overwrite = TRUE,
      verbose = FALSE,
      add_abstract = TRUE
    ),
    "Skipping abstract augmentation"
  )

  testthat::expect_false(add_called)
})

testthat::test_that("list requests gracefully handle one summarize error and parquet conversion", {
  testthat::skip_if_not_installed("vcr")
  skip_on_cran_if_recording()
  key <- api_key_for_cassette("kagi-summarize-list-mixed-errors")
  conn <- kagiPro::kagi_connection(api_key = key)

  q_ok <- kagiPro::query_summarize(
    text = paste(
      "Biodiversity underpins ecosystem services such as pollination, soil fertility,",
      "water purification, and climate regulation.",
      "Habitat loss, pollution, invasive species, and climate change are accelerating",
      "species decline, which affects food security and resilience.",
      "Conservation and restoration policies can improve ecological and economic stability."
    ),
    engine = "cecil",
    summary_type = "summary",
    target_language = "EN",
    cache = TRUE
  )

  # Intentionally too short -> expected API-side summarize error
  q_err <- kagiPro::query_summarize(
    text = "Too short.",
    engine = "cecil",
    summary_type = "summary",
    target_language = "EN",
    cache = TRUE
  )

  q_list <- list(ok = q_ok, err = q_err)

  out <- tempfile("kagiPro-summarize-list-")
  dir.create(out, recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(out, recursive = TRUE), add = TRUE)

  got_expected_warning <- FALSE
  withCallingHandlers(
    vcr::use_cassette("kagi-summarize-list-mixed-errors", {
      kagiPro::kagi_request(
        connection = conn,
        query = q_list,
        output = out,
        overwrite = TRUE,
        workers = 1,
        error_mode = "write_dummy"
      )
    }),
    warning = function(w) {
      if (grepl("Kagi request failed for endpoint `summarize`", conditionMessage(w))) {
        got_expected_warning <<- TRUE
        invokeRestart("muffleWarning")
      }
    }
  )
  testthat::expect_true(got_expected_warning)

  ok_json <- file.path(out, "ok", "summarize_1.json")
  err_json <- file.path(out, "err", "summarize_1.json")
  testthat::expect_true(file.exists(ok_json))
  testthat::expect_true(file.exists(err_json))

  err_payload <- jsonlite::fromJSON(err_json, simplifyVector = FALSE)
  testthat::expect_match(err_payload$meta$id, "^error_")
  testthat::expect_null(err_payload$data$output)
  testthat::expect_equal(err_payload$data$tokens, 0L)

  parquet_dir <- tempfile("kagiPro-summarize-error-parquet-")
  dir.create(parquet_dir, recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(parquet_dir, recursive = TRUE), add = TRUE)

  parquet_path <- kagiPro::kagi_request_parquet(
    input_json = file.path(out, "err"),
    output = parquet_dir,
    overwrite = TRUE,
    verbose = FALSE
  )
  testthat::expect_true(dir.exists(parquet_path))
  testthat::expect_true(length(list.files(parquet_path, recursive = TRUE)) > 0)
})

testthat::test_that("write_dummy mode produces endpoint-aware fallback payloads", {
  conn <- kagiPro::kagi_connection(
    base_url = "https://no-such-host.invalid/api/v0",
    api_key = "dummy-kagi-key"
  )

  test_cases <- list(
    list(name = "search", query = kagiPro::query_search("x", expand = FALSE)),
    list(name = "enrich_web", query = kagiPro::query_enrich_web("x", expand = FALSE)),
    list(name = "enrich_news", query = kagiPro::query_enrich_news("x", expand = FALSE)),
    list(name = "summarize", query = kagiPro::query_summarize(text = paste(rep("x", 50), collapse = " "))),
    list(name = "fastgpt", query = kagiPro::query_fastgpt("What is x?"))
  )

  for (tc in test_cases) {
    out <- tempfile(paste0("kagiPro-dummy-", tc$name, "-"))
    dir.create(out, recursive = TRUE, showWarnings = FALSE)
    on.exit(unlink(out, recursive = TRUE), add = TRUE)

    testthat::expect_warning(
      kagiPro::kagi_request(
        connection = conn,
        query = tc$query,
        output = out,
        overwrite = TRUE,
        error_mode = "write_dummy"
      ),
      "Kagi request failed for endpoint"
    )

    json_files <- list.files(out, pattern = "\\.json$", full.names = TRUE)
    testthat::expect_gte(length(json_files), 1)

    payload <- jsonlite::fromJSON(json_files[[1]], simplifyVector = FALSE)
    testthat::expect_match(payload$meta$id, "^error_")
    testthat::expect_true(nzchar(payload$meta$endpoint))

    if (payload$meta$endpoint == "summarize") {
      testthat::expect_null(payload$data$output)
      testthat::expect_equal(payload$data$tokens, 0L)
    }
    if (payload$meta$endpoint == "fastgpt") {
      testthat::expect_null(payload$data$output)
      testthat::expect_equal(payload$data$tokens, 0L)
    }
  }
})

testthat::test_that("add_sbstract_to_parquet adds Abstract to search parquet", {
  search_dir <- tempfile("kagiPro-bridge-search-")
  out_dir <- tempfile("kagiPro-bridge-out-")
  dir.create(search_dir, recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(search_dir, recursive = TRUE), add = TRUE)
  on.exit(unlink(out_dir, recursive = TRUE), add = TRUE)

  search_payload <- list(
    meta = list(id = "search1"),
    data = list(
      list(
        t = 0,
        url = "https://example.org/paper-a/",
        title = "Paper A",
        snippet = "Snippet A"
      ),
      list(
        t = 1,
        url = "https://example.org/paper-b",
        title = "Paper B",
        snippet = "Snippet B"
      )
    )
  )

  json_dir <- tempfile("kagiPro-json-bridge-")
  dir.create(json_dir, recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(json_dir, recursive = TRUE), add = TRUE)

  jsonlite::write_json(
    search_payload,
    path = file.path(json_dir, "search_1.json"),
    auto_unbox = TRUE
  )

  kagiPro::kagi_request_parquet(
    input_json = json_dir,
    output = search_dir,
    overwrite = TRUE,
    verbose = FALSE
  )

  conn <- kagiPro::kagi_connection(api_key = "dummy-kagi-key")

  testthat::local_mocked_bindings(
    kagi_request = function(connection, query, output, ...) {
      dir.create(output, recursive = TRUE, showWarnings = FALSE)
      ids <- names(query)

      # First id gets a summary, second is intentionally missing (NA expected)
      dir.create(file.path(output, ids[[1]]), recursive = TRUE, showWarnings = FALSE)
      jsonlite::write_json(
        list(
          meta = list(id = "sum1"),
          data = list(output = "Summary for first result", tokens = 10L, title = "", authors = NULL)
        ),
        path = file.path(output, ids[[1]], "summarize_1.json"),
        auto_unbox = TRUE,
        null = "null"
      )
      invisible(output)
    },
    .package = "kagiPro"
  )

  out_path <- kagiPro::add_sbstract_to_parquet(
    connection = conn,
    input_parquet = search_dir,
    output = out_dir,
    overwrite = TRUE,
    error_mode = "write_dummy"
  )

  testthat::expect_true(dir.exists(out_path))

  parquet_files <- list.files(out_path, recursive = TRUE, full.names = TRUE, pattern = "\\.parquet$")
  testthat::expect_true(length(parquet_files) > 0)

  con <- DBI::dbConnect(duckdb::duckdb())
  on.exit(DBI::dbDisconnect(con, shutdown = TRUE), add = TRUE)
  out <- DBI::dbGetQuery(
    con,
    sprintf("SELECT * FROM read_parquet('%s')", parquet_files[[1]])
  )

  testthat::expect_true(all(c("id", "Title", "Abstract") %in% names(out)))
  testthat::expect_true(any(!is.na(out$Abstract)))
  testthat::expect_true(any(is.na(out$Abstract)))
})
