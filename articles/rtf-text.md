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
