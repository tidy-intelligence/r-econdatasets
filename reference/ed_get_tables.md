# List Parquet tables for a specific EconDataverse dataset

Queries the Hugging Face Hub and returns all `.parquet` files under a
given dataset repository in the
[EconDataverse](https://huggingface.co/econdataverse) organization,
including file sizes.

## Usage

``` r
ed_get_tables(dataset, quiet = FALSE)
```

## Arguments

- dataset:

  Character; the dataset repository name (e.g., "wbids").

- quiet:

  Logical; suppress messages? Default: FALSE.

## Value

A data.frame with:

- table:

  Basename without the `.parquet` extension

- filename:

  Filename with extension

- path:

  Path within the repo

- size:

  File size

- url:

  Direct `resolve/main` URL to the Parquet file

Returns `NULL` if the request fails.

## Examples

``` r
# \donttest{
ed_get_tables("wbids")
#> → Fetching file tree from
#>   https://huggingface.co/api/datasets/econdataverse/wbids/tree/main?recursive=1
#> ✔ Found 5 Parquet table(s).
#>             table                filename                    path      size
#> 1    counterparts    counterparts.parquet    counterparts.parquet     10435
#> 2 debt_statistics debt_statistics.parquet debt_statistics.parquet 106495139
#> 3        entities        entities.parquet        entities.parquet     11293
#> 4          series          series.parquet          series.parquet     55854
#> 5   series_topics   series_topics.parquet   series_topics.parquet      4746
#>                                                                                        url
#> 1    https://huggingface.co/datasets/econdataverse/wbids/resolve/main/counterparts.parquet
#> 2 https://huggingface.co/datasets/econdataverse/wbids/resolve/main/debt_statistics.parquet
#> 3        https://huggingface.co/datasets/econdataverse/wbids/resolve/main/entities.parquet
#> 4          https://huggingface.co/datasets/econdataverse/wbids/resolve/main/series.parquet
#> 5   https://huggingface.co/datasets/econdataverse/wbids/resolve/main/series_topics.parquet
# }
```
