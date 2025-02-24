
<!-- README.md is generated from README.Rmd. Please edit that file -->

# r2rtf <img src="man/figures/logo.png" align="right" width="120" />

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/r2rtf)](https://CRAN.R-project.org/package=r2rtf)
[![Codecov test
coverage](https://codecov.io/gh/Merck/r2rtf/graph/badge.svg)](https://app.codecov.io/gh/Merck/r2rtf)
[![CRAN
Downloads](https://cranlogs.r-pkg.org/badges/r2rtf)](https://cran.r-project.org/package=r2rtf)
[![R-CMD-check](https://github.com/Merck/r2rtf/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Merck/r2rtf/actions/workflows/R-CMD-check.yaml)
[![status](https://tinyverse.netlify.app/badge/r2rtf)](https://cran.r-project.org/package=r2rtf)
<!-- badges: end -->

## Overview

r2rtf is an R package to create production-ready tables and figures in
RTF format. The package is designed with these principles:

- Provide simple “verb” functions that correspond to each component of a
  table, to help you translate data frame(s) to a table in RTF file.
- Functions are chainable with pipes (`%>%`).
- Only focus on **table format**.
  - Data manipulation and analysis should be handled by other R
    packages, for example, tidyverse.
- Minimize package dependency.

The [R for clinical study reports and submission](https://r4csr.org/)
book provides tutorials by using real world examples.

## Installation

You can install the package via CRAN:

``` r
install.packages("r2rtf")
```

Or, install from GitHub:

``` r
remotes::install_github("Merck/r2rtf")
```

## Highlighted features

The R package r2rtf provides flexibility to enable features below:

- Create highly customized RTF tables and figures ready for production.
- Simple to use parameters and data structure.
  - Customized column header: split by `"|"`.
  - Three required parameters for the output tables (data, filename,
    column relative width).
  - Flexible and detail control of table structure.
- Format control in cell, row, column and table level for:
  - Border Type: single, double, dash, dot, etc.
  - Alignment: left, right, center, decimal.
  - Column width.
  - Text appearance: **bold**, *italics*, ~~strikethrough~~, underline
    and any combinations.
  - Font size.
  - Text and border color (657 different colors named in `color()`
    function).
  - Special characters: any character in UTF-8 encoding (e.g., Greek,
    Symbol, Chinese, Japanese, Korean).
- Append several tables into one file.
- Pagination.
- Built-in raw data for validation.

## Simple example

``` r
library(dplyr)
library(r2rtf)

head(iris) %>%
  rtf_body() %>% # Step 1 Add attributes
  rtf_encode() %>% # Step 2 Convert attributes to RTF encode
  write_rtf(file = "ex-tbl.rtf") # Step 3 Write to a .rtf file
```

<details>

<summary>

Click here to see the output
</summary>

<img src="https://merck.github.io/r2rtf/articles/fig/ex-tbl.png">
</details>

- [More Examples](https://merck.github.io/r2rtf/articles/index.html)

## Example efficacy table

- [Source
  code](https://merck.github.io/r2rtf/articles/example-efficacy.html)

<details>

<summary>

Click here to see the output
</summary>

<img src="https://merck.github.io/r2rtf/articles/fig/efficacy_example.png">
</details>

## Example safety table

- [Source
  code](https://merck.github.io/r2rtf/articles/example-ae-summary.html)

<details>

<summary>

Click here to see the output
</summary>

<img src="https://merck.github.io/r2rtf/articles/fig/ae_example.png">
</details>

## Citation

If you use this software, please cite it as below.

> Wang, S., Ye, S., Anderson, K., & Zhang, Y. (2020). r2rtf—an R Package
> to Produce Rich Text Format (RTF) Tables and Figures. *PharmaSUG*.
> <https://pharmasug.org/proceedings/2020/DV/PharmaSUG-2020-DV-198.pdf>

A BibTeX entry for LaTeX users is

``` bibtex
@inproceedings{wang2020r2rtf,
  title     = {{r2rtf}---an {R} Package to Produce {Rich Text Format} ({RTF}) Tables and Figures},
  author    = {Wang, Siruo and Ye, Simiao and Anderson, Keaven M and Zhang, Yilong},
  booktitle = {PharmaSUG},
  year      = {2020},
  url       = {https://pharmasug.org/proceedings/2020/DV/PharmaSUG-2020-DV-198.pdf}
}
```
