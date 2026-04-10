# Skill: User Fastgpt

## User FastGPT Workflow

Use this skill for FastGPT tasks aligned with
`vignettes/fastgpt-endpoint.qmd`.

### Required Workflow Order

1.  Create
    [`kagi_connection()`](https://rkrug.github.io/kagiPro/reference/kagi_connection.md).
2.  Build query objects with
    [`query_fastgpt()`](https://rkrug.github.io/kagiPro/reference/query_fastgpt.md).
3.  Prefer
    [`kagi_fetch()`](https://rkrug.github.io/kagiPro/reference/kagi_fetch.md)
    for project-folder workflows.
4.  Use
    [`kagi_request()`](https://rkrug.github.io/kagiPro/reference/kagi_request.md) +
    [`kagi_request_parquet()`](https://rkrug.github.io/kagiPro/reference/kagi_request_parquet.md)
    for low-level control.

### Allowed Function Set

- [`kagi_connection()`](https://rkrug.github.io/kagiPro/reference/kagi_connection.md)
- [`query_fastgpt()`](https://rkrug.github.io/kagiPro/reference/query_fastgpt.md)
- [`kagi_fetch()`](https://rkrug.github.io/kagiPro/reference/kagi_fetch.md)
- [`kagi_request()`](https://rkrug.github.io/kagiPro/reference/kagi_request.md)
- [`kagi_request_parquet()`](https://rkrug.github.io/kagiPro/reference/kagi_request_parquet.md)

### FastGPT-Specific Rules

- Keep prompts concise and task-specific.
- Use list query sets for repeatable prompt batches.
- Recommend `error_mode = "write_dummy"` for unattended runs.

### References

Read and apply: - `references/workflow.md` - `references/examples.md`

### References

#### Workflow

## FastGPT Workflow (Aligned to Vignette)

Source of truth: `vignettes/fastgpt-endpoint.qmd`.

### Sequence

1.  Build connection.
2.  Build query sets with
    [`query_fastgpt()`](https://rkrug.github.io/kagiPro/reference/query_fastgpt.md).
3.  Preferred: execute end-to-end with
    `kagi_fetch(project_folder = ...)`.
4.  Low-level path: execute with
    [`kagi_request()`](https://rkrug.github.io/kagiPro/reference/kagi_request.md).
5.  Use list queries for batch prompt runs.
6.  Convert with
    [`kagi_request_parquet()`](https://rkrug.github.io/kagiPro/reference/kagi_request_parquet.md)
    when needed.

### Error Strategy

- Use strict defaults for controlled runs.
- Use `error_mode = "write_dummy"` for unattended batches.

### Constraints

- Keep prompts concise in examples.
- Keep behavior statements aligned with current docs/tests.

#### Examples

## FastGPT Examples

``` r
q_fast <- query_fastgpt(
  query = "What is Python 3.11?",
  cache = TRUE,
  web_search = TRUE
)
```

``` r
kagi_request(
  connection = conn,
  query = q_fast[[1]],
  output = "fastgpt_output",
  overwrite = TRUE
)
```

``` r
kagi_request(
  connection = conn,
  query = q_fast_many,
  output = "fastgpt_batch_safe",
  overwrite = TRUE,
  workers = 2,
  error_mode = "write_dummy"
)
```
