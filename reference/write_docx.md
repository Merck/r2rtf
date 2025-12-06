# Write an RTF Table or Figure to a DOCX File

The write_docx function writes an RTF encoding string to a .docx file by
first writing to a temporary RTF file and then converting it to DOCX
using LibreOffice.

## Usage

``` r
write_docx(rtf, file)
```

## Arguments

- rtf:

  A character rtf encoding string rendered by
  [`rtf_encode()`](https://merck.github.io/r2rtf/reference/rtf_encode.md).

- file:

  A character string naming a file to save docx file.

## Details

This function requires LibreOffice to be installed on the system. The
function uses the internal `rtf_convert_format()` function to perform
the conversion from RTF to DOCX format.

Currently only Unix/Linux/macOS systems are supported.

## Specification

The contents of this section are shown in PDF user manual only.
