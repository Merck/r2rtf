# Read Figures into Binary Files

Supported format is listed in `r2rtf:::fig_format()`.

## Usage

``` r
rtf_read_figure(file)
```

## Arguments

- file:

  A character vector of figure file paths.

## Value

a list of binary data vector returned by `readBin`

## Specification

The contents of this section are shown in PDF user manual only.

## Examples

``` r
if (FALSE) { # \dontrun{

# Read in PNG file in binary format
file <- tempfile("figure", fileext = ".png")
png(file)
plot(1:10)
dev.off()


rtf_read_figure(file)

# Read in EMF file in binary format
library(devEMF)
file <- tempfile("figure", fileext = ".emf")
emf(file)
plot(1:10)
dev.off()

rtf_read_figure(file)
} # }
```
