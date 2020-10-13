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

#' Derive Space Adjustment
#'
#' @param tbl A data frame
#'
#' @return a value indicating the amount of space adjustment
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Collect page width, page margins and table width attributes from `tbl` object.
#'    \item Convert the attributes from inch to twip using 'inch_to_twip()'.
#'    \item Derive the adjusted space by discounting page margins and table width from page width, then divided by 2.
#'    \item Set the adjusted space to 0 if previous derivation returns to negative value.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
footnote_source_space <- function(tbl) {

  page <- attr(tbl, "page")
  page_width <- inch_to_twip(page$width)
  page_margin <- inch_to_twip(page$margin)

  table_width <- inch_to_twip(page$col_width)

  left_margin  <- page_margin[1]
  right_margin <- page_margin[2]

  space_adjust <- round((page_width - left_margin - right_margin - table_width) / 2)

  max(0, space_adjust)
}
