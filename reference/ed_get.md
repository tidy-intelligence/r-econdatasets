# Get a dataset from EconDataverse Hugging Face repositories

Downloads and reads a Parquet file directly from the EconDataverse
Hugging Face datasets using the `arrow` package.

## Usage

``` r
ed_get(dataset, table, quiet = FALSE)
```

## Arguments

- dataset:

  Character string naming the dataset repository on Hugging Face (e.g.,
  `"wbids"` for World Bank Indicators).

- table:

  Character string naming the table.

- quiet:

  Logical; suppress messages? Default: FALSE.

## Value

A `data.frame` containing the requested dataset.

## Examples

``` r
if (FALSE) { # \dontrun{
df <- ed_get("wbids", "counterparts")
head(df)
} # }
```
