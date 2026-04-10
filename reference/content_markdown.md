# Extract Downloaded Content to Markdown

Extract Downloaded Content to Markdown

## Usage

``` r
content_markdown(
  project_folder,
  endpoint = NULL,
  query_name = NULL,
  text_root = "markdown",
  output_format = "markdown",
  workers = 4,
  verbose = FALSE,
  progress = interactive()
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

- text_root:

  Root folder name used for extracted text outputs.

- output_format:

  Output format. Only \`"markdown"\` is supported.

- workers:

  Number of parallel workers to use for extraction.

- verbose:

  Logical indicating whether progress messages should be shown.

- progress:

  Logical indicating whether a progress bar should be shown.

## Value

A data frame with extraction status and diagnostics columns:
\`endpoint\`, \`id\`, \`query\`, \`text_path\`, \`status\`, \`error\`.
