# Summarize Text via OpenAI Chat Completions

Summarize Text via OpenAI Chat Completions

## Usage

``` r
summarize_with_openai(
  text,
  model = "gpt-4.1-mini",
  api_key = Sys.getenv("API_openai", ""),
  base_url = "https://api.openai.com/v1",
  system_prompt = "Summarize input text in 4-6 concise sentences for literature review.",
  retry_max_tries = 5
)
```

## Arguments

- text:

  Plain text to summarize.

- model:

  OpenAI model name.

- api_key:

  OpenAI API key. Defaults to \`API_openai\`.

- base_url:

  OpenAI API base URL.

- system_prompt:

  Prompt used to guide summarization behavior.

- retry_max_tries:

  Maximum number of HTTP retry attempts passed to
  \[httr2::req_retry()\].

## Value

A single summary string (or \`NA_character\_\`).
