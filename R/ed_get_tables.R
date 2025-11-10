#' List Parquet tables for a specific EconDataverse dataset
#'
#' @description
#' Queries the Hugging Face Hub and returns all `.parquet` files
#' under a given dataset repository in the
#' [EconDataverse](https://huggingface.co/econdataverse) organization,
#' including file sizes.
#'
#' @param dataset Character; the dataset repository name (e.g., "wbids").
#' @param quiet Logical; suppress messages? Default: FALSE.
#'
#' @return A data.frame with:
#' \describe{
#'   \item{table}{Basename without the `.parquet` extension}
#'   \item{filename}{Filename with extension}
#'   \item{path}{Path within the repo}
#'   \item{size}{File size}
#'   \item{url}{Direct `resolve/main` URL to the Parquet file}
#' }
#'
#' @examples
#' \dontrun{
#' ed_get_tables("wbids")
#' }
#'
#' @export
ed_get_tables <- function(dataset, quiet = FALSE) {
  api_url <- paste(
    "https://huggingface.co/api/datasets/econdataverse",
    dataset,
    "tree/main?recursive=1",
    sep = "/"
  )

  if (!quiet) {
    cli::cli_inform(c(">" = paste("Fetching file tree from", api_url)))
  }

  resp <- tryCatch(
    httr2::request(api_url) |> httr2::req_perform(),
    error = function(e) {
      cli::cli_abort(paste("Failed to retrieve file tree:", e$message))
    }
  )

  items <- jsonlite::fromJSON(
    httr2::resp_body_string(resp),
    simplifyDataFrame = TRUE
  )

  tree <- if (is.data.frame(items)) {
    items
  } else if (is.list(items) && is.data.frame(items$tree)) {
    items$tree
  } else {
    cli::cli_abort(
      "Unexpected API response structure; could not find file list."
    )
  }

  parquet <- tree[
    tree$type == "file" &
      grepl("\\.parquet$", tree$path, ignore.case = TRUE),
    c("path", "size")
  ]

  if (nrow(parquet) == 0) {
    if (!quiet) {
      cli::cli_alert_info("No Parquet files found in this dataset.")
    }
    return(
      data.frame(
        table = character(),
        filename = character(),
        path = character(),
        size = character(),
        url = character(),
        stringsAsFactors = FALSE
      )
    )
  }

  filename <- basename(parquet$path)
  table <- sub("\\.parquet$", "", filename, ignore.case = TRUE)
  url <- paste(
    "https://huggingface.co/datasets/econdataverse",
    dataset,
    "resolve/main",
    parquet$path,
    sep = "/"
  )

  out <- data.frame(
    table = table,
    filename = filename,
    path = parquet$path,
    size = parquet$size,
    url = url,
    stringsAsFactors = FALSE
  )

  if (!quiet) {
    cli::cli_alert_success(paste("Found", nrow(out), "Parquet table(s)."))
  }

  out
}
