# r2rtf 1.0.4 (2023-06-17)

## Bug fixes

* Page size of the first page is different from the other pages (#174).

# r2rtf 1.0.3 (2023-05-26)

## Bug fixes

* Properly display cell height in HTML output (#66).
* Fix an issue when `group_by` and `page_by` are used together (#168).

# r2rtf 1.0.2 (2023-05-01)

## Bug fixes

* Display proper indentation for footnote and data source (#141).
* Fix an issue when a column only contains missing value (#146).

## Improvements

* Improve grammar and style for the main vignette (@howardbaek, #144).
* Add libreoffice 7.4 and 7.5 support (#156).
* Add citation details (#155).

# r2rtf 1.0.1 (2023-02-02)

## New features

* Enable vertical alignment (#136).

## Improvements

* Add support for libreoffice 7.3 (#92).

# r2rtf 1.0.0 (2023-01-12)

## New features

* Add new functions: `assemble_docx()` and `assemble_rtf()`.

## Bug fixes

* `rtf_encode()` fails when data contains `NA` and fixed-width font is used (#118).
* Avoid error when `cell_nrow = 1` (#108, #109).

## Improvements

* Update copyright text.

# r2rtf 0.3.5 (2022-05-17)

## Bug fixes

* Avoid warning messages on matrix dimension in R >= 4.2.0 (#101).
* Vectorized text justification for `rtf_title()`, `rtf_footnote()`, and other functions (#98).

# r2rtf 0.3.4 (2022-04-08)

## Bug fixes

* `utf8Tortf()` provides additional "-".

## Improvements

* Update maintainer email.

# r2rtf 0.3.3 (2022-03-07)

## Improvements

* `rtf_page()` now has a new argument `use_color`.

## Bug fixes

* Convert to proper RTF code.
* `rft_encode()` does not add footnote and source to all pages for `doc_type = "figure"` (#90).

# r2rtf 0.3.2 (2021-12-07)

## New features

* The new function `rtf_read_figure()` supports `jpeg` and `emf` formats for reading figures (#65).

## Bug fixes

* Avoid using `as.vector` for `data.frame` (#74).
* Proper alignment to transfer `html` (#61).

## Improvements

* Avoid specific libreoffice version (#68).

# r2rtf 0.3.1 (2021-09-09)

## New features

* New argument `cell_vertical_alignment` in `rtf_*()` functions (#49, #52).
* New argument `verbose` in `rtf_encode_list()` and `rtf_encode_table()` (#38).

## Bug fixes

* `unicode_latex` not found (#50).
* Vertical align column headers (#49, #52).
* Vectorize text formatting arguments in `rtf_page_header()` and `rtf_page_footer()` (#47, #53).
* `text_format` issue with all value equal to `""` (#40).
* r2rtf needs to work properly with `group_by()` (#36).

# r2rtf 0.3.0 (2021-06-01)

## New features

* New experimental internal function `rtf_convert_format()`.
* New argument `pageby_row` in `rtf_body()` to display first row instead of
  `page_by` variable when `pageby_row = "first_row"`.
* New argument `subline_by` in `rtf_body` to display subline by an variable.
* New argument `text_indent_reference` to allow user to control reference of
  indent from page margin or table border (#12).
* New internal function `rtf_subset()` to subset an RTF table object.

## Bug fixes

* `group_by` can be used when `page_by = NULL`.
* `page_by` cannot sort format style in `rtf_body()`.
* Ensure consistent font size with blank cell (#14).

## Improvements

* Rename datasets with prefix `r2rtf_` to avoid conflicts with other namespaces.
* Enable special place holder `"-----"` in `page_by` variable to suppress line
  displayed in the `page_by` variable. See example 2 in
  `vignettes/example-pageby-groupby.Rmd`.

# r2rtf 0.2.0 (2020-12-04)

## New features

* Add `rtf_subline()`, `rtf_page_header()`, and `rtf_page_footer()`.
* Add `rtf_page()` to set page related attributes.
* Introduce argument `text_convert` to allow fixed string.
* Add argument `as_table` in `rtf_footnote()` and `rtf_source()` to allow
  footnote and data source inside or outside of a table.
* Refactor the `pageby` feature to enable the `group_by` feature.
  Add `vignettes/example-pageby.Rmd` to illustrate new `pageby` features.
* Define `obj_rtf_border` and `obj_rtf_text` objects to standardize
  border and text attributes.

## Improvements

* Add example ADaM datasets.
* Add validation tracker in `inst/` and test cases in `tests/`.

# r2rtf 0.1.1 (2020-04-03)

* Standardize input from `gt_tbl` to `tbl`.
* Resolve UTF-8 encoding.

# r2rtf 0.1.0 (Unpublished)

* Added a `NEWS.md` file to track changes to the package.
* Initial version.
