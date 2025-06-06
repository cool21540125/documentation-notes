# Labels from scrapes are a mix of Scraped Labels and Target Labels  -- metric_relabel_configs

------------------------------------------------------------------------------------------------

```mermaid
flowchart TB

target(("Target to Scrape"))

url["Generate URL\n Scheme: __scheme__\n Host: __address__\n Path: __metrics_path__\n Params: __param_* + config"]
target --> url

scrape["Scrape Target"]
url --> scrape

exist{"Does label from scrape exist in target labels?"}
honor{"What is honor_labels set to?"}
prefix["Prefix label from scrape with 'exported_', and add to timeseries"]
addts["Add label from scrape to timeseries"]
already["Add all target labels not already present and not beginning with '__'"]

subgraph scrapedts["For each scraped timeseries"]
  subgraph labelts["For each label scraped for that timeseries"]
    exist -- Yes --> honor
    exist -- No --> addts
    honor -- false --> prefix
    honor -- true --> addts

  end

  scrape --> exist

  addts --> already
  prefix --> already

  relabel["metric_relabel_configs"]
  already --> relabel

  drop(("Drop timeseries"))
  relabel -- "Drop/Keep action" --> drop
end

duration["Add up and scrape_duration_seconds with target labels"]
relabel --> duration

done(("Scrape Done"))
duration --> done
```

------------------------------------------------------------------------------------------------
