# Summarize Text via Kagi Summarize Endpoint

Summarize Text via Kagi Summarize Endpoint

## Usage

``` r
summarize_with_kagi(
  text,
  model = "cecil",
  connection = NULL,
  api_key = NULL,
  base_url = NULL,
  summary_type = "summary",
  target_language = "EN",
  cache = TRUE,
  retry_max_tries = 5
)
```

## Arguments

- text:

  Plain text to summarize.

- model:

  Kagi summarize engine (\`"cecil"\`, \`"agnes"\`, \`"muriel"\`,
  \`"daphne"\`).

- connection:

  Optional \[kagi_connection()\] object.

- api_key:

  Optional Kagi API key override.

- base_url:

  Optional Kagi API base URL override.

- summary_type:

  Summarize mode (\`"summary"\` or \`"takeaway"\`).

- target_language:

  Target language code.

- cache:

  Cache flag forwarded to Kagi summarize endpoint.

- retry_max_tries:

  Maximum number of HTTP retry attempts passed to
  \[httr2::req_retry()\].

## Value

A single summary string (or \`NA_character\_\`).
