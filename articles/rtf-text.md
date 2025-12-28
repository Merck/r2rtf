# RTF Examples for Controlling Text and Paragraph Details

This vignette documents how to use `rtf_text` and `rtf_paragraph` to
customize text and paragraph in details. All output tables are saved in
the `vignettes/rtf` folder and assembled in
`vignettes/r2rtf_examples.docx` document.

``` r
text <- paste(rep("Sample Text", 20), collapse = " ")
```

``` r
text <- rep(text, 5)
```

## Paragraph

### Paragraph Alignment

Paragraph alignment supports four types.

``` r
r2rtf:::justification() %>% subset(type %in% c("l", "c", "r", "j"))
```

    ##   type      name rtf_code_text rtf_code_row
    ## 1    l      left          \\ql       \\trql
    ## 2    c    center          \\qc       \\trqc
    ## 3    r     right          \\qr       \\trqr
    ## 5    j justified          \\qj

This example display text in different alignment methods.

``` r
res <- r2rtf:::rtf_paragraph(r2rtf:::rtf_text(text),
  justification = c("l", "c", "r", "j")
)
r2rtf:::write_rtf_para(res, "rtf/para-justification.rtf")
```

### Indent

First line, left, and right indent can be controlled. One can also use a
negative number to have the text “outdent”.

``` r
res <- r2rtf:::rtf_paragraph(r2rtf:::rtf_text(text),
  indent_first = c(1000, 0, -1000),
  indent_left = c(500, -500),
  indent_right = 500
)
r2rtf:::write_rtf_para(res, "rtf/para-indent.rtf")
```

### Line Space

Different types of line space can be controlled.

``` r
r2rtf:::spacing()[, 1:2]
```

    ##   type         name
    ## 1  1.0 single-space
    ## 2  2.0 double-space
    ## 3  1.5    1.5-space

This example show different line spaces in paragraph.

``` r
res <- r2rtf:::rtf_paragraph(r2rtf:::rtf_text(text),
  space = c(1, 2, 1.5)
)
r2rtf:::write_rtf_para(res, "rtf/para-line-space.rtf")
```

### Paragraph Space

``` r
res <- r2rtf:::rtf_paragraph(r2rtf:::rtf_text(text),
  space_before = c(50, 180),
  space_after = c(180, 50)
)
r2rtf:::write_rtf_para(res, "rtf/para-space.rtf")
```

### New Page

This example add page break before paragraphs.

``` r
res <- r2rtf:::rtf_paragraph(r2rtf:::rtf_text(text)[1:2],
  new_page = TRUE
)
r2rtf:::write_rtf_para(res, "rtf/para-page.rtf")
```

## Text

### Font Size

``` r
res <- r2rtf:::rtf_paragraph(r2rtf:::rtf_text(text,
  font_size = 8:12
))
r2rtf:::write_rtf_para(res, "rtf/text-font-size-1.rtf")
```

### Text Format

``` r
res <- r2rtf:::rtf_paragraph(r2rtf:::rtf_text(text,
  format = c("b", "i", "bi", "^", "_", "u", "s")
))
```

    ## Warning in matrix(text_rtf, nrow = nrow(text), ncol = ncol(text)): data length
    ## [7] is not a sub-multiple or multiple of the number of rows [5]

``` r
r2rtf:::write_rtf_para(res, "rtf/text-format-1.rtf")
```

### Text Font Type

``` r
res <- r2rtf:::rtf_paragraph(r2rtf:::rtf_text(text,
  font = 1:10
))
```

    ## Warning in matrix(text_rtf, nrow = nrow(text), ncol = ncol(text)): data length
    ## differs from size of matrix: [10 != 5 x 1]

``` r
r2rtf:::write_rtf_para(res, "rtf/text-font-type.rtf")
```

### Text Color

``` r
res <- r2rtf:::rtf_paragraph(r2rtf:::rtf_text(text,
  color = c("red", "gold", "black", "orange", "blue")
))
r2rtf:::write_rtf_para(res, "rtf/text-color.rtf")
```

### Text Background Color

``` r
res <- r2rtf:::rtf_paragraph(r2rtf:::rtf_text(text,
  color = "white",
  background_color = c("red", "gold", "black", "orange", "blue")
))
r2rtf:::write_rtf_para(res, "rtf/text-background-color.rtf")
```

### Combine Text in Different Format

This example call `rtf_text` multiple times to combine a text.

``` r
res <- r2rtf:::rtf_paragraph(paste0(
  r2rtf:::rtf_text("3.5"),
  r2rtf:::rtf_text("\\dagger", format = "^"),
  r2rtf:::rtf_text("\\line red ", color = "red"),
  r2rtf:::rtf_text("highlight", background_color = "yellow")
))
r2rtf:::write_rtf_para(res, "rtf/text-combine1.rtf")
```

This example call `rtf_text` one time to combine a text.

