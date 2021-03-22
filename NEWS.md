# r2rtf 0.2.0.9000 (development)

* Rename dataset with prefix `r2rtf` to avoid conflict of other namespace
* Enable special place holder "-----" in `pageby` variable to suppress line displayed 
  in `pageby` variable (ref Example 2 in `vignette/example-pageby-groupby`)
* New argument `pageby_row` in `rtf_body` to display first row instead of `pageby` variable when `pageby_row = "first_row"` 
* New argument `text_indent_reference` to allow user to control reference of indent are from page margin or table border (#12)
* New internal function `rtf_subset` to subset an rtf table object.
* Bug fix `groupby` can be used when `pageby=NULL`.
* Bug fix `pageby` can not sort format style in `rtf_body`
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
