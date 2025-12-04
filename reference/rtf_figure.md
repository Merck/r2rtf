# Add Figure Attributes

Add Figure Attributes

## Usage

``` r
rtf_figure(tbl, fig_width = 5, fig_height = 5, fig_format = NULL)
```

## Arguments

- tbl:

  A data frame.

- fig_width:

  the width of figures in inch

- fig_height:

  the height of figures in inch

- fig_format:

  the figure format defined in `r2rtf:::fig_format()`

## Value

the same data frame `tbl` with additional attributes for figure body

## Specification

The contents of this section are shown in PDF user manual only.

## Examples

``` r
if (FALSE) { # \dontrun{
library(dplyr) # required to run examples
file <- file.path(tempdir(), "figure1.png")
png(file)
plot(1:10)
dev.off()

# Read in PNG file in binary format
rtf_read_figure(file) %>%
  rtf_figure() %>%
  attributes()
} # }
```
