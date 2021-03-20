
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
#'
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


  # Get number of row for each entry
  rtf_nrow <- data.frame(
    page = attr(tbl, "page")$nrow,
    title = ifelse(is.null(attr(tbl, "rtf_title")), 0, length(attr(tbl, "rtf_title"))),
    subline = ifelse(is.null(attr(tbl, "rtf_subline")), 0, length(attr(tbl, "rtf_subline"))),
    col_header = ifelse(is.null(attr(tbl, "rtf_colheader")), 0, length(attr(tbl, "rtf_colheader"))),
    footnote = ifelse(is.null(attr(tbl, "rtf_footnote")), 0, length(attr(tbl, "rtf_footnote"))),
    source = ifelse(is.null(attr(tbl, "rtf_source")), 0, length(attr(tbl, "rtf_source")))
  )

  # tbl attributes
  group_by <- attr(tbl, "rtf_groupby")
  col_width <- attr(tbl, "page")$col_width

  # Number of rows in cells based on column size
  if (is.null(attr(tbl, "rtf_pageby_table"))) {
    cell_tbl <- tbl
  } else {
    cell_tbl <- attr(tbl, "rtf_pageby_table")
  }

  index <- 1:nrow(cell_tbl)

  ## actual column width
  width <- col_width * attr(cell_tbl, "col_rel_width") / sum(attr(cell_tbl, "col_rel_width"))
  width <- matrix(width, nrow = nrow(cell_tbl), ncol = ncol(cell_tbl), byrow = TRUE)

  ## text font size is 1/72 inch height
  ## default font height and width ratio is 1.65
  if (is.null(attr(tbl, "cell_nrow"))) {
    cell_nrow <- apply(cell_tbl, 2, nchar) * attr(cell_tbl, "text_font_size") / width / 72 / 1.65
  } else {
    cell_nrow <- attr(tbl, "cell_nrow")
  }

  ##  maximum num of rows in cells per line
  table_nrow <- ceiling(apply(cell_nrow, 1, max))
  table_nrow <- ifelse(is.na(table_nrow), 0, table_nrow)

  # Page Dictionary
  page_dict <- data.frame(
    index = index,
    nrow = table_nrow,
    total = rtf_nrow$page - sum(rtf_nrow[-1])
  )
  page_dict$page <- with(page_dict, cumsum(nrow) %/% total) + 1

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
    attr(cell_tbl, "border_color_bottom")[page_dict_first$index, ] <- attr(cell_tbl, "border_color_last")[page_dict_first$index, ]
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
