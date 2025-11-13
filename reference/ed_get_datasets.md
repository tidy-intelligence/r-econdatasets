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
if (FALSE) { # \dontrun{
ed_get_datasets()
} # }
```
