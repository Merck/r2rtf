# File Format Conversion

## Overview

`r2rtf` provides multiple ways to convert RTF format to other formats
including PDF, DOCX, and HTML:

1.  **User-facing functions**:
    [`write_docx()`](https://merck.github.io/r2rtf/reference/write_docx.md)
    and
    [`write_html()`](https://merck.github.io/r2rtf/reference/write_html.md) -
    Exported functions for converting RTF encoding to DOCX or HTML
2.  **Internal function**: `r2rtf:::rtf_convert_format()` - Lower-level
    function for batch conversion of RTF files

All conversion features require LibreOffice \>= 7.1 and currently
support Unix/Linux/macOS systems only.

## Using write_docx() and write_html()

The
[`write_docx()`](https://merck.github.io/r2rtf/reference/write_docx.md)
and
[`write_html()`](https://merck.github.io/r2rtf/reference/write_html.md)
functions provide a simple interface to convert RTF encoding directly to
DOCX or HTML formats.

### Write DOCX

``` r
# Create RTF encoding
rtf <- head(iris) |>
  rtf_body() |>
  rtf_encode()

# Convert to DOCX
write_docx(rtf, "output/table.docx")
```

### Write HTML

``` r
# Create RTF encoding
rtf <- head(cars) |>
  rtf_body() |>
  rtf_encode()

# Convert to HTML
write_html(rtf, "output/table.html")
```

## Using rtf_convert_format() (Advanced)

The internal `r2rtf:::rtf_convert_format()` function provides more
control for batch processing of existing RTF files.

By default, `r2rtf:::rtf_convert_format` converts RTF files to PDF
format. The PDF file will be saved in the same folder with same file
name by default.

In the example below, `ae_example.pdf` will be created in the same
folder.

``` r
r2rtf:::rtf_convert_format(input = "rtf/ae_example.rtf")
```

- Multiple files can be provided as input.

``` r
r2rtf:::rtf_convert_format(input = list.files("rtf", pattern = "*.rtf"))
```

- The `format` argument allows you to specify output format as `pdf`,
  `docx`, or `html`.

``` r
r2rtf:::rtf_convert_format(input = "rtf/ae_example.rtf", format = "html")
```

### Limitations

There is one known limitation after RTF file convert to HTML files:

- table border issue.
  - “dash”, “small dash”, “dot dash”, and “dot dot” border type are not
    supported

[TABLE]

  
