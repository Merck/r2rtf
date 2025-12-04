# Render to RTF Encoding

This function extracts table/figure attributes and render to RTF
encoding that is ready to save to an RTF file.

## Usage

``` r
rtf_encode(
  tbl,
  doc_type = "table",
  page_title = "all",
  page_footnote = "last",
  page_source = "last",
  verbose = FALSE
)
```

## Arguments

- tbl:

  A data frame for table or a list of binary string for figure.

- doc_type:

  The doc_type of input, default is table.

- page_title:

  A character of title displaying location. Possible values are "first",
  "last" and "all".

- page_footnote:

  A character of title displaying location. Possible values are "first",
  "last" and "all".

- page_source:

  A character of title displaying location. Possible values are "first",
  "last" and "all".

- verbose:

  a boolean value to return more details of RTF encoding.

## Value

    For \code{rtf_encode}, a vector of RTF code.
    For \code{write_rtf}, no return value.

## Specification

The contents of this section are shown in PDF user manual only.

## Examples

``` r
library(dplyr) # required to run examples

# Example 1
head(iris) %>%
  rtf_body() %>%
  rtf_encode() %>%
  write_rtf(file = file.path(tempdir(), "table1.rtf"))

# Example 2
if (FALSE) { # \dontrun{
library(dplyr) # required to run examples
file <- file.path(tempdir(), "figure1.png")
png(file)
plot(1:10)
dev.off()

# Read in PNG file in binary format
rtf_read_figure(file) %>%
  rtf_figure() %>%
  rtf_encode(doc_type = "figure") %>%
  write_rtf(file = file.path(tempdir(), "figure1.rtf"))
} # }
# Example 3

## convert tbl_1 to the table body. Add title, subtitle, two table
## headers, and footnotes to the table body.
data(r2rtf_tbl2)
## convert r2rtf_tbl2 to the table body. Add a table column header to table body.
t2 <- r2rtf_tbl2 %>%
  rtf_colheader(
    colheader = "Pairwise Comparison |
                   Difference in LS Mean(95% CI)\\dagger | p-Value",
    text_justification = c("l", "c", "c")
  ) %>%
  rtf_body(
    col_rel_width = c(8, 7, 5),
    text_justification = c("l", "c", "c"),
    last_row = FALSE
  )
# concatenate a list of table and save to an RTF file
t2 %>%
  rtf_encode() %>%
  write_rtf(file.path(tempdir(), "table2.rtf"))
```
