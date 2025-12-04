# Assemble Multiple RTF Table Listing and Figure Into One Word Document

The function assemble multiple RTF table, listing, and figures into one
document as Microsoft Word (i.e., `docx`).

## Usage

``` r
assemble_docx(input, output, landscape = FALSE)
```

## Arguments

- input:

  Character vector of file path.

- output:

  Character string to the output file path.

- landscape:

  Logical vector to determine page direction.

## Specification

The contents of this section are shown in PDF user manual only.

## Examples

``` r
library(officer)
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
output <- tempfile(fileext = ".docx")

assemble_docx(
  input = file,
  output = output
)
```
