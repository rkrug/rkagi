# Download Endpoint Content for Abstract Generation

Download Endpoint Content for Abstract Generation

## Usage

``` r
download_content(
  project_folder,
  endpoint = NULL,
  query_name = NULL,
  workers = 4,
  progress = interactive(),
  verbose = FALSE
)
```

## Arguments

- project_folder:

  Root project folder containing endpoint subfolders.

- endpoint:

  Optional endpoint selector (for example \`"search"\` or
  \`"enrich_news"\`). If \`NULL\`, all supported endpoints are
  considered.

- query_name:

  Optional query selector. If \`NULL\`, all query partitions are
  considered.

- workers:

  Number of parallel workers to use for downloads.

- progress:

  Logical indicating whether a progress bar should be shown.

- verbose:

  Logical indicating whether progress messages should be shown.

## Value

A data frame with download status and paths.
