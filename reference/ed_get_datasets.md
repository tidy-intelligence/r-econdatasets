# List available datasets in the EconDataverse organization

Retrieves a list of all datasets published under the
[EconDataverse](https://huggingface.co/econdataverse) organization on
Hugging Face.

## Usage

``` r
ed_get_datasets(quiet = FALSE)
```

## Arguments

- quiet:

  Logical; whether to suppress informational messages. Defaults to
  FALSE.

## Value

A data frame with columns:

- dataset:

  Dataset identifier on Hugging Face

- total_downloads:

  Approximate download count

- last_modified:

  Last update timestamp (UTC)

- is_private:

  Logical; whether the dataset is private

- is_gated:

  Logical; whether access is gated

Returns `NULL` if the request fails.

## Examples

``` r
# \donttest{
ed_get_datasets()
#> → Fetching dataset list from
#>   https://huggingface.co/api/datasets?author=econdataverse
#> ✔ Found 3 datasets.
#>                dataset total_downloads            last_modified is_private
#> 1  econdataverse/wbids             116 2025-10-28T14:57:47.000Z      FALSE
#> 2 econdataverse/imfweo              33 2025-11-10T06:05:06.000Z      FALSE
#> 3  econdataverse/wbwdi               2 2025-12-01T09:06:11.000Z      FALSE
#>   is_gated
#> 1    FALSE
#> 2    FALSE
#> 3    FALSE
# }
```
