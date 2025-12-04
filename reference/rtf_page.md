# Add RTF File Page Information

Add RTF File Page Information

## Usage

``` r
rtf_page(
  tbl,
  orientation = "portrait",
  width = ifelse(orientation == "portrait", 8.5, 11),
  height = ifelse(orientation == "portrait", 11, 8.5),
  margin = set_margin("wma", orientation),
  nrow = ifelse(orientation == "portrait", 40, 24),
  border_first = "double",
  border_last = "double",
  border_color_first = NULL,
  border_color_last = NULL,
  col_width = width - ifelse(orientation == "portrait", 2.25, 2.5),
  use_color = FALSE,
  use_i18n = FALSE
)
```

## Arguments

- tbl:

  A data frame.

- orientation:

  Orientation in 'portrait' or 'landscape'.

- width:

  A numeric value of page width in inches.

- height:

  A numeric value of page width in inches.

- margin:

  A numeric vector of length 6 for page margin. The value set left,
  right, top, bottom, header and footer margin in order. Default value
  depends on the page orientation and set by
  `r2rtf:::set_margin("wma", orientation)`

- nrow:

  Number of rows in each page.

- border_first:

  First top border type of the whole table. All possible input can be
  found in `r2rtf:::border_type()$name`.

- border_last:

  Last bottom border type of the whole table. All possible input can be
  found in `r2rtf:::border_type()$name`.

- border_color_first:

  First top border color type of the whole table. Default is NULL for
  black. All possible input can be found in
  [`grDevices::colors()`](https://rdrr.io/r/grDevices/colors.html).

- border_color_last:

  Last bottom border color type of the whole table. Default is NULL for
  black. All possible input can be found in
  [`grDevices::colors()`](https://rdrr.io/r/grDevices/colors.html).

- col_width:

  A numeric value of total column width in inch. Default is
  `width - ifelse(orientation == "portrait", 2, 2.5)`

- use_color:

  A logical value to use color in the output.

- use_i18n:

  A logical value to enable internationalization fonts (e.g., SimSun for
  Chinese). Default is FALSE.

## Value

the same data frame `tbl` with additional attributes for page features

## Specification

The contents of this section are shown in PDF user manual only.

## Examples

``` r
library(dplyr) # required to run examples
data(r2rtf_tbl1)
r2rtf_tbl1 %>%
  rtf_page() %>%
  attr("page")
#> $width
#> [1] 8.5
#> 
#> $height
#> [1] 11
#> 
#> $orientation
#> [1] "portrait"
#> 
#> $margin
#> [1] 1.25000 1.00000 1.75000 1.25000 1.75000 1.00625
#> 
#> $nrow
#> [1] 40
#> 
#> $col_width
#> [1] 6.25
#> 
#> $border_first
#> [1] "double"
#> 
#> $border_last
#> [1] "double"
#> 
#> $page_title
#> [1] "all"
#> 
#> $page_footnote
#> [1] "last"
#> 
#> $page_source
#> [1] "last"
#> 
#> $use_color
#> [1] FALSE
#> 
#> $use_i18n
#> [1] FALSE
#> 
```
