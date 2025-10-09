#' `openalexR::oa_request()` with additional argument
#'
#' This function adds one argument to `openalexR::oa_request()`, namely
#' `output`. When specified, all return values from OpenAlex will be saved as
#' jaon files in that directory and the return value is the directory of the
#' json files.
#'
#' For the documentation please see `openalexR::oa_request()`
#' If query is a list, the function is called for each element of the list in parallel
#' using a maximum of `workers` parallel R sessions. The results from the individual URLs
#' in the list are returned in a folder named after the names of the list elements in the
#' `output` folder.
#' @param query The URL of the API query or a list of URLs returned from `pro_query()`.
#' @param pages The number of pages to be downloaded. The default is set to
#'   1000, which would be 2,000,000 works. It is recommended to not increase it
#'   beyond 1000 due to server load and to use the snapshot instead. If `NULL`,
#'   all pages will be downloaded. Default: 1000.
#' @param output directory where the JSON files are saved. Default is a
#'   temporary directory. If `NULL`, the return value from call to
#'   `openalexR::oa_request()` with all the arguments is returned
#' @param overwrite Logical. If `TRUE`, `output` will be deleted if it already
#'   exists.
#' @param append if `TRUE`, the results will be appended to the existing files in `output`.
#' @param workers Number of parallel workers to use if `query` is a list. Defaults to 1.
#' @param verbose Logical indicating whether to show verbose messages.
#'
#' @return If `output` is `NULL`, the return value from call to
#'   `openalexR::oa_request()`, otherwise the complete path to the expanded and
#'   normalized `output`.
#'
#' @md
#'
#' @importFrom utils tail
#' @importFrom httr2 req_url_query req_perform resp_body_json resp_body_string
#' @importFrom utils packageVersion
#' @importFrom future plan multisession sequential
#' @importFrom future.apply future_lapply
#'
#' @export
#'
kagi_request <- function(
  connection,
  query,
  limit = NULL,
  output = NULL,
  overwrite = FALSE,
  append = FALSE,
  workers = 1,
  verbose = FALSE
) {
  # Helper function -------------------------------------------------------

  output_check <- function(output, overwrite, append, verbose) {
    if (dir.exists(output)) {
      if (!overwrite & !append) {
        stop(
          "Directory ",
          output,
          " exists.\n",
          "Either specify `overwrite = TRUE` , `append = TRUE` or delete it."
        )
      }
      if (!append) {
        if (verbose) {
          message(
            "Deleting and recreating `",
            output,
            "` to avoid inconsistencies."
          )
        }
      } else {
        if (verbose) {
          message(
            "Appending to existing files in `",
            output,
            "`."
          )
        }
        return(output)
      }
      unlink(output, recursive = TRUE)
    }
  }

  # uargument check ------------------------------------------------------------

  if (!inherits(connection, "kagi_connection")) {
    stop("`connection` must be of class `kagi_connection`.")
  }

  if (
    !inherits(
      query,
      c(
        "kagi_search_query",
        "kagi_summarize_query",
        "kagi_enrich_web_query",
        "kagi_enrich_news_query",
        "list"
      )
    )
  ) {
    stop(
      "`query` must be of class `kagi_search_query`, `kagi_summarize_query` or `list` of such objects."
    )
  }

  # Call for each element if query is a list ---------------------------

  if (
    !inherits(
      query,
      c(
        "kagi_search_query",
        "kagi_summarize_query",
        "kagi_enrich_web_query",
        "kagi_enrich_news_query"
      )
    )
  ) {
    future::plan(future::multisession, workers = workers)

    on.exit(
      future::plan(future::sequential),
      add = TRUE
    )

    output_check(output, overwrite, append, verbose)

    result <- future.apply::future_lapply(
      seq_along(query),
      function(i) {
        nm <- names(query)[i]
        if (is.null(nm)) {
          nm <- paste0("query_", i)
        }
        kagi_request(
          connection = connection,
          query = query[[i]],
          limit = limit,
          output = file.path(output, nm),
          overwrite = FALSE,
          append = TRUE,
          verbose = verbose
        )
      },
      future.seed = TRUE
    )
    return(output)
  } else {
    # Argument Checks --------------------------------------------------------

    if (is.null(output)) {
      stop("No `output` output specified!")
    }

    output_check(output, overwrite, append, verbose)

    # Preparations -----------------------------------------------------------

    dir.create(output, recursive = TRUE, showWarnings = FALSE)

    output <- normalizePath(output)

    req <- switch(
      class(query)[[1]],
      kagi_search_query = {
        endpoint <- "search"
        connection |>
          httr2::req_url_path_append(endpoint) |>
          httr2::req_url_query(
            q = query,
            limit = limit
          )
      },
      kagi_summarize_query = {
        endpoint <- "summarize"
        connection |>
          httr2::req_url_path_append(endpoint) |>
          httr2::req_headers(
            "Content-Type" = "application/json"
          ) |>
          httr2::req_body_json(
            as.list(
              query
            )
          )
      },
      kagi_enrich_web_query = {
        endpoint <- "enrich/web"
        connection |>
          httr2::req_url_path_append(endpoint) |>
          httr2::req_url_query(
            q = query,
            limit = limit
          )
      },
      kagi_enrich_news_query = {
        endpoint <- "enrich/news"
        connection |>
          httr2::req_url_path_append(endpoint) |>
          httr2::req_url_query(
            q = query,
            limit = limit
          )
      },
      stop("Unknown Query Class: ", class(query))
    )

    req <- req |>
      httr2::req_user_agent(
        paste(
          "rkagi v",
          packageVersion("rkagi")
        )
      )

    if (verbose) {
      message("Request:\n")
      message("URL: ", req$url)
      message("\n")
    }

    # Remove empty query parameters

    # Initialize results and page counter
    page <- 1

    # Pagination loop
    repeat {
      if (verbose) {
        message("\nDownloading page ", page)
        NULL
      }

      resp <- req_perform(req)

      data <- resp |>
        httr2::resp_body_json()

      resp |>
        httr2::resp_body_string() |>
        writeLines(
          con = file.path(
            output,
            paste0(gsub("/", "_", endpoint), "_", page, ".json")
          )
        )

      ## This always breaks and nneeds to be adjusted for the new API!
      if (is.null(data$meta$next_cursor)) {
        break
      }

      req <- req |>
        httr2::req_url_query(cursor = data$meta$next_cursor)

      page <- page + 1
    }
    ###

    return(output)
  }
}
