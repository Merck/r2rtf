<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/r2rtf)](https://CRAN.R-project.org/package=r2rtf)
[![Codecov test
coverage](https://codecov.io/gh/Merck/r2rtf/branch/master/graph/badge.svg)](https://codecov.io/gh/Merck/r2rtf?branch=master)
[![R build
status](https://github.com/Merck/r2rtf/workflows/R-CMD-check/badge.svg)](https://github.com/Merck/r2rtf/actions)
[![CRAN
Downloads](https://cranlogs.r-pkg.org/badges/r2rtf)](https://cran.r-project.org/package=r2rtf)
<!-- badges: end -->

Overview
========

Create RTF table and figure with flexible format.

Installation
------------

You can install the package via CRAN:

    install.packages("r2rtf")

Or, install from GitHub for development version:

    remotes::install_github("Merck/r2rtf")

Highlighted Features
--------------------

The R package r2rtf provided flexibility to provide features below:

-   Necessary options to create highly customized RTF table and figure.
-   Simple to use parameters and data structure.
    -   Customized column header: split by “|”.
    -   Three required parameters for the output tables (data, filename,
        column relative width).
    -   Flexible and detail control of table structure.
-   Format control in cell, row, column and table level for:
    -   Border Type: single, double, dash, dot, etc.
    -   Alignment: left, right, center, decimal.
    -   Column width.
    -   Text appearance: **bold**, *italics*, <s>strikethrough</s>,
        underline and any combinations.
    -   Font size.
    -   Text and border color (657 different colors named in `color()`
        function).
    -   Special characters: any character in UTF-8 encoding (e.g. Greek,
        Symbol, Chinese, Japanese, Korean).
-   Append several tables into one file.
-   Pagination.
-   Built in raw data for validation.

Quick Example
-------------

    library(dplyr)
    library(r2rtf)
    head(iris) %>% rtf_body() %>%                       # Step 1 Add attributes 
                   rtf_encode() %>%                     # Step 2 Convert attributes to RTF encode 
                   write_rtf(file = "ex-tbl.rtf")       # Step 3 Write to a .rtf file 

<embed src="vignettes/pdf/ex-tbl.pdf" width="100%" height="400px" style="display: block; margin: auto;" type="application/pdf" />

Example Efficacy Table
----------------------

-   [Source
    code](https://merck.github.io/r2rtf/articles/example-efficacy.html)

<embed src="vignettes/pdf/efficacy_example.pdf" width="100%" height="400px" style="display: block; margin: auto;" type="application/pdf" />

Example Safety Table
--------------------

-   [Source
    code](https://merck.github.io/r2rtf/articles/example-ae-summary.html)

<embed src="vignettes/pdf/ae_example.pdf" width="100%" height="400px" style="display: block; margin: auto;" type="application/pdf" />
