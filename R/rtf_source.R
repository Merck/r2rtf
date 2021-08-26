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

#' @title Add Data Source Attributes to the Table
#'
#' @param source A character string.
#' @inheritParams rtf_footnote
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Define data source attributes of \code{tbl} based on the input.
#'    \item Return \code{tbl}.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @return the same data frame \code{tbl} with additional attributes for data source of a table
#'
#' @examples
#' library(dplyr) # required to run examples
#' data(r2rtf_tbl1)
#' r2rtf_tbl1 %>%
#'   rtf_source("Source: [study999:adam-adeff]") %>%
#'   attr("rtf_source")
#' @export
rtf_source <- function(tbl,
                       source = "",
                       border_left = "single",
                       border_right = "single",
                       border_top = "",
                       border_bottom = "single",
                       border_color_left = NULL,
                       border_color_right = NULL,
                       border_color_top = NULL,
                       border_color_bottom = NULL,
                       border_width = 15,
                       cell_height = 0.15,
                       cell_justification = "c",
                       cell_nrow = NULL,
                       text_font = 1,
                       text_format = NULL,
                       text_font_size = 9,
                       text_color = NULL,
                       text_background_color = NULL,
                       text_justification = "c",
                       text_indent_first = 0,
                       text_indent_left = 0,
                       text_indent_right = 0,
                       text_indent_reference = "table",
                       text_space = 1,
                       text_space_before = 15,
                       text_space_after = 15,
                       text_convert = TRUE,
                       as_table = FALSE) {


  # Check argument type
  check_args(source, type = "character")
  check_args(as_table, type = "logical")

  # Convert tbl to a data frame, each column is a character
  if (any(class(tbl) %in% "data.frame")) tbl <- as.data.frame(tbl, stringsAsFactors = FALSE)

  # Define proper justification reference
  if (text_justification == "l" & (!as_table)) {
    text_indent_left <- text_indent_left + footnote_source_space(tbl, text_indent_reference)
  }

  if (text_justification == "r" & (!as_table)) {
    text_indent_right <- text_indent_right + footnote_source_space(tbl, text_indent_reference)
  }

  # Set Default Page Attributes
  if (is.null(attr(tbl, "page"))) {
    tbl <- rtf_page(tbl)
  }

  # Define text object
  source <- obj_rtf_text(source,
    text_font,
    text_format,
    text_font_size,
    text_color,
    text_background_color,
    text_justification,
    text_indent_first,
    text_indent_left,
    text_indent_right,
    text_space,
    text_space_before,
    text_space_after,
    text_new_page = FALSE,
    text_hyphenation = TRUE,
    text_convert = text_convert
  )

  if (attr(source, "use_color")) attr(tbl, "page")$use_color <- TRUE

  # Define border object
  if (as_table) {
    source <- obj_rtf_border(source,
      border_left,
      border_right,
      border_top,
      border_bottom,
      border_first = NULL,
      border_last  = NULL,
      border_color_left,
      border_color_right,
      border_color_top,
      border_color_bottom,
      border_color_first = NULL,
      border_color_last  = NULL,
      border_width,
      cell_height,
      cell_justification,
      cell_nrow
    )

    if (attr(source, "use_color")) attr(tbl, "page")$use_color <- TRUE
  }

  attr(source, "as_table") <- as_table
  attr(source, "col_rel_width") <- 1
  attr(tbl, "rtf_source") <- source

  tbl
}
