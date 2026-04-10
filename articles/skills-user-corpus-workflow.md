# Skill: User Corpus Workflow

## User Corpus Workflow

Use this skill for corpus-building tasks aligned with
`vignettes/corpus-workflow.qmd`.

### Required Workflow Order

1.  Create
    [`kagi_connection()`](https://rkrug.github.io/kagiPro/reference/kagi_connection.md).
2.  Build one or more endpoint queries (typically
    [`query_search()`](https://rkrug.github.io/kagiPro/reference/query_search.md)).
3.  Run
    [`kagi_fetch()`](https://rkrug.github.io/kagiPro/reference/kagi_fetch.md)
    (or
    [`kagi_request()`](https://rkrug.github.io/kagiPro/reference/kagi_request.md) +
    [`kagi_request_parquet()`](https://rkrug.github.io/kagiPro/reference/kagi_request_parquet.md)).
4.  Run
    [`download_content()`](https://rkrug.github.io/kagiPro/reference/download_content.md).
5.  Run
    [`content_markdown()`](https://rkrug.github.io/kagiPro/reference/content_markdown.md).
6.  Run
    [`markdown_abstract()`](https://rkrug.github.io/kagiPro/reference/markdown_abstract.md).
7.  Read with `read_corpus(abstracts = TRUE)` when needed.

### Allowed Function Set

- [`kagi_connection()`](https://rkrug.github.io/kagiPro/reference/kagi_connection.md)
- [`query_search()`](https://rkrug.github.io/kagiPro/reference/query_search.md)
- [`kagi_fetch()`](https://rkrug.github.io/kagiPro/reference/kagi_fetch.md)
- [`kagi_request()`](https://rkrug.github.io/kagiPro/reference/kagi_request.md)
- [`kagi_request_parquet()`](https://rkrug.github.io/kagiPro/reference/kagi_request_parquet.md)
- [`download_content()`](https://rkrug.github.io/kagiPro/reference/download_content.md)
- [`content_markdown()`](https://rkrug.github.io/kagiPro/reference/content_markdown.md)
- [`markdown_abstract()`](https://rkrug.github.io/kagiPro/reference/markdown_abstract.md)
- [`summarize_with_openai()`](https://rkrug.github.io/kagiPro/reference/summarize_with_openai.md)
- [`summarize_with_kagi()`](https://rkrug.github.io/kagiPro/reference/summarize_with_kagi.md)
- [`read_corpus()`](https://rkrug.github.io/kagiPro/reference/read_corpus.md)

### Selector Rules

- `endpoint = NULL` means process all supported endpoints.
- `query_name = NULL` means process all queries in selected endpoint(s).
- Keep file layout explicit:
  `<project>/<endpoint>/{json,parquet,content,markdown,abstract}`.

### Error Handling Rules

- Keep row-level failures as status/error outputs where supported.
- Use strict mode in CI-like runs; resilient mode for long batches.
- Do not invent fallback extraction behavior beyond package
  implementation.

### References

Read and apply: - `references/workflow.md` - `references/examples.md`

### References

#### Workflow

## Corpus Workflow

1.  Build queries with endpoint constructors.
2.  Fetch to project folders (`kagi_fetch`) or request + parquet
    manually.
3.  Download source content (`download_content`).
4.  Convert content to markdown (`content_markdown`).
5.  Summarize markdown to abstract parquet (`markdown_abstract`).
6.  Read datasets with optional abstract linking
    (`read_corpus(abstracts = TRUE)`).

### Folder Contract

- `<project>/<endpoint>/json`
- `<project>/<endpoint>/parquet`
- `<project>/<endpoint>/content/query=<query>`
- `<project>/<endpoint>/markdown/query=<query>`
- `<project>/<endpoint>/abstract/query=<query>`

### Provider Guidance

- Prefer
  [`summarize_with_openai()`](https://rkrug.github.io/kagiPro/reference/summarize_with_openai.md)
  for general text quality.
- Use
  [`summarize_with_kagi()`](https://rkrug.github.io/kagiPro/reference/summarize_with_kagi.md)
  when staying inside Kagi API stack.
- Use conservative concurrency for OpenAI due to rate limits.

#### Examples

## Corpus Examples

``` r
conn <- kagi_connection(api_key = function() keyring::key_get("API_kagi"))

queries <- list(
  bio_reports = query_search("biodiversity annual report", expand = FALSE)[[1]],
  ecosystem_methods = query_search("ecosystem services valuation methods", expand = FALSE)[[1]]
)

kagi_fetch(
  connection = conn,
  query = queries,
  project_folder = "tests_complex",
  overwrite = TRUE
)
```

``` r
download_content(
  project_folder = "tests_complex",
  endpoint = "search",
  query_name = NULL,
  workers = 4
)

content_markdown(
  project_folder = "tests_complex",
  endpoint = "search",
  query_name = NULL,
  workers = 4
)
```

``` r
markdown_abstract(
  project_folder = "tests_complex",
  endpoint = "search",
  query_name = NULL,
  summarizer_fn = summarize_with_openai,
  model = "gpt-4.1-mini",
  workers = 1
)

ds <- read_corpus(
  project_folder = "tests_complex",
  endpoint = "search",
  corpus = "parquet",
  abstracts = TRUE,
  silent = TRUE
)
```
