# Add Table Body Attributes to the Table

Add Table Body Attributes to the Table

## Usage

``` r
rtf_body(
  tbl,
  col_rel_width = rep(1, ncol(tbl)),
  as_colheader = TRUE,
  border_left = "single",
  border_right = "single",
  border_top = NULL,
  border_bottom = NULL,
  border_first = "single",
  border_last = "single",
  border_color_left = NULL,
  border_color_right = NULL,
  border_color_top = NULL,
  border_color_bottom = NULL,
  border_color_first = NULL,
  border_color_last = NULL,
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
  text_justification = NULL,
  text_indent_first = 0,
  text_indent_left = 0,
  text_indent_right = 0,
  text_space = 1,
  text_space_before = 15,
  text_space_after = 15,
  text_convert = TRUE,
  group_by = NULL,
  page_by = NULL,
  new_page = FALSE,
  pageby_header = TRUE,
  pageby_row = "column",
  subline_by = NULL,
  last_row = TRUE
)
```

## Arguments

- tbl:

  A data frame.

- col_rel_width:

  Column relative width in a vector e.g. c(2,1,1) refers to 2:1:1.
  Default is NULL for equal column width.

- as_colheader:

  A boolean value to indicate whether to add default column header to
  the table. Default is TRUE to use data frame column names as column
  header.

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

- border_first:

  First top border type of the whole table. All possible input can be
  found in `r2rtf:::border_type()$name`.

- border_last:

  Last bottom border type of the whole table. All possible input can be
  found in `r2rtf:::border_type()$name`.

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

