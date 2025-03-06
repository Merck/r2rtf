# r2rtf 1.1.4

## Bug fixes

- Support setting text color properly when encoding figures into RTF
  (@elong0527, #252).

## Improvements

- Safeguard code examples and tests against a rare situation where officer
  could miss its underlying dependency systemfonts (@nanxstats, #249).

# r2rtf 1.1.3

## Bug fixes

- Fix `unlist()` usage in `as_rtf_footnote()` which could result in errors
  for downstream code under R >= 4.5.0 (@nanxstats, #245).

# r2rtf 1.1.2

## Improvements

* Fine-tune the symbol to ANSI and Unicode converter for faster, safer, and
  more robust conversion (thanks, @yihui, #217).
* Use code to generate the Unicode/LaTeX mapping table, to replace the previous
  `R/sysdata.rda` solution. Now the mapping table is directly accessible
  via `r2rtf:::unicode_latex` (thanks, @yihui, #218).

# r2rtf 1.1.1

## Bug fixes

* Fix bug when converting UTF-8 code >= 128 (#194).

## Improvements

* Add LibreOffice 7.6 support and improve error messages style (#198).
* Update `.docx` and `.html` artifacts in `vignettes/` (#206).

# r2rtf 1.1.0

## New features

* Add `r2rtf_ric_text()` to allow inline formatting (#184).

## Improvements

* Use the native pipe in unit testing (#179).

# r2rtf 1.0.4

## Bug fixes

* Page size of the first page is different from the other pages (#174).

# r2rtf 1.0.3

## Bug fixes

* Properly display cell height in HTML output (#66).
* Fix an issue when `group_by` and `page_by` are used together (#168).

# r2rtf 1.0.2

## Bug fixes

* Display proper indentation for footnote and data source (#141).
* Fix an issue when a column only contains missing value (#146).

## Improvements

* Improve grammar and style for the main vignette (@howardbaek, #144).
* Add LibreOffice 7.4 and 7.5 support (#156).
* Add citation details (#155).

# r2rtf 1.0.1

## New features

* Enable vertical alignment (#136).

## Improvements

* Add support for LibreOffice 7.3 (#92).

# r2rtf 1.0.0

## New features

* Add new functions: `assemble_docx()` and `assemble_rtf()`.

## Bug fixes

* `rtf_encode()` fails when data contains `NA` and fixed-width font is used (#118).
* Avoid error when `cell_nrow = 1` (#108, #109).

## Improvements

* Update copyright text.

# r2rtf 0.3.5

## Bug fixes

* Avoid warning messages on matrix dimension in R >= 4.2.0 (#101).
* Vectorized text justification for `rtf_title()`, `rtf_footnote()`, and other functions (#98).

# r2rtf 0.3.4

## Bug fixes

* `utf8Tortf()` provides additional "-".

## Improvements

* Update maintainer email.

# r2rtf 0.3.3

## Improvements

* `rtf_page()` now has a new argument `use_color`.

## Bug fixes

* Convert to proper RTF code.
* `rft_encode()` does not add footnote and source to all pages for `doc_type = "figure"` (#90).

# r2rtf 0.3.2

## New features

* The new function `rtf_read_figure()` supports `jpeg` and `emf` formats for reading figures (#65).

## Bug fixes

* Avoid using `as.vector` for `data.frame` (#74).
* Proper alignment to transfer `html` (#61).

## Improvements

* Avoid specific LibreOffice version (#68).

# r2rtf 0.3.1

## New features

* New argument `cell_vertical_alignment` in `rtf_*()` functions (#49, #52).
* New argument `verbose` in `rtf_encode_list()` and `rtf_encode_table()` (#38).

## Bug fixes

* `unicode_latex` not found (#50).
* Vertical align column headers (#49, #52).
* Vectorize text formatting arguments in `rtf_page_header()` and `rtf_page_footer()` (#47, #53).
* `text_format` issue with all value equal to `""` (#40).
* r2rtf needs to work properly with `group_by()` (#36).

# r2rtf 0.3.0

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

# r2rtf 0.2.0

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

# r2rtf 0.1.1

* Standardize input from `gt_tbl` to `tbl`.
* Resolve UTF-8 encoding.

# r2rtf 0.1.0 (Unpublished)

* Added a `NEWS.md` file to track changes to the package.
* Initial version.
