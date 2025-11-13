# Get a dataset from EconDataverse Hugging Face repositories

Downloads and reads a Parquet file directly from the EconDataverse
Hugging Face datasets using the `arrow` package.

## Usage

``` r
ed_get(dataset, table, columns = NULL, quiet = FALSE)
```

## Arguments

- dataset:

  Character string naming the dataset repository on Hugging Face (e.g.,
  `"wbids"` for World Bank Indicators).

- table:

  Character string naming the table.

- columns:

  Character vector naming the columns. Defaults to `NULL`.

- quiet:

  Logical; suppress messages? Default: FALSE.

## Value

A `data.frame` containing the requested dataset, or `NULL` if the
download fails.

## Examples

``` r
if (FALSE) { # \dontrun{
df <- ed_get("wbids", "counterparts")
head(df)

df <- ed_get(
  "wbids",
  "counterparts",
  columns = c("counterpart_id", "counterpart_name"))
} # }
```
