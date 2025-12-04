# Add Column Header Attributes to Table

Add Column Header Attributes to Table

## Usage

``` r
rtf_colheader(
  tbl,
  colheader = NULL,
  col_rel_width = NULL,
  border_left = "single",
  border_right = "single",
  border_top = "single",
  border_bottom = "",
  border_color_left = NULL,
  border_color_right = NULL,
  border_color_top = NULL,
  border_color_bottom = NULL,
  border_width = 15,
  cell_height = 0.15,
  cell_justification = "c",
  cell_vertical_justification = "bottom",
  cell_nrow = NULL,
  text_font = 1,
  text_format = NULL,
  text_font_size = 9,
  text_color = NULL,
  text_background_color = NULL,
  text_justification = "c",
  text_indent_first = 0,
  text_indent_left = 0,
  text_indent_right = 0,
  text_space = 1,
  text_space_before = 15,
  text_space_after = 15,
  text_hyphenation = TRUE,
  text_convert = TRUE
)
```

## Arguments

- tbl:

  A data frame.

- colheader:

  A character string that uses " \| " to separate column names. Default
  is NULL for a blank column header.

- col_rel_width:

  A Column relative width in a vector e.g. c(2,1,1) refers to 2:1:1.
  Default is NULL for equal column width.

- border_left:

  Left border type. To vary left border by column, use character vector
  with length of vector equal to number of columns displayed e.g.
  c("single","single","single"). All possible input can be found in
  `r2rtf:::border_type()$name`.

- border_right:

  Right border type. To vary right border by column, use character
  vector with length of vector equal to number of columns displayed e.g.
  c("single","single","single"). All possible input can be found in
  `r2rtf:::border_type()$name`.

- border_top:

  Top border type. To vary top border by column, use character vector
  with length of vector equal to number of columns displayed e.g.
  c("single","single","single"). If it is the first row in a table for
  this page, the top border is set to "double" otherwise the border is
  set to "single". All possible input can be found in
  `r2rtf:::border_type()$name`.

- border_bottom:

  Bottom border type. To vary bottom border by column, use character
  vector with length of vector equal to number of columns displayed e.g.
  c("single","single","single"). All possible input can be found in
  `r2rtf:::border_type()$name`.

- border_color_left:

  Left border color type. Default is NULL for black. To vary left border
  color by column, use character vector with length of vector equal to
  number of columns displayed e.g. c("white","red","blue"). All possible
  input can be found in
  [`grDevices::colors()`](https://rdrr.io/r/grDevices/colors.html).

- border_color_right:

  Right border color type. Default is NULL for black. To vary right
  border color by column, use character vector with length of vector
  equal to number of columns displayed e.g. c("white","red","blue"). All
  possible input can be found in
  [`grDevices::colors()`](https://rdrr.io/r/grDevices/colors.html).

- border_color_top:

  Top border color type. Default is NULL for black. To vary top border
  color by column, use character vector with length of vector equal to
  number of columns displayed e.g. c("white","red","blue"). All possible
  input can be found in
  [`grDevices::colors()`](https://rdrr.io/r/grDevices/colors.html).

- border_color_bottom:

  Bottom border color type. Default is NULL for black. To vary bottom
  border color by column, use character vector with length of vector
  equal to number of columns displayed e.g. c("white","red","blue"). All
  possible input can be found in
  [`grDevices::colors()`](https://rdrr.io/r/grDevices/colors.html).

- border_width:

  Border width in twips. Default is 15 for 0.0104 inch.

- cell_height:

  Cell height in inches. Default is 0.15 for 0.15 inch.

- cell_justification:

  Justification type for cell. All possible input can be found in
  `r2rtf:::justification()$type`.

- cell_vertical_justification:

  Vertical justification type for cell. All possible input can be found
  in `r2rtf:::vertical_justification()$type`.

- cell_nrow:

  Number of rows required in each cell.

- text_font:

  Text font type. Default is 1 for Times New Roman. To vary text font
  type by column, use numeric vector with length of vector equal to
  number of columns displayed e.g. c(1,2,3).All possible input can be
  found in `r2rtf:::font_type()$type`.

- text_format:

  Text format type. Default is NULL for normal. Combination of format
  type are permitted as input for e.g. "ub" for bold and underlined
  text. To vary text format by column, use character vector with length
  of vector equal to number of columns displayed e.g. c("i","u","ib").
  All possible input can be found in `r2rtf:::font_format()$type`.

- text_font_size:

  Text font size. To vary text font size by column, use numeric vector
  with length of vector equal to number of columns displayed e.g.
  c(9,20,40).

- text_color:

  Text color type. Default is NULL for black. To vary text color by
  column, use character vector with length of vector equal to number of
  columns displayed e.g. c("white","red","blue"). All possible input can
  be found in
  [`grDevices::colors()`](https://rdrr.io/r/grDevices/colors.html).

- text_background_color:

  Text background color type. Default is NULL for white. To vary text
  color by column, use character vector with length of vector equal to
  number of columns displayed e.g. c("white","red","blue"). All possible
  input can be found in
  [`grDevices::colors()`](https://rdrr.io/r/grDevices/colors.html).

- text_justification:

  Justification type for text. Default is "c" for center justification.
  To vary text justification by column, use character vector with length
  of vector equal to number of columns displayed e.g. c("c","l","r").
  All possible input can be found in `r2rtf:::justification()$type`.

- text_indent_first:

  A value of text indent in first line. The unit is twip.

- text_indent_left:

  A value of text left indent. The unit is twip.

- text_indent_right:

  A value of text right indent. The unit is twip.

- text_space:

  Line space between paragraph in twips. Default is 0.

- text_space_before:

  Line space before a paragraph in twips.

- text_space_after:

  Line space after a paragraph in twips.

- text_hyphenation:

  A logical value to control whether display text linked with
  hyphenation.

- text_convert:

  A logical value to convert special characters.

## Value

The same data frame `tbl` with additional attributes for table column
header.

## Specification

The contents of this section are shown in PDF user manual only.

## Examples

``` r
library(dplyr) # required to run examples
data(r2rtf_tbl1)
r2rtf_tbl1 %>%
  rtf_colheader(
    colheader = "Treatment | N | Mean (SD) | N | Mean (SD) | N |
                  Mean (SD) | LS Mean (95% CI)\\dagger",
    text_format = c("b", "", "u", "", "u", "", "u", "i")
  ) %>%
  attr("rtf_colheader")
#> [[1]]
#>          X1 X2        X3 X4        X5 X6        X7                       X8
#> 1 Treatment  N Mean (SD)  N Mean (SD)  N Mean (SD) LS Mean (95% CI)\\dagger
#> 
```
