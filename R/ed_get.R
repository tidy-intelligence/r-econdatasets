#' Get a dataset from EconDataverse Hugging Face repositories
#'
#' @description
#' Downloads and reads a Parquet file directly from the EconDataverse
#' Hugging Face datasets using the `arrow` package.
#'
#' @param dataset Character string naming the dataset repository
#'   on Hugging Face (e.g., `"wbids"` for World Bank Indicators).
#' @param table Character string naming the table.
#' @param quiet Logical; suppress messages? Default: FALSE.
#'
#' @return A `data.frame` containing the requested dataset.
#'
#' @examples
#' \dontrun{
#' df <- ed_get("wbids", "counterparts")
#' head(df)
#' }
#'
#' @export
ed_get <- function(dataset, table, quiet = FALSE) {
  base_url <- "https://huggingface.co/datasets/econdataverse"
  file_url <- paste(
    base_url,
    dataset,
    "resolve/main",
    paste0(table, ".parquet"),
    sep = "/"
  )

  if (!quiet) {
    cli::cli_inform(c(">" = paste("Reading dataset from", file_url)))
  }

  tryCatch(
    {
      df <- arrow::read_parquet(file_url)
      if (!quiet) {
        cli::cli_alert_success(paste(
          "Successfully loaded",
          table,
          "from",
          dataset
        ))
      }
      as.data.frame(df)
    },
    error = function(e) {
      cli::cli_abort(c(
        "Failed to read dataset.",
        "x" = paste("URL:", file_url),
        "!" = e$message
      ))
    }
  )
}
