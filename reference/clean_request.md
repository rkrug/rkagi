# Clean JSON Request Data While Preserving Query Metadata

Remove JSON request data files from endpoint JSON folders in a project
while preserving per-query metadata files (`_query_meta.json`).

## Usage

``` r
clean_request(project_folder, dry_run = FALSE, verbose = TRUE)
```

## Arguments

- project_folder:

  Root project folder containing endpoint subfolders.

- dry_run:

  Logical. If `TRUE`, do not delete anything and only report what would
  be removed.

- verbose:

  Logical. If `TRUE`, print progress messages.

## Value

A list with:

- `details`: data frame with per-query deletion counts/bytes

- `totals`: list with `files` and `bytes`

- `dry_run`: logical flag

## Details

This function is intended for reclaiming disk space while keeping enough
metadata for
[`kagi_update_query()`](https://rkrug.github.io/kagiPro/reference/kagi_update_query.md)
reruns.

## Examples

``` r
if (FALSE) { # \dontrun{
clean_request("kagi_project", dry_run = TRUE)
clean_request("kagi_project", dry_run = FALSE)
} # }
```
