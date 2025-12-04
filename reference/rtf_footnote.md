# Add Footnote Attributes to Table

Add Footnote Attributes to Table

## Usage

``` r
rtf_footnote(
  tbl,
  footnote = "",
  border_left = "single",
  border_right = "single",
  border_top = "",
  border_bottom = "single",
  border_color_left = NULL,
  border_color_right = NULL,
  border_color_top = NULL,
  border_color_bottom = NULL,
  border_width = 15,
  cell_height = 0.15,
  cell_justification = "c",
  cell_vertical_justification = "top",
  cell_nrow = NULL,
  text_font = 1,
  text_format = NULL,
  text_font_size = 9,
  text_color = NULL,
  text_background_color = NULL,
  text_justification = "l",
  text_indent_first = 0,
  text_indent_left = 0,
  text_indent_right = 0,
  text_indent_reference = "table",
  text_space = 1,
  text_space_before = 15,
  text_space_after = 15,
  text_convert = TRUE,
  as_table = TRUE
)
```

## Arguments

- tbl:

  A data frame.

- footnote:

  A vector of character for footnote text.

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

- text_indent_reference:

  The reference start point of text indent. Accept `table` or
  `page_margin`

- text_space:

  Line space between paragraph in twips. Default is 0.

- text_space_before:

  Line space before a paragraph in twips.

- text_space_after:

  Line space after a paragraph in twips.

- text_convert:

  A logical value to convert special characters.

- as_table:

  A logical value to display it as a table.

## Value

the same data frame `tbl` with additional attributes for table footnote

## Specification

The contents of this section are shown in PDF user manual only.

## Examples

``` r
library(dplyr) # required to run examples
data(r2rtf_tbl1)
r2rtf_tbl1 %>%
  rtf_footnote("\\dagger Based on an ANCOVA model.") %>%
  attr("rtf_footnote")
#> [1] "\\dagger Based on an ANCOVA model."
#> attr(,"text_font")
#> [1] 1
#> attr(,"text_font_size")
#> [1] 9
#> attr(,"text_justification")
#> [1] "l"
#> attr(,"text_space")
#> [1] 1
#> attr(,"text_space_before")
#> [1] 15
#> attr(,"text_space_after")
#> [1] 15
#> attr(,"text_indent_first")
#> [1] 0
#> attr(,"text_indent_left")
#> [1] 0
#> attr(,"text_indent_right")
#> [1] 0
#> attr(,"text_new_page")
#> [1] FALSE
#> attr(,"text_hyphenation")
#> [1] TRUE
#> attr(,"text_convert")
#> [1] TRUE
#> attr(,"use_i18n")
#> [1] FALSE
#> attr(,"strwidth")
#> [1] 1.928602
#> attr(,"use_color")
#> [1] FALSE
#> attr(,"class")
#> [1] "character"  "rtf_text"   "rtf_border"
#> attr(,"border_top")
#> [1] ""
#> attr(,"border_left")
#> [1] "single"
#> attr(,"border_right")
#> [1] "single"
#> attr(,"border_bottom")
#> [1] "single"
#> attr(,"border_width")
#> [1] 15
#> attr(,"cell_height")
#> [1] 0.15
#> attr(,"cell_justification")
#> [1] "c"
#> attr(,"cell_vertical_justification")
#> [1] "top"
#> attr(,"as_table")
#> [1] TRUE
#> attr(,"col_rel_width")
#> [1] 1
```
