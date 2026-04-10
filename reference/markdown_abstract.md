# Summarize Markdown into Query-Level Abstract Parquet

Read markdown files generated for a specific endpoint/query and
summarize each record with either OpenAI or Kagi text summarization. The
result is written as a single parquet file per query under
\`abstract/\`.

## Usage

``` r
markdown_abstract(
  project_folder,
  endpoint = NULL,
  query_name = NULL,
  workers = 4,
  progress = interactive(),
  verbose = FALSE,
  summarizer_fn = summarize_with_openai,
  model = "gpt-4.1-mini",
  connection = NULL,
  provider_args = list(),
  markdown_root = "markdown",
  abstract_root = "abstract"
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

  Number of parallel workers to use for summarization.

- progress:

  Logical indicating whether progress messages should be shown.

- verbose:

  Logical indicating whether detailed messages should be shown.

- summarizer_fn:

  Function with signature \`fn(text, model, ...) -\> character(1) \|
  NA_character\_\`.

- model:

  Provider-specific model/engine.

- connection:

  Optional \[kagi_connection()\] object. Used for
  \[summarize_with_kagi()\] when not supplied via \`provider_args\`.

- provider_args:

  Optional named list forwarded to \`summarizer_fn\`.

- markdown_root:

  Root folder name containing markdown files.

- abstract_root:

  Root folder name for abstract parquet outputs.

## Value

Invisibly returns a data frame with columns \`endpoint\`, \`id\`,
\`query\`, \`abstract\`, \`status\`, \`error\`.
