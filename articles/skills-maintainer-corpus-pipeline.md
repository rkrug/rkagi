# Skill: Maintainer Corpus Pipeline

## Maintainer Corpus Pipeline

Use this skill for internals of the modular corpus pipeline.

### Scope

Apply when changing any of:

- [`download_content()`](https://rkrug.github.io/kagiPro/reference/download_content.md)
- [`content_markdown()`](https://rkrug.github.io/kagiPro/reference/content_markdown.md)
- [`markdown_abstract()`](https://rkrug.github.io/kagiPro/reference/markdown_abstract.md)
- [`summarize_with_openai()`](https://rkrug.github.io/kagiPro/reference/summarize_with_openai.md)
- [`summarize_with_kagi()`](https://rkrug.github.io/kagiPro/reference/summarize_with_kagi.md)
- `read_corpus(abstracts = TRUE)` linking behavior

### Required Contracts

1.  Preserve folder layout by endpoint and query partition.
2.  Keep `id + query` as the abstract linking key.
3.  Keep abstract schema with lowercase `abstract`.
4.  Keep row-level status/error reporting for partial failures.
5.  Keep provider functions pluggable via function argument.

### Retry and Concurrency Rules

- OpenAI provider should default to conservative request concurrency.
- Retry behavior must remain explicit and documented.
- Progress output should reflect file-level work, not only worker
  completion.

### Documentation Sync Rules

When behavior changes, update together:

- `README.md` pipeline section
- `vignettes/corpus-workflow.qmd`
- `PROJECT_DESIGN.md`
- this skill’s references

### References

Read and apply: - `references/contracts.md` - `references/testing.md`

### References

#### Contracts

## Corpus Pipeline Contracts

### File Layout

- `<project>/<endpoint>/parquet`
- `<project>/<endpoint>/content/query=<query>`
- `<project>/<endpoint>/markdown/query=<query>`
- `<project>/<endpoint>/abstract/query=<query>`

### Data Contracts

- Join key: `id + query`
- Abstract field: `abstract` (lowercase)
- Multi-selector behavior:
  - `endpoint = NULL` expands across supported endpoints.
  - `query_name = NULL` expands across all queries.

### Failure Contracts

- Per-row failures should yield status/error outputs.
- Pipeline should avoid whole-run termination for single-record
  extraction/summarization failures unless strict mode is explicitly
  requested.

#### Testing

## Corpus Pipeline Testing

1.  Validate selector expansion (`endpoint` / `query_name` NULL
    behavior).
2.  Validate file placement for `content`, `markdown`, and `abstract`.
3.  Validate `read_corpus(abstracts = TRUE)` lazy-link behavior by
    `id + query`.
4.  Validate schema expectations (`abstract` lowercase; no stale
    `Abstract`).
5.  Validate provider failures produce row-level status/error instead of
    silent drops.
6.  Validate progress messaging remains usable under parallel runs.
