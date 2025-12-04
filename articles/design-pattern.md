# r2rtf Design Pattern

## Overview

> This document is for developers who would like to understand the
> internal of the `r2rtf` package.

The r2rtf package is developed to standardize the approach to generate
highly customized tables, listings and figures (TLFs) in RTF format and
provide flexibility to customize table appearance for table title,
subtitle, column header, footnote, and data source.

The r2rtf package is designed to enables pipes (`%>%`), the first
argument are all `tbl` except
[`rtf_read_figure()`](https://merck.github.io/r2rtf/reference/rtf_read_figure.md)
and
[`write_rtf()`](https://merck.github.io/r2rtf/reference/write_rtf.md). A
minimal example summarized the major steps in using r2rtf package to
create a table or listing after a data frame is ready.

``` r
head(iris) %>%
  rtf_body() %>% # Step 1 Add attributes
  rtf_encode() %>% # Step 2 Convert attributes to RTF encode
  write_rtf(file = "rtf/ex-tbl.rtf") # Step 3 Write to a .rtf file
```

Similar step is used to create a figure. First we generate a figure in
`png` format, then use
[`rtf_read_figure()`](https://merck.github.io/r2rtf/reference/rtf_read_figure.md)
to read in the `png` file, and proceed to rtf generation.

``` r
fig <- c("fig/fig1.png")
fig %>% rtf_read_figure() %>% # Step 1 Read in PNG file
  rtf_figure() %>% # Step 2 Add attributes
  rtf_encode(doc_type = "figure") %>% # Step 3 Convert attributes to RTF encode
  write_rtf(file = "rtf/ex-fig.rtf") # Step 4 Write to a .rtf file
```

## Data Structure and Attributes

We explore
[`rtf_page()`](https://merck.github.io/r2rtf/reference/rtf_page.md) to
illustrate how attributes of a data frame is used.
[`rtf_page()`](https://merck.github.io/r2rtf/reference/rtf_page.md) is a
function to define the feature of a page in rtf document. For example,
we need to set the page orientation, width, height, margin etc. The
information is attached to an data frame using attributes.

Therefore, the core part of
[`rtf_page()`](https://merck.github.io/r2rtf/reference/rtf_page.md) is
to assign attributes to the input data frame (`tbl`) as below. Necessary
input checking using `check_arg()`,
[`stopifnot()`](https://rdrr.io/r/base/stopifnot.html) and
[`match.arg()`](https://rdrr.io/r/base/match.arg.html), is provided in
the function to provide informative error message with unexpected input.

``` r
attr(tbl, "page")$orientation <- orientation
attr(tbl, "page")$width <- width
attr(tbl, "page")$height <- height
attr(tbl, "page")$margin <- margin
attr(tbl, "page")$border_color_first <- border_color_first
```

All attributes is saved in a logical way and summarized in the table
below.

``` r
tbl <- head(iris) %>% rtf_page()
```

To access the attributes, [`attr()`](https://rdrr.io/r/base/attr.html)
or [`attributes()`](https://rdrr.io/r/base/attributes.html) function can
be used. For example, to get page attributes in default setting, we can
run code below.

``` r
data.frame(value = unlist(attr(tbl, "page")))
#>                  value
#> width              8.5
#> height              11
#> orientation   portrait
#> margin1           1.25
#> margin2              1
#> margin3           1.75
#> margin4           1.25
#> margin5           1.75
#> margin6        1.00625
#> nrow                40
#> col_width         6.25
#> border_first    double
#> border_last     double
#> page_title         all
#> page_footnote     last
#> page_source       last
#> use_color        FALSE
#> use_i18n         FALSE
```

The table body attributes are more complicated than page attributes.
Take [`rtf_body()`](https://merck.github.io/r2rtf/reference/rtf_body.md)
as an example, it meets the user’s need to take fully control of table
appearance through parameters to customize table size, space, border
type (e.g., single, double, dash, dot, etc.), color (e.g., 657 different
colors named in `color()` function), line width, column width, row
height, text format (e.g., bold, italics, strikethrough, underline and
any combinations), font size, text color, alignment (e.g., left, right,
center, decimal), etc. Format control can be at the cell, row, column,
or table level.

With the help of functions `obj_rtf_text()` and `obj_rtf_border()`, it
is straightforward to pass the user inputs to text/border attributes.
For example, parameter `text_justification = "c"` sets all text in the
cells to be center adjusted and
`text_justification = c("c", rep("l", 4))` sets the text in the first
column to be center adjusted and the texts in the remaining 4 columns to
be left adjusted for a table with five columns.

In addition,
[`rtf_body()`](https://merck.github.io/r2rtf/reference/rtf_body.md)
initiates “page” attributes when color is used in any of table elements
(border, text, etc.).

``` r
head(iris) %>% rtf_body()
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#> 1          5.1         3.5          1.4         0.2  setosa
#> 2          4.9           3          1.4         0.2  setosa
#> 3          4.7         3.2          1.3         0.2  setosa
#> 4          4.6         3.1          1.5         0.2  setosa
#> 5            5         3.6          1.4         0.2  setosa
#> 6          5.4         3.9          1.7         0.4  setosa
```

Similarly to
[`rtf_body()`](https://merck.github.io/r2rtf/reference/rtf_body.md), the
package also includes
[`rtf_colheader()`](https://merck.github.io/r2rtf/reference/rtf_colheader.md),
[`rtf_footnote()`](https://merck.github.io/r2rtf/reference/rtf_footnote.md),
[`rtf_source()`](https://merck.github.io/r2rtf/reference/rtf_source.md),
[`rtf_subline()`](https://merck.github.io/r2rtf/reference/rtf_subline.md),
`rtf_text()`,
[`rtf_title()`](https://merck.github.io/r2rtf/reference/rtf_title.md)
and
[`rtf_figure()`](https://merck.github.io/r2rtf/reference/rtf_figure.md)
to assign attributes to the certain component of the output. Below is a
simple example of using the functions together for table/figure.

``` r
head(iris) %>% # Step 1 Read in data frame
  rtf_title("iris") %>% # Step 2 Add title
  rtf_colheader("A | B | C | D | E") %>% # Step 3 Add column header
  rtf_body() %>% # Step 4 Add attributes
  rtf_footnote("This is a footnote") %>% # Step 5 Add footnote
  rtf_source("Source: xxx") # Step 6 Add data source
```

``` r
"fig/tmp-fig.png" %>%
  rtf_read_figure() %>% # Step 1 Read PNG files from the file path
  rtf_title("title", "subtitle") %>% # Step 2 Add title or subtitle
  rtf_footnote("footnote") %>% # Step 3 Add footnote
  rtf_source("[datasource: mk0999]") %>% # Step 4 Add data source
  rtf_figure() # Step 5 Add figure attributes
```

## RTF Encoding

[`rtf_encode()`](https://merck.github.io/r2rtf/reference/rtf_encode.md)
wraps up internal functions in r2rtf package to translate all attributes
attached to a data frame into [RTF
syntax](https://web.archive.org/web/20221008045825/http://www.snake.net/software/RTF/RTF-Spec-1.7.pdf).
A good reference is [RTF Pocket
Guide](https://www.oreilly.com/library/view/rtf-pocket-guide/9781449302047/).

All of the internal encoding functions in the r2rtf package start with a
prefix `as_rtf_`. For a table, `r2rtf:::rtf_encode_table()` is used
internally to translate attribute to RTF syntax by using a set of
`as_rtf_` functions.

Likewise, `rtf_encode_list()` is used when we have multiple data frame
with different data structures to be stacked, this is often seen in
efficacy analysis. And `rtf_encode_figure()` is used for figure outputs.

`r2rtf:::as_rtf_colheader()` define the column header in a table or
listing.

``` r
head(iris) %>%
  rtf_body() %>%
  r2rtf:::as_rtf_colheader() %>%
  cat()
```

`r2rtf:::as_rtf_color()` define the color to be used in text or border.

``` r
head(iris) %>%
  rtf_body(text_color = "red") %>%
  r2rtf:::as_rtf_color() %>%
  cat()
```

`r2rtf:::as_rtf_end()` define the end of rtf encode string.

``` r
r2rtf:::as_rtf_end() %>% cat()
```

`r2rtf:::as_rtf_font()` define the font encode.

``` r
r2rtf:::as_rtf_font() %>% cat()
```

`r2rtf:::as_rtf_footnote()` define the footnote encode.

``` r
head(iris) %>%
  rtf_footnote("example") %>%
  r2rtf:::as_rtf_footnote() %>%
  cat()
#> \trowd\trgaph108\trleft0\trqc
#> \clbrdrl\brdrs\brdrw15\clbrdrt\brdrw15\clbrdrr\brdrs\brdrw15\clbrdrb\brdrs\brdrw15\clvertalt\cellx9000
#> \pard\hyphpar0\sb15\sa15\fi0\li0\ri0\ql\fs18{\f0 example}\cell
#> \intbl\row\pard
```

`r2rtf:::as_rtf_init()` initiates rtf encode with ‘English’ as the
default language.

``` r
r2rtf:::as_rtf_init() %>% cat()
```

`r2rtf:::as_rtf_margin()` define a page margin.

``` r
head(iris) %>%
  rtf_page() %>%
  r2rtf::as_rtf_margin() %>%
  cat()
```

`r2rtf:::as_rtf_new_page()` initiates new page encode.

``` r
r2rtf::as_rtf_new_page() %>% cat()
```

`r2rtf:::as_rtf_page()` define a page width (`\paperw`) and
height(`\paperh`).

``` r
head(iris) %>%
  rtf_page() %>%
  r2rtf:::as_rtf_page() %>%
  cat()
```

`r2rtf:::as_rtf_pageby()` define a page_by encoding when argument
page_by is not NULL in
[`rtf_body()`](https://merck.github.io/r2rtf/reference/rtf_body.md).

``` r
iris %>%
  rtf_body(page_by = "Species") %>%
  r2rtf:::as_rtf_pageby() %>%
  cat()
```

`r2rtf:::as_rtf_paragraph()` define a title/text attribute as paragraph.

``` r
r2rtf:::as_rtf_paragraph(attr(head(iris) %>% rtf_title("example"), "rtf_title")) %>% cat()
```

`r2rtf:::as_rtf_source()` define the source encode.

``` r
head(iris) %>%
  rtf_source("example") %>%
  r2rtf:::as_rtf_source() %>%
  cat()
```

`r2rtf:::as_rtf_subline()` define the subline encode.

``` r
head(iris) %>%
  rtf_subline("example") %>%
  r2rtf:::as_rtf_subline() %>%
  cat()
```

`r2rtf:::as_rtf_table()` define the table encode.

``` r
head(iris) %>%
  rtf_title("example") %>%
  r2rtf:::as_rtf_table() %>%
  cat()
```

`r2rtf:::as_rtf_title()` define the title encode.

``` r
head(iris) %>%
  rtf_title("example") %>%
  r2rtf:::as_rtf_title() %>%
  cat()
```

In a minimal example, we can create an RTF file by combining different
pieces of RTF code. For simplicity, we only show the first two rows of
`iris` data

``` r
tbl <- iris[1:2, ] %>% rtf_body()

paste(
  r2rtf:::as_rtf_init(),
  r2rtf:::as_rtf_font(),
  r2rtf:::as_rtf_page(tbl),
  r2rtf:::as_rtf_margin(tbl),
  r2rtf:::as_rtf_table(tbl),
  "}",
  sep = "\n"
) %>% cat()
#> {\rtf1\ansi
#> \deff0\deflang1033
#> {\fonttbl{\f0\froman\fcharset1\fprq2 Times New Roman;}
#> {\f1\froman\fcharset161\fprq2 Times New Roman Greek;}
#> {\f2\fswiss\fcharset161\fprq2 Arial Greek;}
#> {\f3\fswiss\fcharset0\fprq2 Arial;}
#> {\f4\fswiss\fcharset1\fprq2 Helvetica;}
#> {\f5\fswiss\fcharset1\fprq2 Calibri;}
#> {\f6\froman\fcharset1\fprq2 Georgia;}
#> {\f7\ffroman\fcharset1\fprq2 Cambria;}
#> {\f8\fmodern\fcharset0\fprq2 Courier New;}
#> {\f9\ftech\fcharset2\fprq2 Symbol;}
#> }
#> 
#> \paperw12240\paperh15840
#> 
#> \margl1800\margr1440\margt2520\margb1800\headery2520\footery1449
#> 
#> \trowd\trgaph108\trleft0\trqc
#> \clbrdrl\brdrs\brdrw15\clbrdrt\brdrs\brdrw15\clbrdrb\brdrw15\clvertalt\cellx1800
#> \clbrdrl\brdrs\brdrw15\clbrdrt\brdrs\brdrw15\clbrdrb\brdrw15\clvertalt\cellx3600
#> \clbrdrl\brdrs\brdrw15\clbrdrt\brdrs\brdrw15\clbrdrb\brdrw15\clvertalt\cellx5400
#> \clbrdrl\brdrs\brdrw15\clbrdrt\brdrs\brdrw15\clbrdrb\brdrw15\clvertalt\cellx7200
#> \clbrdrl\brdrs\brdrw15\clbrdrt\brdrs\brdrw15\clbrdrr\brdrs\brdrw15\clbrdrb\brdrw15\clvertalt\cellx9000
#> \pard\hyphpar0\sb15\sa15\fi0\li0\ri0\qc\fs18{\f0 5.1}\cell
#> \pard\hyphpar0\sb15\sa15\fi0\li0\ri0\qc\fs18{\f0 3.5}\cell
#> \pard\hyphpar0\sb15\sa15\fi0\li0\ri0\qc\fs18{\f0 1.4}\cell
#> \pard\hyphpar0\sb15\sa15\fi0\li0\ri0\qc\fs18{\f0 0.2}\cell
#> \pard\hyphpar0\sb15\sa15\fi0\li0\ri0\qc\fs18{\f0 setosa}\cell
#> \intbl\row\pard
#> } {\rtf1\ansi
#> \deff0\deflang1033
#> {\fonttbl{\f0\froman\fcharset1\fprq2 Times New Roman;}
#> {\f1\froman\fcharset161\fprq2 Times New Roman Greek;}
#> {\f2\fswiss\fcharset161\fprq2 Arial Greek;}
#> {\f3\fswiss\fcharset0\fprq2 Arial;}
#> {\f4\fswiss\fcharset1\fprq2 Helvetica;}
#> {\f5\fswiss\fcharset1\fprq2 Calibri;}
#> {\f6\froman\fcharset1\fprq2 Georgia;}
#> {\f7\ffroman\fcharset1\fprq2 Cambria;}
#> {\f8\fmodern\fcharset0\fprq2 Courier New;}
#> {\f9\ftech\fcharset2\fprq2 Symbol;}
#> }
#> 
#> \paperw12240\paperh15840
#> 
#> \margl1800\margr1440\margt2520\margb1800\headery2520\footery1449
#> 
#> \trowd\trgaph108\trleft0\trqc
#> \clbrdrl\brdrs\brdrw15\clbrdrt\brdrw15\clbrdrb\brdrs\brdrw15\clvertalt\cellx1800
#> \clbrdrl\brdrs\brdrw15\clbrdrt\brdrw15\clbrdrb\brdrs\brdrw15\clvertalt\cellx3600
#> \clbrdrl\brdrs\brdrw15\clbrdrt\brdrw15\clbrdrb\brdrs\brdrw15\clvertalt\cellx5400
#> \clbrdrl\brdrs\brdrw15\clbrdrt\brdrw15\clbrdrb\brdrs\brdrw15\clvertalt\cellx7200
#> \clbrdrl\brdrs\brdrw15\clbrdrt\brdrw15\clbrdrr\brdrs\brdrw15\clbrdrb\brdrs\brdrw15\clvertalt\cellx9000
#> \pard\hyphpar0\sb15\sa15\fi0\li0\ri0\qc\fs18{\f0 4.9}\cell
#> \pard\hyphpar0\sb15\sa15\fi0\li0\ri0\qc\fs18{\f0 3}\cell
#> \pard\hyphpar0\sb15\sa15\fi0\li0\ri0\qc\fs18{\f0 1.4}\cell
#> \pard\hyphpar0\sb15\sa15\fi0\li0\ri0\qc\fs18{\f0 0.2}\cell
#> \pard\hyphpar0\sb15\sa15\fi0\li0\ri0\qc\fs18{\f0 setosa}\cell
#> \intbl\row\pard
#> }
```

If we save the RTF code into an `.rtf` file. Microsoft Word or other RTF
Viewer software can display the file properly.

## Save RTF File

After everything has been translated into RTF code using
[`rtf_encode()`](https://merck.github.io/r2rtf/reference/rtf_encode.md).
It is a simple step to save all RTF code into an `.rtf` file.

[`write_rtf()`](https://merck.github.io/r2rtf/reference/write_rtf.md) is
a simple wrapper of the [`write()`](https://rdrr.io/r/base/write.html)
function, which exports a single RTF string into the output file.

A simple example is as in the overview section.

``` r
head(iris) %>%
  rtf_body() %>% # Step 1 Add attributes
  rtf_encode() %>% # Step 2 Convert attributes to RTF encode
  write_rtf(file = "tmp.rtf") # Step 3 Write to a .rtf file
```

## Dictionary and Conversion

As mentioned earlier, functions in the `dictionary.R` file contains the
most commonly used font types, formats, border types, etc. All these
attributes are mapped in a data frame which contains the element names
and corresponding RTF encode. User is only allowed to key in whatever is
defined in dictionary for the rtf\_ functions, or error message will be
provided as a result from `match_arg()`.

``` r
r2rtf:::font_type()
#>    type                  name     style rtf_code    family       charset
#> 1     1       Times New Roman  \\froman     \\f0     Times   \\fcharset1
#> 2     2 Times New Roman Greek  \\froman     \\f1     Times \\fcharset161
#> 3     3           Arial Greek  \\fswiss     \\f2   ArialMT \\fcharset161
#> 4     4                 Arial  \\fswiss     \\f3   ArialMT   \\fcharset0
#> 5     5             Helvetica  \\fswiss     \\f4 Helvetica   \\fcharset1
#> 6     6               Calibri  \\fswiss     \\f5   Calibri   \\fcharset1
#> 7     7               Georgia  \\froman     \\f6   Georgia   \\fcharset1
#> 8     8               Cambria \\ffroman     \\f7   Cambria   \\fcharset1
#> 9     9           Courier New \\fmodern     \\f8   Courier   \\fcharset0
#> 10   10                Symbol   \\ftech     \\f9     Times   \\fcharset2
#> 11   11                SimSun    \\fnil    \\f10    SimSun \\fcharset134
#>    width_group
#> 1            1
#> 2            1
#> 3            4
#> 4            4
#> 5            4
#> 6            1
#> 7            9
#> 8            4
#> 9            9
#> 10           9
#> 11           1
```

Superscripts, under scripts are taken care of by using `convert()`
function to translate them into LaTeX code and Unicode. For example:

``` r
r2rtf:::convert(c("^", "<="))
#> [1] "\\super "       "\\uc1\\u8804* "
```

## Pageby

It is commonly seen a variable displayed in headline as group category
(e.g. baseline characteristic table). To achieve this, user first need
to sort input data frame by page_by variable then define it in
[`rtf_body()`](https://merck.github.io/r2rtf/reference/rtf_body.md).
Border and text attributes are controlled together with other variables
in the vectors.

``` r
iris %>%
  arrange(Species) %>%
  rtf_colheader("Sepal Length | Sepal Width | Petal Length | PetalWidth", ) %>%
  rtf_body(
    page_by = c("Species"),
    border_top = c(rep("", 4), c("single")),
    border_bottom = c(rep("", 4), c("single")),
    text_justification = c(rep("c", 4), c("l")),
    new_page = TRUE
  ) %>%
  rtf_encode() %>%
  write_rtf("pageby.rtf")
```

## Utility functions

- `check_args()`: Function for argument checking for types, length or
  dimension, this function is used for all export functions except
  [`write_rtf()`](https://merck.github.io/r2rtf/reference/write_rtf.md).
- `match_arg()`: Function for argument verification on input values to
  see whether they match `dictionary()` defined values, this function is
  used for all export functions except `write_rtf`().
- `footnote_source_space()`: Function to derive space adjustment, whose
  results could be used in
  [`rtf_footnote()`](https://merck.github.io/r2rtf/reference/rtf_footnote.md)
  and
  [`rtf_source()`](https://merck.github.io/r2rtf/reference/rtf_source.md)
  when indentation is defined by user.
