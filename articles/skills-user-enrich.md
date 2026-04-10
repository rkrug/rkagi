# Skill: User Enrich

## User Enrich Workflow

Use this skill for Enrich tasks aligned with
`vignettes/enrich-endpoint.qmd`.

### Required Workflow Order

1.  Create
    [`kagi_connection()`](https://rkrug.github.io/kagiPro/reference/kagi_connection.md).
2.  Build query objects with
    [`query_enrich_web()`](https://rkrug.github.io/kagiPro/reference/query_enrich_web.md)
    or
    [`query_enrich_news()`](https://rkrug.github.io/kagiPro/reference/query_enrich_news.md).
3.  Prefer
    [`kagi_fetch()`](https://rkrug.github.io/kagiPro/reference/kagi_fetch.md)
    for project-folder workflows.
4.  Use
    [`kagi_request()`](https://rkrug.github.io/kagiPro/reference/kagi_request.md) +
    [`kagi_request_parquet()`](https://rkrug.github.io/kagiPro/reference/kagi_request_parquet.md)
    for low-level control.

### Allowed Function Set

- [`kagi_connection()`](https://rkrug.github.io/kagiPro/reference/kagi_connection.md)
- [`query_enrich_web()`](https://rkrug.github.io/kagiPro/reference/query_enrich_web.md)
- [`query_enrich_news()`](https://rkrug.github.io/kagiPro/reference/query_enrich_news.md)
- [`kagi_fetch()`](https://rkrug.github.io/kagiPro/reference/kagi_fetch.md)
- [`kagi_request()`](https://rkrug.github.io/kagiPro/reference/kagi_request.md)
- [`kagi_request_parquet()`](https://rkrug.github.io/kagiPro/reference/kagi_request_parquet.md)

### Error Handling Rules

- Use strict behavior by default.
- Recommend `error_mode = "write_dummy"` for recurring batch collection
  jobs.
- Keep dummy-output explanations consistent with current package
  behavior.

### Enrich-Specific Rules

- Keep web and news workflows separated when presenting output layout.
- Use batch enrich examples for thematic monitoring.

### References

Read and apply: - `references/workflow.md` - `references/examples.md`

### References

#### Workflow

## Enrich Workflow (Aligned to Vignette)

Source of truth: `vignettes/enrich-endpoint.qmd`.

### Sequence

1.  Build connection.
2.  Build web queries with
    [`query_enrich_web()`](https://rkrug.github.io/kagiPro/reference/query_enrich_web.md)
    and/or news queries with
    [`query_enrich_news()`](https://rkrug.github.io/kagiPro/reference/query_enrich_news.md).
3.  Preferred: execute end-to-end with
    `kagi_fetch(project_folder = ...)`.
4.  Low-level path: execute with
    [`kagi_request()`](https://rkrug.github.io/kagiPro/reference/kagi_request.md).
5.  For recurring monitoring, run batch query lists.
6.  Convert with
    [`kagi_request_parquet()`](https://rkrug.github.io/kagiPro/reference/kagi_request_parquet.md).

### Error Strategy

- Default strict behavior for small controlled runs.
- `error_mode = "write_dummy"` for long batch collection.

### Constraints

- Keep web/news outputs separated in examples.
- Keep language consistent with endpoint guide.

#### Examples

## Enrich Examples

``` r
q_web <- query_enrich_web(
  query = "open data portals",
  site = "gov",
  expand = FALSE
)

q_news <- query_enrich_news(
  query = "biodiversity policy",
  expand = FALSE
)
```

``` r
kagi_request(
  connection = conn,
  query = q_news_batch,
  output = "enrich_news_batch",
  overwrite = TRUE,
  workers = 2
)
```

``` r
kagi_request(
  connection = conn,
  query = q_news_batch,
  output = "enrich_news_batch_safe",
  overwrite = TRUE,
  workers = 2,
  error_mode = "write_dummy"
)
```
