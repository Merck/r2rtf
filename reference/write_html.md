# Write an RTF Table or Figure to an HTML File

The write_html function writes an RTF encoding string to an .html file
by first writing to a temporary RTF file and then converting it to HTML
using LibreOffice.

## Usage

``` r
write_html(rtf, file)
```

## Arguments

- rtf:

  A character rtf encoding string rendered by
  [`rtf_encode()`](https://merck.github.io/r2rtf/reference/rtf_encode.md).

- file:

  A character string naming a file to save html file.

## Details

This function requires LibreOffice to be installed on the system. The
function uses the internal `rtf_convert_format()` function to perform
the conversion from RTF to HTML format.

Currently only Unix/Linux/macOS systems are supported.

## Specification

The contents of this section are shown in PDF user manual only.
