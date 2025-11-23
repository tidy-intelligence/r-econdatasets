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
# \donttest{
df <- ed_get("wbids", "counterparts")
#> → Reading dataset from
#>   https://huggingface.co/datasets/econdataverse/wbids/resolve/main/counterparts.parquet
#> ✔ Successfully loaded counterparts from wbids
head(df)
#>   counterpart_id counterpart_name counterpart_iso2code counterpart_iso3code
#> 1            001          Austria                   AT                  AUT
#> 2            002          Belgium                   BE                  BEL
#> 3            003          Denmark                   DK                  DNK
#> 4            004           France                   FR                  FRA
#> 5            005          Germany                   DE                  DEU
#> 6            006            Italy                   IT                  ITA
#>   counterpart_type
#> 1          Country
#> 2          Country
#> 3          Country
#> 4          Country
#> 5          Country
#> 6          Country

df <- ed_get(
  "wbids",
  "counterparts",
  columns = c("counterpart_id", "counterpart_name"))
#> → Reading dataset from
#>   https://huggingface.co/datasets/econdataverse/wbids/resolve/main/counterparts.parquet
#> ✔ Successfully loaded counterparts from wbids
# }
```
