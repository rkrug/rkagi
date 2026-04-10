# Read a kagiPro Parquet Corpus

Modelled on \`openalexPro::read_corpus()\` with an additional
\`abstracts\` switch. By default this opens an Arrow dataset from a
parquet directory. When \`return_data = TRUE\`, the result is collected
into memory.

## Usage

``` r
read_corpus(
  project_folder,
  endpoint,
  corpus = "parquet",
  return_data = FALSE,
  abstracts = FALSE,
  silent = FALSE
)
```

## Arguments

- project_folder:

  Root project folder.

- endpoint:

  Endpoint folder name under \`project_folder\`.

- corpus:

  Folder name under \`project_folder/endpoint\` to read as parquet
  corpus. Defaults to \`"parquet"\`.

- return_data:

  Logical; if \`TRUE\`, collect and return in-memory data.

- abstracts:

  Logical; if \`TRUE\`, link sibling abstract data by \`id\` and
  \`query\`.

- silent:

  Logical; if \`TRUE\`, suppress informative messages.

## Value

An Arrow dataset/query when \`return_data = FALSE\`, otherwise a data
frame/tibble.

## Details

If \`abstracts = TRUE\`, abstract data is read from the sibling
\`abstract\` folder and left-joined by \`id\` + \`query\`. If no
abstract files are present, an \`abstract\` column filled with \`NA\` is
added.