``` r
text <- c(3.5, "\\dagger", "\\line red ", "highlight")
format <- c("", "^", "", "")
color <- c("black", "black", "red", "black")
background_color <- c("white", "white", "white", "yellow")

res <- r2rtf:::rtf_paragraph(
  paste(
    r2rtf:::rtf_text(text,
      format = format,
      color = color,
      background_color = background_color
    ),
    collapse = ""
  )
)
r2rtf:::write_rtf_para(res, "rtf/text-combine2.rtf")
```

### Inline Formatting

This example provide an inline formatting options with superscript and
subscript. It is important to note the location of
[`{}`](https://rdrr.io/r/base/Paren.html) is before the special
character.

``` r
text <- c("X{_1} = \\alpha{^2} + \\beta{^\\dagger}")
res <- r2rtf:::rtf_paragraph(r2rtf:::rtf_text(text))
r2rtf:::write_rtf_para(res, "rtf/text-combine3.rtf")
```

## RTF Control Words for Page Numbering

The r2rtf package supports several control words for page numbering in
tables. These control words can be used in titles, headers, footnotes,
and other text elements.

### Available Control Words

| Control Word             | Description                             | Use Case                                                                       |
|--------------------------|-----------------------------------------|--------------------------------------------------------------------------------|
| `\pagenumber`            | Dynamic RTF page field (document-level) | When you need the actual document page number                                  |
| `\pagenumber_hardcoding` | Hardcoded table-specific page number    | For multi-page tables with table-relative page numbering (e.g., “Page 1 of 3”) |
| `\totalpage`             | Total number of pages in the table      | Works with `\pagenumber_hardcoding` to show “X of Y” format                    |
| `\pagefield`             | RTF NUMPAGES field code                 | For total document pages                                                       |

### Example 1: Using `\pagenumber` (Document-Level Page Number)

This example uses `\pagenumber` which shows the document-level page
number. When multiple tables are combined, it shows the absolute page
position in the document.

``` r
tbl1_file <- tempfile(fileext = ".rtf")
tbl2_file <- tempfile(fileext = ".rtf")

iris[1:30, ] |>
  rtf_title("Table 1: Iris Data (Page \\pagenumber)") |>
  rtf_colheader("Sepal.Length | Sepal.Width | Petal.Length | Petal.Width | Species") |>
  rtf_body(col_rel_width = rep(1, 5)) |>
  rtf_encode() |>
  write_rtf(tbl1_file)

iris[31:60, ] |>
  rtf_title("Table 2: Iris Data (Page \\pagenumber)") |>
  rtf_colheader("Sepal.Length | Sepal.Width | Petal.Length | Petal.Width | Species") |>
  rtf_body(col_rel_width = rep(1, 5)) |>
  rtf_encode() |>
  write_rtf(tbl2_file)

assemble_rtf(
  input = c(tbl1_file, tbl2_file),
  output = "rtf/page-number-dynamic.rtf"
)
```

### Example 2: Using `\pagenumber_hardcoding` (Table-Specific Page Number)

This example uses `\pagenumber_hardcoding` which shows the
table-specific page number. When multiple tables are combined, each
table maintains its own independent page numbering (1/N, 2/N, etc.).
Note that Table 1 spans multiple pages to demonstrate how the page
counter works within a single table.

``` r
tbl3_file <- tempfile(fileext = ".rtf")
tbl4_file <- tempfile(fileext = ".rtf")

# Create a multi-page table to demonstrate page numbering within a single table
iris[1:100, ] |>
  rtf_title("Table 1: Iris Data (\\pagenumber_hardcoding/\\totalpage)") |>
  rtf_colheader("Sepal.Length | Sepal.Width | Petal.Length | Petal.Width | Species") |>
  rtf_body(col_rel_width = rep(1, 5)) |>
  rtf_encode() |>
  write_rtf(tbl3_file)

# Single page table to show independent numbering
iris[101:130, ] |>
  rtf_title("Table 2: Iris Data (\\pagenumber_hardcoding/\\totalpage)") |>
  rtf_colheader("Sepal.Length | Sepal.Width | Petal.Length | Petal.Width | Species") |>
  rtf_body(col_rel_width = rep(1, 5)) |>
  rtf_encode() |>
  write_rtf(tbl4_file)

assemble_rtf(
  input = c(tbl3_file, tbl4_file),
  output = "rtf/page-number-hardcoding.rtf"
)
```

### Key Differences

**`\pagenumber` (Dynamic Field):** - Shows: 1, 2, 3, 4, 5, … (continuous
across document) - Use when: You need absolute document page numbers -
Behavior: When combining tables with
[`assemble_rtf()`](https://merck.github.io/r2rtf/reference/assemble_rtf.md),
pages continue numbering across all tables

**`\pagenumber_hardcoding` (Hardcoded Table Pages):** - Shows: Table 1
displays “1/3, 2/3, 3/3”, Table 2 displays “1/1” (each restarts) - Use
when: You need table-relative page numbering where each table has its
own counter - Behavior: Each table’s pages are numbered independently
starting from 1. This is especially useful for multi-page tables that
need internal page tracking.
