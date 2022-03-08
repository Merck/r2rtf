# r2rtf 0.3.3 (2022-03-07)

* New argument: add `use_color` argument in `rtf_page`
* bug fix: convert to proper RTF code
* bug fig:` rft_encode()` doesn't add footnote and source to all pages for `doc_type = "figure"` (#90)

# r2rtf 0.3.2 (2021-12-07)

* New function: `rtf_read_figure` support `jpeg` and `emf` format to read figure (#65)
* Improvement: avoid specific libreoffice version (#68)
* Bug fix: avoid using `as.vector` for `data.frame` (#74)
* Bug fix: proper alignment to transfer `html` (#61)

# r2rtf 0.3.1 (2021-09-09)

* New argument `cell_vertical_alignment` in `rtf_xxx` function. (#49, #52)
* New argument `verbose` in `rtf_encode_list` and `rtf_encode_table`. (#38)
* Bug fix `unicode_latex` not found. (#50)
* Bug fix vertical align column headers. (#49, #52)
* Bug fix vectorize text formatting arguments in rtf_page_header and rtf_page_footer. (#47, #53)
* Bug fix text_format issue with all value equal to "". (#40)
* `r2rtf` needs to work properly with `group_by()`. (#36)

# r2rtf 0.3.0 (2021-06-01)

* Rename dataset with prefix `r2rtf` to avoid conflict of other namespace
* Enable special place holder "-----" in `page_by` variable to suppress line displayed 
  in `page_by` variable (ref Example 2 in `vignette/example-pageby-groupby`)
* New experimental function `rtf_convert_format`.
* New argument `pageby_row` in `rtf_body` to display first row instead of `page_by` variable when `pageby_row = "first_row"` 
* New argument `subline_by` in `rtf_body` to display subline by an variable.  
* New argument `text_indent_reference` to allow user to control reference of indent from page margin or table border (#12)
* New internal function `rtf_subset` to subset an rtf table object.
* Bug fix `group_by` can be used when `page_by=NULL`.
* Bug fix `page_by` can not sort format style in `rtf_body`
* Bug fix ensure consistent font size with blank cell (#14)

# r2rtf 0.2.0 (2020-12-04)

* Add `rtf_subline`, `rtf_page_header`, `rtf_page_footer`.
* Add `rtf_page` to set page related attributes. 
* Introduce `text_convert` argument to allow fixed string. 
* Add `as_table` argument in `rtf_footnote` and `rtf_source` to allow footnote
  and datasource inside or outside of a table.
* Refactor `pageby` feature to enable `group_by` feature. 
  Add `vignette\example-pageby.Rmd` to illustrate new pageby features.
* Define `obj_rtf_border` and `obj_rtf_text` objects to standardize 
  border and text attributes.
* Add example ADaM datasets. 
* Add validation tracker in `\inst` folder and testing cases in `\test`.


# r2rtf 0.1.1 (2020-04-03)

* Standardize input from `gt_tbl` to `tbl`
* Resolving UTF-8 encoding 

# r2rtf 0.1.0 (Unpublished)

* Added a `NEWS.md` file to track changes to the package.
* Initial Version
