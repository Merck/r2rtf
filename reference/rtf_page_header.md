# Add RTF Page Header Information

Add RTF Page Header Information

## Usage

``` r
rtf_page_header(
  tbl,
  text = "Page \\pagenumber of \\pagefield",
  text_font = 1,
  text_format = NULL,
  text_font_size = 12,
  text_color = NULL,
  text_background_color = NULL,
  text_justification = "r",
  text_indent_first = 0,
  text_indent_left = 0,
  text_indent_right = 0,
  text_space = 1,
  text_space_before = 15,
  text_space_after = 15,
  text_convert = TRUE
)
```

## Arguments

- tbl:

  A data frame.

- text:

  A character string.

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
