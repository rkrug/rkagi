# Skill: User Summarize

## User Summarize Workflow

Use this skill for Summarize tasks aligned with
`vignettes/summarize-endpoint.qmd`.

### Required Workflow Order

1.  Create
    [`kagi_connection()`](https://rkrug.github.io/kagiPro/reference/kagi_connection.md).
2.  Build summarize queries with
    [`query_summarize()`](https://rkrug.github.io/kagiPro/reference/query_summarize.md).
3.  Prefer
    [`kagi_fetch()`](https://rkrug.github.io/kagiPro/reference/kagi_fetch.md)
    for project-folder workflows.
4.  Use
    [`kagi_request()`](https://rkrug.github.io/kagiPro/reference/kagi_request.md) +
    [`kagi_request_parquet()`](https://rkrug.github.io/kagiPro/reference/kagi_request_parquet.md)
    for low-level control.

### Allowed Function Set

- [`kagi_connection()`](https://rkrug.github.io/kagiPro/reference/kagi_connection.md)
- [`query_summarize()`](https://rkrug.github.io/kagiPro/reference/query_summarize.md)
- [`kagi_fetch()`](https://rkrug.github.io/kagiPro/reference/kagi_fetch.md)
- [`kagi_request()`](https://rkrug.github.io/kagiPro/reference/kagi_request.md)
- [`kagi_request_parquet()`](https://rkrug.github.io/kagiPro/reference/kagi_request_parquet.md)

### Summarize-Specific Rules

- Support both URL and text input modes.
- Explicitly mention short-input failure risk.
- For robust pipelines, recommend `error_mode = "write_dummy"`.
- Keep mixed success/error batch guidance aligned with existing vignette
  behavior.

### References

Read and apply: - `references/workflow.md` - `references/examples.md`

### References

#### Workflow

## Summarize Workflow (Aligned to Vignette)

Source of truth: `vignettes/summarize-endpoint.qmd`.

### Sequence

1.  Build connection.
2.  Build query objects with
    [`query_summarize()`](https://rkrug.github.io/kagiPro/reference/query_summarize.md)
    (URL mode or text mode).
3.  Preferred: execute end-to-end with
    `kagi_fetch(project_folder = ...)`.
4.  Low-level path: execute with
    [`kagi_request()`](https://rkrug.github.io/kagiPro/reference/kagi_request.md).
5.  For mixed batches, pass explicit query lists.
6.  Convert with
    [`kagi_request_parquet()`](https://rkrug.github.io/kagiPro/reference/kagi_request_parquet.md)
    if needed.

### Error Strategy

- Be explicit about short-input failure risk.
- Use `error_mode = "write_dummy"` for robust pipelines.

### Constraints

- Keep guidance aligned with documented summarize behavior.
- Do not imply unsupported summarize options.

#### Examples

## Summarize Examples

``` r
q_text <- query_summarize(
  text = paste(
    "Biodiversity underpins ecosystem services.",
    "Habitat loss and climate pressure accelerate species decline."
  ),
  engine = "cecil",
  summary_type = "takeaway",
  target_language = "EN",
  cache = TRUE
)
```

``` r
kagi_request(
  connection = conn,
  query = q_text[[1]],
  output = "summarize_output",
  overwrite = TRUE
)
```

``` r
kagi_request(
  connection = conn,
  query = list(ok = q_ok[[1]], err = q_err[[1]]),
  output = "summarize_mixed",
  overwrite = TRUE,
  workers = 1,
  error_mode = "write_dummy"
)
```