- border_color_first:

  First top border color type of the whole table. Default is NULL for
  black. All possible input can be found in
  [`grDevices::colors()`](https://rdrr.io/r/grDevices/colors.html).

- border_color_last:

  Last bottom border color type of the whole table. Default is NULL for
  black. All possible input can be found in
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

- text_convert:

  A logical value to convert special characters.

- group_by:

  A character vector of variable names in `tbl`.

- page_by:

  Column names in a character vector to group by table in sections.

- new_page:

  A boolean value to indicate whether to separate grouped table into
  pages by sections. Default is FALSE.

- pageby_header:

  A boolean value to display `pageby` header at the beginning of each
  page. Default is `TRUE`. If the value is `FALSE`, the `pageby` header
  is displayed in the first page of the `pageby` group. The special
  `pageby` value `"-----"` is to avoid displaying a `pageby` header for
  this group.

- pageby_row:

  A character vector of location of page_by variable. Possible input are
  'column' or 'first_row'.

- subline_by:

  Column names in a character vector to subline by table in sections.

- last_row:

  A boolean value to indicate whether the table contains the last row of
  the final table.

## Value

the same data frame `tbl` with additional attributes for table body

## Specification

The contents of this section are shown in PDF user manual only.

## Examples

``` r
library(dplyr) # required to run examples
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union
data(r2rtf_tbl1)
r2rtf_tbl1 %>%
  rtf_body(
    col_rel_width = c(3, 1, 3, 1, 3, 1, 3, 5),
    text_justification = c("l", rep("c", 7)),
    last_row = FALSE
  ) %>%
  attributes()
#> $names
#> [1] "Trt"   "N1"    "Mean1" "N2"    "Mean2" "N3"    "Mean3" "CI"   
#> 
#> $row.names
#> [1] 1 2
#> 
#> $class
#> [1] "data.frame" "rtf_text"   "rtf_border"
#> 
#> $page
#> $page$width
#> [1] 8.5
#> 
#> $page$height
#> [1] 11
#> 
#> $page$orientation
#> [1] "portrait"
#> 
#> $page$margin
#> [1] 1.25000 1.00000 1.75000 1.25000 1.75000 1.00625
#> 
#> $page$nrow
#> [1] 40
#> 
#> $page$col_width
#> [1] 6.25
#> 
#> $page$border_first
#> [1] "double"
#> 
#> $page$border_last
#> [1] "double"
#> 
#> $page$page_title
#> [1] "all"
#> 
#> $page$page_footnote
#> [1] "last"
#> 
#> $page$page_source
#> [1] "last"
#> 
#> $page$use_color
#> [1] FALSE
#> 
#> $page$use_i18n
#> [1] FALSE
#> 
#> 
#> $rtf_colheader
#> $rtf_colheader[[1]]
#>    X1 X2    X3 X4    X5 X6    X7 X8
#> 1 Trt N1 Mean1 N2 Mean2 N3 Mean3 CI
#> 
#> 
#> $text_font
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8]
#> [1,]    1    1    1    1    1    1    1    1
#> [2,]    1    1    1    1    1    1    1    1
#> 
#> $text_font_size
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8]
#> [1,]    9    9    9    9    9    9    9    9
#> [2,]    9    9    9    9    9    9    9    9
#> 
#> $text_justification
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8]
#> [1,] "l"  "c"  "c"  "c"  "c"  "c"  "c"  "c" 
#> [2,] "l"  "c"  "c"  "c"  "c"  "c"  "c"  "c" 
#> 
#> $text_space
#> [1] 1
#> 
#> $text_space_before
#> [1] 15
#> 
#> $text_space_after
#> [1] 15
#> 
#> $text_indent_first
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8]
#> [1,]    0    0    0    0    0    0    0    0
#> [2,]    0    0    0    0    0    0    0    0
#> 
#> $text_indent_left
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8]
#> [1,]    0    0    0    0    0    0    0    0
#> [2,]    0    0    0    0    0    0    0    0
#> 
#> $text_indent_right
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8]
#> [1,]    0    0    0    0    0    0    0    0
#> [2,]    0    0    0    0    0    0    0    0
#> 
#> $text_new_page
#> [1] FALSE
#> 
#> $text_hyphenation
#> [1] TRUE
#> 
#> $text_convert
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8]
#> [1,] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
#> [2,] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
#> 
#> $use_i18n
#> [1] FALSE
#> 
#> $strwidth
#>           [,1]  [,2]      [,3]  [,4]    [,5]  [,6]    [,7]      [,8]
#> [1,] 0.5772569 0.125 0.5520833 0.125 0.53125 0.125 0.53125 0.8958333
#> [2,] 0.3921441 0.125 0.5520833 0.125 0.53125 0.125 0.53125 0.9583333
#> 
#> $use_color
#> [1] FALSE
#> 
#> $border_top
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8]
#> [1,] ""   ""   ""   ""   ""   ""   ""   ""  
#> [2,] ""   ""   ""   ""   ""   ""   ""   ""  
#> 
#> $border_left
#>      [,1]     [,2]     [,3]     [,4]     [,5]     [,6]     [,7]     [,8]    
#> [1,] "single" "single" "single" "single" "single" "single" "single" "single"
#> [2,] "single" "single" "single" "single" "single" "single" "single" "single"
#> 
#> $border_right
#>      [,1]     [,2]     [,3]     [,4]     [,5]     [,6]     [,7]     [,8]    
#> [1,] "single" "single" "single" "single" "single" "single" "single" "single"
#> [2,] "single" "single" "single" "single" "single" "single" "single" "single"
#> 
#> $border_bottom
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8]
#> [1,] ""   ""   ""   ""   ""   ""   ""   ""  
#> [2,] ""   ""   ""   ""   ""   ""   ""   ""  
#> 
#> $border_first
#>      [,1]     [,2]     [,3]     [,4]     [,5]     [,6]     [,7]     [,8]    
#> [1,] "single" "single" "single" "single" "single" "single" "single" "single"
#> [2,] "single" "single" "single" "single" "single" "single" "single" "single"
#> 
#> $border_last
#>      [,1]     [,2]     [,3]     [,4]     [,5]     [,6]     [,7]     [,8]    
#> [1,] "single" "single" "single" "single" "single" "single" "single" "single"
#> [2,] "single" "single" "single" "single" "single" "single" "single" "single"
#> 
#> $border_width
#> [1] 15
#> 
#> $cell_height
#> [1] 0.15
#> 
#> $cell_justification
#> [1] "c"
#> 
#> $cell_vertical_justification
#> [1] "top"
#> 
#> $col_rel_width
#> [1] 3 1 3 1 3 1 3 5
#> 
#> $last_row
#> [1] FALSE
#> 
#> $rtf_by_subline
#> $rtf_by_subline$new_page
#> [1] FALSE
#> 
#> $rtf_by_subline$by_var
#> NULL
#> 
#> $rtf_by_subline$id
#> NULL
#> 
#> 
#> $rtf_pageby
#> $rtf_pageby$new_page
#> [1] FALSE
#> 
#> $rtf_pageby$by_var
#> NULL
#> 
#> $rtf_pageby$id
#> NULL
#> 
#> 
```
