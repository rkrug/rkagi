# Convert JSON files to Apache Parquet files

Convert a directory of JSON files written by
[`kagi_request()`](https://rkrug.github.io/kagiPro/reference/kagi_request.md)
into an Apache Parquet dataset. JSON files are processed one-by-one and
written as hive-partitioned parquet by `query`.

## Usage

``` r
kagi_request_parquet(
  input_json = NULL,
  output = NULL,
  add_columns = list(),
  overwrite = FALSE,
  append = FALSE,
  verbose = TRUE,
  delete_input = FALSE
)
```

## Arguments

- input_json:

  Directory containing JSON files from
  [`kagi_request()`](https://rkrug.github.io/kagiPro/reference/kagi_request.md).

- output:

  output directory for the parquet dataset; default: temporary
  directory.

- add_columns:

  List of additional fields to be added to the output. They have to be
  provided as a named list, e.g.
  `list(column_1 = "value_1", column_2 = 2)`. Only Scalar values are
  supported.

- overwrite:

  Logical indicating whether to overwrite `output`.

- append:

  Logical indicating whether to append/update query partitions in an
  existing `output` directory without deleting untouched queries.

- verbose:

  Logical indicating whether to print progress information. Defaults to
  `TRUE`

- delete_input:

  Determines if the `input_json` should be deleted afterwards. Defaults
  to `FALSE`.

## Value

Returns `output` invisibly if parquet files were written; otherwise
`NULL`.

## Details

The function uses DuckDB to read the JSON files and to create the Apache
Parquet files. It creates an in-memory DuckDB connection, reads each
JSON response, and writes endpoint-specific tabular data into the
parquet dataset. Files with `data = null` are skipped.

Output parquet rows include an `id` column for traceability:

- Search: `SEARCH_<hash>` from normalized `url` when available.

- Enrich web: `ENRICH_WEB_<hash>` from normalized `url` when available.

- Enrich news: `ENRICH_NEWS_<hash>` from normalized `url` when
  available.

- Summarize: `SUMMARIZE_<hash>` from request metadata.

- FastGPT: `FASTGPT_<hash>` from request metadata.
