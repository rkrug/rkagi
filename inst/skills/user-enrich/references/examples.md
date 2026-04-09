# Enrich Examples

```r
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

```r
kagi_request(
  connection = conn,
  query = q_news_batch,
  output = "enrich_news_batch",
  overwrite = TRUE,
  workers = 2
)
```

```r
kagi_request(
  connection = conn,
  query = q_news_batch,
  output = "enrich_news_batch_safe",
  overwrite = TRUE,
  workers = 2,
  error_mode = "write_dummy"
)
```

