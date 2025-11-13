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
if (FALSE) { # \dontrun{
ed_get_tables("wbids")
} # }
```
