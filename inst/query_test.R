query <- list(
  enrich_news = enrich_news_query("biodiversity"),
  enrich_web = enrich_web_query("biodiversity"),
  search = search_query("biodiversity"),
  summarize = summarize_query(
    url = "https://www.nber.org/system/files/working_papers/w31022/w31022.pdf",
    target_language = c("EN"),
    engine = "muriel"
  )
)

conn <- kagi_connection(api_key = keyring::key_get("API_kagi"))

kagi_request(
  connection = conn,
  query = query,
  output = "combinet_test"
)

kagi_request_parquet(
  input_json = "combinet_test",
  output = "combinet_testt"
)
