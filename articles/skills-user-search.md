# Skill: User Search

## User Search Workflow

Use this skill for Search endpoint tasks aligned with
`vignettes/search-endpoint.qmd`.

### Required Workflow Order

1.  Create
    [`kagi_connection()`](https://rkrug.github.io/kagiPro/reference/kagi_connection.md).
2.  Build query objects with
    [`query_search()`](https://rkrug.github.io/kagiPro/reference/query_search.md).
3.  Prefer
    [`kagi_fetch()`](https://rkrug.github.io/kagiPro/reference/kagi_fetch.md)
    for project-folder workflows.
4.  Use
    [`kagi_request()`](https://rkrug.github.io/kagiPro/reference/kagi_request.md) +
    [`kagi_request_parquet()`](https://rkrug.github.io/kagiPro/reference/kagi_request_parquet.md)
    for low-level control.

Do not skip steps in guidance unless the user already provides a
reusable connection.

### Allowed Function Set

- [`kagi_connection()`](https://rkrug.github.io/kagiPro/reference/kagi_connection.md)
- [`query_search()`](https://rkrug.github.io/kagiPro/reference/query_search.md)
- [`open_search_query()`](https://rkrug.github.io/kagiPro/reference/open_search_query.md)
- [`kagi_fetch()`](https://rkrug.github.io/kagiPro/reference/kagi_fetch.md)
- [`kagi_request()`](https://rkrug.github.io/kagiPro/reference/kagi_request.md)
- [`kagi_request_parquet()`](https://rkrug.github.io/kagiPro/reference/kagi_request_parquet.md)

### Error Handling Rules

- Use `error_mode = "stop"` for strict/CI-like guidance.
- Use `error_mode = "write_dummy"` for long batch runs.
- Keep explanation consistent with search vignette wording.

### Output and Batching Rules

- Prefer named output directories.
- Use list-style query execution for batch workloads.
- Mention `workers` when describing parallel execution.

### References

Read and apply: - `references/workflow.md` - `references/examples.md`

### References

#### Workflow

## Search Workflow (Aligned to Vignette)

Source of truth: `vignettes/search-endpoint.qmd`.

### Sequence

1.  Build connection:
    `conn <- kagi_connection(api_key = function() keyring::key_get("API_kagi"))`
2.  Build search query with
    [`query_search()`](https://rkrug.github.io/kagiPro/reference/query_search.md).
3.  Preferred: execute end-to-end with
    `kagi_fetch(connection = conn, query = ..., project_folder = ...)`.
4.  Low-level path:
    `kagi_request(connection = conn, query = ..., output = ..., overwrite = TRUE)`.
5.  For batches, pass a list query and optional `workers`.
6.  Convert with
    [`kagi_request_parquet()`](https://rkrug.github.io/kagiPro/reference/kagi_request_parquet.md)
    if tabular analysis is needed.

### Error Strategy

- Strict mode: `error_mode = "stop"`.
- Graceful mode: `error_mode = "write_dummy"`.

### Constraints

- Keep function names exactly as exported.
- Do not describe unsupported parameters or response fields.

#### Examples

## Search Examples

``` r
q <- query_search(
  query = 'biodiversity "annual report"',
  filetype = c("pdf", "docx"),
  site = c("example.com", "gov"),
  inurl = c("2024", "report"),
  intitle = "summary",
  expand = FALSE
)

kagi_request(
  connection = conn,
  query = q[[1]],
  limit = 5,
  output = "search_single",
  overwrite = TRUE
)
```

``` r
kagi_request(
  connection = conn,
  query = q_many,
  limit = 3,
  output = "search_batch",
  overwrite = TRUE,
  workers = 2,
  error_mode = "write_dummy"
)
```

``` r
kagi_request_parquet(
  input_json = "search_batch",
  output = "search_batch_parquet",
  overwrite = TRUE
)
```
