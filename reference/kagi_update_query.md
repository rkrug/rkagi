# Re-Run a Stored Query by Name and Refresh Parquet

Update one query dataset by `query_name` using metadata written by
[`kagi_request()`](https://rkrug.github.io/kagiPro/reference/kagi_request.md).
The function scans per-query metadata files under
`<project_folder>/<endpoint>/json/<query_name>/_query_meta.json`,
re-runs all matching query definitions, and refreshes only the touched
parquet query partitions.

## Usage

``` r
kagi_update_query(
  connection,
  project_folder,
  query_name,
  workers = 1,
  verbose = FALSE,
  error_mode = c("stop", "write_dummy")
)
```

## Arguments

- connection:

  A
  [`kagi_connection()`](https://rkrug.github.io/kagiPro/reference/kagi_connection.md)
  object.

- project_folder:

  Root project folder containing endpoint subfolders.

- query_name:

  Query name to update (for example `"query_1"` or
  `"biodiversity_main"`).

- workers:

  Number of workers for request execution.

- verbose:

  Logical indicating whether progress messages should be shown.

- error_mode:

  Error handling mode passed to
  [`kagi_request()`](https://rkrug.github.io/kagiPro/reference/kagi_request.md).
  One of `"stop"` or `"write_dummy"`.

## Value

Named list of normalized parquet output paths by updated endpoint.

## Details

If the same `query_name` exists across multiple endpoints, all matching
endpoints are updated.

## Examples

``` r
if (FALSE) { # \dontrun{
kagi_update_query(
  connection = conn,
  project_folder = "kagi_project",
  query_name = "query_1"
)
} # }
```
