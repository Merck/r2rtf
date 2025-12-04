# Assemble Multiple RTF Table Listing and Figure Into One RTF Document

The function assemble multiple RTF table, listing, and figures into one
document as RTF file.

## Usage

``` r
assemble_rtf(input, output, landscape = FALSE)
```

## Arguments

- input:

  Character vector of file path.

- output:

  Character string to the output file path.

- landscape:

  Logical value to determine page direction.

## Specification

The contents of this section are shown in PDF user manual only.

## Examples

``` r
library(magrittr)

file <- replicate(2, tempfile(fileext = ".rtf"))
file1 <- head(iris) %>%
  rtf_body() %>%
  rtf_encode() %>%
  write_rtf(file[1])
file2 <- head(cars) %>%
  rtf_page(orientation = "landscape") %>%
  rtf_body() %>%
  rtf_encode() %>%
  write_rtf(file[2])
output <- tempfile(fileext = ".rtf")

assemble_rtf(
  input = file,
  output = output
)
```
