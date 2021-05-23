
#    Copyright (c) 2020 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.
#
#    This file is part of the r2rtf program.
#
#    r2rtf is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

#' Combine RTF Table Encoding
#'
#' @param tbl A data frame.
#' @importFrom utils tail
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Calculate number of rows for table content, title, header, footnote and source for each page from `tbl` object.
#'    \item Calculate number of pages using total number of rows divided by number of rows in each page.
#'    \item Extract first and last row for each page, assign border type and color attributes based on input from `rtf_body()`.
#'    \item Convert to RTF encoding using `rtf_table_content()`.
#'    \item Combine all components into a single code string.
#'    \item Add info attributes into `tbl`.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
as_rtf_table <- function(tbl) {


  # Remove subline_by column
  if(! is.null(attr(tbl, "rtf_by_subline")$by_var)){
    index_subline <- which( names(tbl) %in% attr(tbl, ("rtf_by_subline"))$by_var)
    tbl <- rtf_subset(tbl, col = - index_subline)
  }

  # Calculate Number of rows for each entry.
  tbl <- rtf_nrow(tbl)

  # tbl attributes
  page <- attr(tbl, "page")
  group_by <- attr(tbl, "rtf_groupby")
  col_width <- attr(tbl, "page")$col_width

  # Get number of row for each entry
  rtf_nrow <- attr(tbl, "rtf_nrow_meta")

  # Number of rows in cells based on column size
  cell_tbl <- tbl

  # Number of rows in cells based on column size
  index <- 1:nrow(cell_tbl)

  # Number of row in each table entry
  if (is.null(attr(cell_tbl, "cell_nrow"))) {
    table_nrow <- attr(cell_tbl, "rtf_nrow")
  } else {
    table_nrow <- attr(cell_tbl, "cell_nrow")
  }

  rtf_nrow_body <- rtf_nrow
  if(page$page_title != "all") rtf_nrow_body$title <- 0
  if(page$page_footnote != "all") rtf_nrow_body$footnote <- 0
  if(page$page_source != "all") rtf_nrow_body$source <- 0

  # Page Dictionary
  page_dict <- data.frame(
    index = index,
    nrow = table_nrow,
    total     = rtf_nrow$page - sum(rtf_nrow_body[-1])
  )

  # Define page number for each row
  page_dict_page <- function(page_dict) {
    # Page Number
    page <- cumsum(page_dict$nrow) %/% page_dict$total

    page + 1
  }

  if(! is.null(attr(tbl, "rtf_by_subline")$id)){
    page_dict$id <- attr(tbl, "rtf_by_subline")$id
    page_dict$subline <- attr(tbl, "rtf_by_subline")$id
    page_dict$page <- unlist(lapply(split(page_dict, page_dict$id), page_dict_page))
    page_dict$page <- as.numeric(page_dict$id) * 1e6 + page_dict$page

  }else{
    page_dict$page <- with(page_dict, cumsum(nrow) %/% total) + 1
  }

  # Move to next page for footnote and data source
  total_all = rtf_nrow$page - sum(rtf_nrow[-1])
  if( sum(page_dict$nrow[page_dict$page == tail(page_dict$page,1)]) > total_all){
    page_dict$page[c(-2:0) + nrow(page_dict)] <- page_dict$page[c(-2:0) + nrow(page_dict)] + 1
  }

  # Remove repeated records if group_by is not null
  if (!is.null(group_by)) {
    cell_tbl <- rtf_group_by_enhance(cell_tbl,
      group_by = group_by,
      page_index = page_dict$page
    )
  }

  # Add border type for first and last row
  page_dict_first <- do.call(rbind, lapply(split(page_dict, page_dict$page), function(x) x[1, ]))
  page_dict_last <- do.call(rbind, lapply(split(page_dict, page_dict$page), function(x) x[nrow(x), ]))

  if (!is.null(attr(cell_tbl, "border_first"))) {
    attr(cell_tbl, "border_top")[page_dict_first$index, ] <- attr(cell_tbl, "border_first")[page_dict_first$index, ]
  }

  if (!is.null(attr(cell_tbl, "border_last"))) {
    attr(cell_tbl, "border_bottom")[page_dict_last$index, ] <- attr(cell_tbl, "border_last")[page_dict_last$index, ]
  }

  if (!is.null(attr(cell_tbl, "border_color_first"))) {
    attr(cell_tbl, "border_color_top")[page_dict_first$index, ] <- attr(cell_tbl, "border_color_first")[page_dict_first$index, ]
  }

  if (!is.null(attr(cell_tbl, "border_color_last"))) {
    attr(cell_tbl, "border_color_bottom")[page_dict_last$index, ] <- attr(cell_tbl, "border_color_last")[page_dict_last$index, ]
  }

  # RTF encode
  rtf_table <- rtf_table_content(cell_tbl,
    col_total_width = col_width,
    use_border_bottom = TRUE
  )

  rtf <- apply(rtf_table, 2, paste, collapse = "\n")

  attr(rtf, "info") <- page_dict
  rtf
}
