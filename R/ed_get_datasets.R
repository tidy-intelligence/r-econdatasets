#' List available datasets in the EconDataverse organization
#'
#' @description
#' Retrieves a list of all datasets published under the
#' [EconDataverse](https://huggingface.co/econdataverse) organization
#' on Hugging Face.
#'
#' @param quiet Logical; whether to suppress informational messages.
#'   Defaults to FALSE.
#'
#' @return A data frame with columns:
#' \describe{
#'   \item{dataset}{Dataset identifier on Hugging Face}
#'   \item{total_downloads}{Approximate download count}
#'   \item{last_modified}{Last update timestamp (UTC)}
#'   \item{is_private}{Logical; whether the dataset is private}
#'   \item{is_gated}{Logical; whether access is gated}
#' }
#'
#' @examples
#' \dontrun{
#' ed_list_datasets()
#' }
#'
#' @export
ed_get_datasets <- function(quiet = FALSE) {
  url <- "https://huggingface.co/api/datasets?author=econdataverse"

  if (!quiet) {
    cli::cli_inform(c(">" = paste("Fetching dataset list from", url)))
  }

  resp <- tryCatch(
    httr2::request(url) |>
      httr2::req_perform(),
    error = function(e) {
      cli::cli_abort(paste("Failed to retrieve dataset list:", e$message))
    }
  )

  data <- httr2::resp_body_string(resp)
  parsed <- jsonlite::fromJSON(data)

  # Use 'id' instead of '_id' to get the proper dataset name
  df <- data.frame(
    dataset = parsed$id,
    total_downloads = parsed$downloads,
    last_modified = parsed$lastModified,
    is_private = parsed$private,
    is_gated = parsed$gated,
    stringsAsFactors = FALSE
  )

  if (!quiet) {
    cli::cli_alert_success(paste("Found", nrow(df), "datasets."))
  }

  df
}
