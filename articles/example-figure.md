# RTF Examples for Figures

``` r
library(r2rtf)
library(dplyr)
library(tidyr)
```

## Examples

This example shows how to create and embed figures into an RTF file as
below.

Below is an example with adjusted page orientation, figure height and
width.

### Overall workflow

The package allow user to embed multiple figures into one RTF document.
The supported format is listed as below.

``` r
r2rtf:::fig_format()
```

    ##   type   rtf_code
    ## 1  emf  \\emfblip
    ## 2  png  \\pngblip
    ## 3 jpeg \\jpegblip

By using `png` file as an example, the workflow can be summarized as:

1.  Save figures into PNG format. (e.g. using
    [`png()`](https://rdrr.io/r/grDevices/png.html) or
    [`ggplot2::ggsave()`](https://ggplot2.tidyverse.org/reference/ggsave.html)).
2.  Read PNG files into R as binary file using
    [`r2rtf::rtf_read_figure()`](https://merck.github.io/r2rtf/reference/rtf_read_figure.md).
3.  Add optional features using
    [`r2rtf::rtf_title()`](https://merck.github.io/r2rtf/reference/rtf_title.md),
    [`r2rtf::rtf_footnote()`](https://merck.github.io/r2rtf/reference/rtf_footnote.md),
    [`r2rtf::rtf_source()`](https://merck.github.io/r2rtf/reference/rtf_source.md).
4.  Set up page and figure options using
    [`r2rtf::rtf_page()`](https://merck.github.io/r2rtf/reference/rtf_page.md),
    [`r2rtf::rtf_figure()`](https://merck.github.io/r2rtf/reference/rtf_figure.md).
5.  Encode rtf using `r2rtf::rtf_encode(doc_type = "figure")`. (Note: it
    is important to set `doc_type = "figure"` as the default is
    `doc_type = "table"` to handle tables).
6.  Write rtf to a file using
    [`r2rtf::write_rtf()`](https://merck.github.io/r2rtf/reference/write_rtf.md).

> For `emf` format, one may use the R package `devEMF` to create the
> figure.

#### Simple Example

``` r
# Define the path of figure
filename <- c("fig/fig1.png", "fig/fig2.png", "fig/fig3.png")

filename %>%
  rtf_read_figure() %>% # read PNG files from the file path
  rtf_title("title", "subtitle") %>% # add title or subtitle
  rtf_footnote("footnote") %>% # add footnote
  rtf_source("[datasource: mk0999]") %>% # add data source
  rtf_figure() %>% # default setting of page and figure
  rtf_encode(doc_type = "figure") %>% # encode rtf as figure
  write_rtf(file = "rtf/fig-simple.rtf") # write RTF to a file
```

#### Example with features

Features of page and figure can be set up in `rtf_page` and `rtf_figure`
respectively:

- Page orientation: `orientation` argument in `rtf_page`.
- Figure height and width: `fig_height` and `fig_width` arguments in
  `rtf_figure`.

The figure height and width can be set up for each figure in a vector.
The code below provides an example for these features.

``` r
filename %>%
  rtf_read_figure() %>% # read PNG files from the file path
  rtf_page(orientation = "landscape") %>% # set page orientation
  rtf_title("title", "subtitle") %>% # add title or subtitle
  rtf_footnote("footnote") %>% # add footnote
  rtf_source("[datasource: mk0999]") %>% # add data source
  rtf_figure(
    fig_height = 3.5, # set figure height
    fig_width = c(6, 7, 8) # set figure width individually.
  ) %>%
  rtf_encode(doc_type = "figure") %>% # encode rtf as figure
  write_rtf(file = "rtf/fig-landscape.rtf") # write RTF to a file
```
