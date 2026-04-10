# Agent Quick Index

This page is a machine-friendly, human-readable quick selector for
exported functions.

## Connection and Authentication

- [`kagi_connection()`](https://rkrug.github.io/kagiPro/reference/kagi_connection.md)
  Build a reusable authenticated connection.

## Query Construction

- [`query_search()`](https://rkrug.github.io/kagiPro/reference/query_search.md)
  Build Search endpoint requests.
- [`query_enrich_web()`](https://rkrug.github.io/kagiPro/reference/query_enrich_web.md)
  Build Enrich Web endpoint requests.
- [`query_enrich_news()`](https://rkrug.github.io/kagiPro/reference/query_enrich_news.md)
  Build Enrich News endpoint requests.
- [`query_summarize()`](https://rkrug.github.io/kagiPro/reference/query_summarize.md)
  Build Summarize endpoint requests.
- [`query_fastgpt()`](https://rkrug.github.io/kagiPro/reference/query_fastgpt.md)
  Build FastGPT endpoint requests.

## Request Execution

- [`kagi_request()`](https://rkrug.github.io/kagiPro/reference/kagi_request.md)
  Low-level request execution into JSON output folders.
- [`kagi_fetch()`](https://rkrug.github.io/kagiPro/reference/kagi_fetch.md)
  High-level project workflow executor writing endpoint-scoped
  JSON/parquet.

## Storage and Refresh

- [`kagi_request_parquet()`](https://rkrug.github.io/kagiPro/reference/kagi_request_parquet.md)
  Convert request JSON folders to parquet.
- [`kagi_update_query()`](https://rkrug.github.io/kagiPro/reference/kagi_update_query.md)
  Re-run one stored query by name and refresh touched parquet
  partitions.
- [`clean_request()`](https://rkrug.github.io/kagiPro/reference/clean_request.md)
  Remove JSON payload artifacts while preserving query metadata.

## Content and Abstract Pipeline

- [`download_content()`](https://rkrug.github.io/kagiPro/reference/download_content.md)
  Download source content for endpoint/query partitions.
- [`content_markdown()`](https://rkrug.github.io/kagiPro/reference/content_markdown.md)
  Convert downloaded files to markdown.
- [`markdown_abstract()`](https://rkrug.github.io/kagiPro/reference/markdown_abstract.md)
  Summarize markdown and write abstract parquet outputs.
- [`summarize_with_openai()`](https://rkrug.github.io/kagiPro/reference/summarize_with_openai.md)
  OpenAI text summarization provider.
- [`summarize_with_kagi()`](https://rkrug.github.io/kagiPro/reference/summarize_with_kagi.md)
  Kagi text summarization provider.
- [`read_corpus()`](https://rkrug.github.io/kagiPro/reference/read_corpus.md)
  Read parquet corpus and optionally link abstract data.

## Utility

- [`open_search_query()`](https://rkrug.github.io/kagiPro/reference/open_search_query.md)
  Open rendered search query in browser for inspection.
