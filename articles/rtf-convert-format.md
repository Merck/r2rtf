# File Format Conversion

## Overview

`r2rtf` had an experimental internal function
`r2rtf:::rtf_convert_format` to convert RTF format to PDF, DOCX, or
HTML. This feature requires LibreOffice \>= 7.1 and was only tested in a
Linux environment.

By default, `r2rtf:::rtf_convert_format` convert RTF file to PDF format.
The PDF file will be saved in the same folder with same file name by
default.

In example below, `ae_example.pdf` will be created in the same folder.

``` r
r2rtf:::rtf_convert_format(input = "rtf/ae_example.rtf")
```

- Multiple files can be provided as input.

``` r
r2rtf:::rtf_convert_format(input = list.files("rtf", pattern = "*.rtf"))
```

- The `format` argument allow use to specify output format as `pdf`,
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

  
