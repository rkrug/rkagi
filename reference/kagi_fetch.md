# Fetch Kagi Data into an Endpoint-Structured Project Folder

High-level helper that runs
[`kagi_request()`](https://rkrug.github.io/kagiPro/reference/kagi_request.md)
and
[`kagi_request_parquet()`](https://rkrug.github.io/kagiPro/reference/kagi_request_parquet.md)
in sequence and writes outputs into endpoint-scoped project folders.

## Usage

``` r
kagi_fetch(
  connection,
  query,
  project_folder = NULL,
  endpoint = NULL,
  overwrite = FALSE,
  workers = 1,
  limit = NULL,
  verbose = FALSE,
  error_mode = c("stop", "write_dummy")
)
```

## Arguments

- connection:

  A
  [`kagi_connection()`](https://rkrug.github.io/kagiPro/reference/kagi_connection.md)
  object.

- query:

  A query object of class `kagi_query_*` or a list of query objects.

- project_folder:

  Root folder for endpoint-scoped outputs. If `NULL`, a temporary
  directory is used.

- endpoint:

  Optional endpoint override. One of `"search"`, `"enrich_web"`,
  `"enrich_news"`, `"summarize"`, `"fastgpt"`.

- overwrite:

  Logical. If `TRUE`, endpoint output folders are overwritten.

- workers:

  Number of workers for list requests.

- limit:

  Optional integer limit used for search/enrich request calls.

- verbose:

  Logical indicating whether progress messages should be shown.

- error_mode:

  Error handling mode passed to
  [`kagi_request()`](https://rkrug.github.io/kagiPro/reference/kagi_request.md).
  One of `"stop"` or `"write_dummy"`.

## Value

For a single endpoint, normalized parquet path. For mixed endpoint query
lists, a named list of normalized parquet paths by endpoint.

## Details

Folder layout:

- `<project_folder>/<endpoint>/json`

- `<project_folder>/<endpoint>/parquet`

## Examples

``` r
if (FALSE) { # \dontrun{
conn <- kagi_connection(api_key = function() keyring::key_get("API_kagi"))
q <- query_search("biodiversity", expand = FALSE)

kagi_fetch(
  connection = conn,
  query = q,
  project_folder = "kagi_project"
)
} # }
```
