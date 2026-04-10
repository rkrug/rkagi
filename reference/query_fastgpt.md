# Create a FastGPT query payload

Construct one or more FastGPT query payloads for `POST /fastgpt`. Use
[`kagi_request()`](https://rkrug.github.io/kagiPro/reference/kagi_request.md)
to execute the request and obtain JSON responses.

## Usage

``` r
query_fastgpt(query, cache = TRUE, web_search = TRUE)
```

## Arguments

- query:

  Character vector. Query text to answer.

- cache:

  Logical. Whether cached responses are allowed. Default: `TRUE`.

- web_search:

  Logical. Whether to use web search enrichment. Default: `TRUE`.

## Value

A named list of query objects of class `kagi_query_fastgpt` to be used
in
[`kagi_request()`](https://rkrug.github.io/kagiPro/reference/kagi_request.md).

## Details

According to current Kagi FastGPT API behavior, `web_search = FALSE` is
out of service and rejected. This constructor enforces
`web_search = TRUE`.

## Examples

``` r
if (FALSE) { # \dontrun{
query_fastgpt("Python 3.11")
query_fastgpt(c("Python 3.11", "What is biodiversity?"))
} # }
```
