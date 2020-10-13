# r2rtf 0.1.1.9001 (development version)

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
