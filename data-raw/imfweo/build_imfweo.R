library(tidyverse)
library(imfweo)
library(arrow)

publications <- weo_list_publications() |>
  arrange(desc(year))

error_log <- list()
for (j in seq_along(publications)) {
  year <- publications$year[j]
  release <- publications$release[j]

  cat("Processing", j, "-", year, release, "...\n")

  tryCatch(
    {
      weo_raw <- weo_get(
        year = year,
        release = release
      ) |>
        mutate(
          publication_year = publications$year[j],
          publication_release = publications$release[j]
        )

      write_parquet(
        weo_raw,
        paste0("data-raw/", "weo_", release, "_", year, ".parquet")
      )

      cat(year, release, "downloaded successfully!\n")
    },
    error = function(e) {
      error_log[[length(error_log) + 1]] <<- data.frame(
        j = j,
        year = year,
        release = release,
        error_message = conditionMessage(e),
        stringsAsFactors = FALSE
      )

      cat("❌ Error at", year, release, ":", conditionMessage(e), "\n")
    }
  )
}

if (length(error_log) > 0) {
  error_table <- bind_rows(error_log)
  write_csv(error_table, "data-raw/weo_error_log.csv")
} else {
  cat("✅ All downloads completed successfully!\n")
}

publications <- list.files(
  "data-raw/imfweo",
  full.names = TRUE,
  pattern = ".parquet"
)

economic_outlook <- publications |>
  map_df(read_parquet)

entities <- economic_outlook |>
  distinct(entity_id, entity_name, publication_year, publication_release)

series <- economic_outlook |>
  distinct(series_id, series_name, units, publication_year, publication_release)

write_parquet(economic_outlook, "data/imfweo/economic_outlook.parquet")
write_parquet(entities, "data/imfweo/entities.parquet")
write_parquet(series, "data/imfweo/series.parquet")
