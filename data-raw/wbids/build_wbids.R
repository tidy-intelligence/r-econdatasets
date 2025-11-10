library(tidyverse)
library(wbids)
library(arrow)

series <- ids_list_series()
write_parquet(series, "data/wbids/series.parquet")

counterparts <- ids_list_counterparts()
write_parquet(counterparts, "data/wbids/counterparts.parquet")

entities <- wbids::ids_list_entities()
write_parquet(entities, "data/wbids/entities.parquet")

files <- ids_bulk_files()

for (j in 5:nrow(files)) {
  bulk <- ids_bulk(files$file_url[j], warn_size = FALSE, timeout = 200)
  write_parquet(bulk, paste0("data-raw/wbids/wbids_bulk_", j, ".parquet"))
  message(j, " done!")
}

bulk_files <- list.files(
  "data-raw/wbids",
  full.names = TRUE,
  pattern = ".parquet"
)

debt_statistics <- bulk_files |>
  map_df(read_parquet)

write_parquet(debt_statistics, "data/wbids/debt_statistics.parquet")
