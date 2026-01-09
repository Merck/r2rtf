# Changelog

## r2rtf 1.3.0

CRAN release: 2026-01-09

### New features

- Add
  [`write_docx()`](https://merck.github.io/r2rtf/reference/write_docx.md)
  and
  [`write_html()`](https://merck.github.io/r2rtf/reference/write_html.md)
  to output encoded RTF to DOCX/HTML via LibreOffice
  ([@elong0527](https://github.com/elong0527),
  [\#281](https://github.com/Merck/r2rtf/issues/281)).
- Add `\\pagenumber_hardcoding` control word for table-relative page
  numbering in multi-page tables
  ([@wangben718](https://github.com/wangben718),
  [\#283](https://github.com/Merck/r2rtf/issues/283)).

### Bug fixes

- Remove trailing whitespace after `\\totalpage` to avoid emitting extra
  spaces and support page-aware substitution
  ([@elong0527](https://github.com/elong0527),
  [\#280](https://github.com/Merck/r2rtf/issues/280)).
- [`strwidth()`](https://rdrr.io/r/graphics/strwidth.html) and
  [`par()`](https://rdrr.io/r/graphics/par.html) calls no longer leak a
  graphics device when no device is active, preventing unwanted
  `Rplots.pdf` output ([@nanxstats](https://github.com/nanxstats),
  [\#285](https://github.com/Merck/r2rtf/issues/285)).

### Improvements

- Update vignette examples to avoid misleading footer/source labels
  ([@wangben718](https://github.com/wangben718),
  [\#286](https://github.com/Merck/r2rtf/issues/286)).

### Maintenance

- Include `tests/testthat/_snaps/` in the built package to satisfy
  testthat snapshot requirements and fix `R CMD check` with testthat \>=
  3.3.0 ([@elong0527](https://github.com/elong0527),
  [\#282](https://github.com/Merck/r2rtf/issues/282)).

## r2rtf 1.2.0

CRAN release: 2025-08-22

### New features

- Add internationalization (i18n) support with `use_i18n` parameter in
  [`rtf_page()`](https://merck.github.io/r2rtf/reference/rtf_page.md) to
  enable SimSun font for Chinese character support in RTF documents
  ([\#256](https://github.com/Merck/r2rtf/issues/256)).
- Add `text_hyphenation` parameter to
  [`rtf_title()`](https://merck.github.io/r2rtf/reference/rtf_title.md),
  [`rtf_colheader()`](https://merck.github.io/r2rtf/reference/rtf_colheader.md),
  and
  [`rtf_subline()`](https://merck.github.io/r2rtf/reference/rtf_subline.md)
  functions to control text hyphenation in RTF output
  ([\#235](https://github.com/Merck/r2rtf/issues/235)).

### Improvements

- Refactor font type table to use a data frame structure for better
  maintainability ([\#264](https://github.com/Merck/r2rtf/issues/264)).

## r2rtf 1.1.4

CRAN release: 2025-03-11

### Bug fixes

- Support setting text color properly when encoding figures into RTF
  ([@elong0527](https://github.com/elong0527),
  [\#252](https://github.com/Merck/r2rtf/issues/252)).

### Improvements

- Safeguard code examples and tests against a rare situation where
  officer could miss its underlying dependency systemfonts
  ([@nanxstats](https://github.com/nanxstats),
  [\#249](https://github.com/Merck/r2rtf/issues/249)).

## r2rtf 1.1.3

CRAN release: 2025-02-28

### Bug fixes

- Fix [`unlist()`](https://rdrr.io/r/base/unlist.html) usage in
  `as_rtf_footnote()` which could result in errors for downstream code
  under R \>= 4.5.0 ([@nanxstats](https://github.com/nanxstats),
  [\#245](https://github.com/Merck/r2rtf/issues/245)).

## r2rtf 1.1.2

CRAN release: 2025-02-21

### Improvements

- Fine-tune the symbol to ANSI and Unicode converter for faster, safer,
  and more robust conversion (thanks,
  [@yihui](https://github.com/yihui),
  [\#217](https://github.com/Merck/r2rtf/issues/217)).
- Use code to generate the Unicode/LaTeX mapping table, to replace the
  previous `R/sysdata.rda` solution. Now the mapping table is directly
  accessible via `r2rtf:::unicode_latex` (thanks,
  [@yihui](https://github.com/yihui),
  [\#218](https://github.com/Merck/r2rtf/issues/218)).

## r2rtf 1.1.1

CRAN release: 2023-10-25

### Bug fixes

- Fix bug when converting UTF-8 code \>= 128
  ([\#194](https://github.com/Merck/r2rtf/issues/194)).

### Improvements

- Add LibreOffice 7.6 support and improve error messages style
  ([\#198](https://github.com/Merck/r2rtf/issues/198)).
- Update `.docx` and `.html` artifacts in `vignettes/`
  ([\#206](https://github.com/Merck/r2rtf/issues/206)).

## r2rtf 1.1.0

CRAN release: 2023-07-10

### New features

- Add `r2rtf_ric_text()` to allow inline formatting
  ([\#184](https://github.com/Merck/r2rtf/issues/184)).

### Improvements

- Use the native pipe in unit testing
  ([\#179](https://github.com/Merck/r2rtf/issues/179)).

## r2rtf 1.0.4

CRAN release: 2023-06-18

### Bug fixes

- Page size of the first page is different from the other pages
  ([\#174](https://github.com/Merck/r2rtf/issues/174)).

## r2rtf 1.0.3

CRAN release: 2023-05-26

### Bug fixes

- Properly display cell height in HTML output
  ([\#66](https://github.com/Merck/r2rtf/issues/66)).
- Fix an issue when `group_by` and `page_by` are used together
  ([\#168](https://github.com/Merck/r2rtf/issues/168)).

## r2rtf 1.0.2

CRAN release: 2023-05-01

### Bug fixes

- Display proper indentation for footnote and data source
  ([\#141](https://github.com/Merck/r2rtf/issues/141)).
- Fix an issue when a column only contains missing value
  ([\#146](https://github.com/Merck/r2rtf/issues/146)).

### Improvements

- Improve grammar and style for the main vignette
  ([@howardbaek](https://github.com/howardbaek),
  [\#144](https://github.com/Merck/r2rtf/issues/144)).
- Add LibreOffice 7.4 and 7.5 support
  ([\#156](https://github.com/Merck/r2rtf/issues/156)).
- Add citation details
  ([\#155](https://github.com/Merck/r2rtf/issues/155)).

## r2rtf 1.0.1

CRAN release: 2023-02-01

### New features

- Enable vertical alignment
  ([\#136](https://github.com/Merck/r2rtf/issues/136)).

### Improvements

- Add support for LibreOffice 7.3
  ([\#92](https://github.com/Merck/r2rtf/issues/92)).

## r2rtf 1.0.0

CRAN release: 2023-01-12

### New features

- Add new functions:
  [`assemble_docx()`](https://merck.github.io/r2rtf/reference/assemble_docx.md)
  and
  [`assemble_rtf()`](https://merck.github.io/r2rtf/reference/assemble_rtf.md).

### Bug fixes

- [`rtf_encode()`](https://merck.github.io/r2rtf/reference/rtf_encode.md)
  fails when data contains `NA` and fixed-width font is used
  ([\#118](https://github.com/Merck/r2rtf/issues/118)).
- Avoid error when `cell_nrow = 1`
  ([\#108](https://github.com/Merck/r2rtf/issues/108),
  [\#109](https://github.com/Merck/r2rtf/issues/109)).

### Improvements

- Update copyright text.

## r2rtf 0.3.5

CRAN release: 2022-05-17

### Bug fixes

- Avoid warning messages on matrix dimension in R \>= 4.2.0
  ([\#101](https://github.com/Merck/r2rtf/issues/101)).
- Vectorized text justification for
  [`rtf_title()`](https://merck.github.io/r2rtf/reference/rtf_title.md),
  [`rtf_footnote()`](https://merck.github.io/r2rtf/reference/rtf_footnote.md),
  and other functions
  ([\#98](https://github.com/Merck/r2rtf/issues/98)).

## r2rtf 0.3.4

CRAN release: 2022-04-08

### Bug fixes

- [`utf8Tortf()`](https://merck.github.io/r2rtf/reference/utf8Tortf.md)
  provides additional “-”.

### Improvements

- Update maintainer email.

## r2rtf 0.3.3

CRAN release: 2022-03-07

### Improvements

- [`rtf_page()`](https://merck.github.io/r2rtf/reference/rtf_page.md)
  now has a new argument `use_color`.

### Bug fixes

- Convert to proper RTF code.
- `rft_encode()` does not add footnote and source to all pages for
  `doc_type = "figure"`
  ([\#90](https://github.com/Merck/r2rtf/issues/90)).

## r2rtf 0.3.2

CRAN release: 2021-12-07

### New features

- The new function
  [`rtf_read_figure()`](https://merck.github.io/r2rtf/reference/rtf_read_figure.md)
  supports `jpeg` and `emf` formats for reading figures
  ([\#65](https://github.com/Merck/r2rtf/issues/65)).

### Bug fixes

- Avoid using `as.vector` for `data.frame`
  ([\#74](https://github.com/Merck/r2rtf/issues/74)).
- Proper alignment to transfer `html`
  ([\#61](https://github.com/Merck/r2rtf/issues/61)).

### Improvements

- Avoid specific LibreOffice version
  ([\#68](https://github.com/Merck/r2rtf/issues/68)).

## r2rtf 0.3.1

CRAN release: 2021-09-09

### New features

- New argument `cell_vertical_alignment` in `rtf_*()` functions
  ([\#49](https://github.com/Merck/r2rtf/issues/49),
  [\#52](https://github.com/Merck/r2rtf/issues/52)).
- New argument `verbose` in `rtf_encode_list()` and `rtf_encode_table()`
  ([\#38](https://github.com/Merck/r2rtf/issues/38)).

### Bug fixes

- `unicode_latex` not found
  ([\#50](https://github.com/Merck/r2rtf/issues/50)).
- Vertical align column headers
  ([\#49](https://github.com/Merck/r2rtf/issues/49),
  [\#52](https://github.com/Merck/r2rtf/issues/52)).
- Vectorize text formatting arguments in
  [`rtf_page_header()`](https://merck.github.io/r2rtf/reference/rtf_page_header.md)
  and
  [`rtf_page_footer()`](https://merck.github.io/r2rtf/reference/rtf_page_footer.md)
  ([\#47](https://github.com/Merck/r2rtf/issues/47),
  [\#53](https://github.com/Merck/r2rtf/issues/53)).
- `text_format` issue with all value equal to `""`
  ([\#40](https://github.com/Merck/r2rtf/issues/40)).
- r2rtf needs to work properly with
  [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html)
  ([\#36](https://github.com/Merck/r2rtf/issues/36)).

## r2rtf 0.3.0

CRAN release: 2021-06-01

### New features

- New experimental internal function `rtf_convert_format()`.
- New argument `pageby_row` in
  [`rtf_body()`](https://merck.github.io/r2rtf/reference/rtf_body.md) to
  display first row instead of `page_by` variable when
  `pageby_row = "first_row"`.
- New argument `subline_by` in `rtf_body` to display subline by an
  variable.
- New argument `text_indent_reference` to allow user to control
  reference of indent from page margin or table border
  ([\#12](https://github.com/Merck/r2rtf/issues/12)).
- New internal function `rtf_subset()` to subset an RTF table object.

### Bug fixes

- `group_by` can be used when `page_by = NULL`.
- `page_by` cannot sort format style in
  [`rtf_body()`](https://merck.github.io/r2rtf/reference/rtf_body.md).
- Ensure consistent font size with blank cell
  ([\#14](https://github.com/Merck/r2rtf/issues/14)).

### Improvements

- Rename datasets with prefix `r2rtf_` to avoid conflicts with other
  namespaces.
- Enable special place holder `"-----"` in `page_by` variable to
  suppress line displayed in the `page_by` variable. See example 2 in
  `vignettes/example-pageby-groupby.Rmd`.

## r2rtf 0.2.0

CRAN release: 2020-12-04

### New features

- Add
  [`rtf_subline()`](https://merck.github.io/r2rtf/reference/rtf_subline.md),
  [`rtf_page_header()`](https://merck.github.io/r2rtf/reference/rtf_page_header.md),
  and
  [`rtf_page_footer()`](https://merck.github.io/r2rtf/reference/rtf_page_footer.md).
- Add
  [`rtf_page()`](https://merck.github.io/r2rtf/reference/rtf_page.md) to
  set page related attributes.
- Introduce argument `text_convert` to allow fixed string.
- Add argument `as_table` in
  [`rtf_footnote()`](https://merck.github.io/r2rtf/reference/rtf_footnote.md)
  and
  [`rtf_source()`](https://merck.github.io/r2rtf/reference/rtf_source.md)
  to allow footnote and data source inside or outside of a table.
- Refactor the `pageby` feature to enable the `group_by` feature. Add
  `vignettes/example-pageby.Rmd` to illustrate new `pageby` features.
- Define `obj_rtf_border` and `obj_rtf_text` objects to standardize
  border and text attributes.

### Improvements

- Add example ADaM datasets.
- Add validation tracker in `inst/` and test cases in `tests/`.

## r2rtf 0.1.1

CRAN release: 2020-04-03

- Standardize input from `gt_tbl` to `tbl`.
- Resolve UTF-8 encoding.

## r2rtf 0.1.0 (Unpublished)

- Added a `NEWS.md` file to track changes to the package.
- Initial version.
