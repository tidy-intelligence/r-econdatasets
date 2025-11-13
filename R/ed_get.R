#' Get a dataset from EconDataverse Hugging Face repositories
#'
#' Downloads and reads a Parquet file directly from the EconDataverse
#' Hugging Face datasets using the `arrow` package.
#'
#' @param dataset Character string naming the dataset repository
#'   on Hugging Face (e.g., `"wbids"` for World Bank Indicators).
#' @param table Character string naming the table.
#' @param columns Character vector naming the columns. Defaults to `NULL`.
#' @param quiet Logical; suppress messages? Default: FALSE.
#'
#' @return A `data.frame` containing the requested dataset.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' df <- ed_get("wbids", "counterparts")
#' head(df)
#'
#' df <- ed_get(
#'   "wbids",
#'   "counterparts",
#'   columns = c("counterpart_id", "counterpart_name"))
#' }
ed_get <- function(dataset, table, columns = NULL, quiet = FALSE) {
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
      if (!is.null(columns)) {
        df <- arrow::read_parquet(file_url, col_select = columns)
      } else {
        df <- arrow::read_parquet(file_url)
      }

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

#' List available datasets in the EconDataverse organization
#'
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
#' @export
#'
#' @examples
#' \dontrun{
#' ed_get_datasets()
#' }
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

#' List Parquet tables for a specific EconDataverse dataset
#'
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
#' @export
#'
#' @examples
#' \dontrun{
#' ed_get_tables("wbids")
#' }
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
