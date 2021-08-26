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

#' @title Add Footnote Attributes to Table
#'
#' @param tbl A data frame.
#' @param footnote A vector of character for footnote text.
#' @param border_left Left border type. To vary left border by column, use
#'                    character vector with length of vector equal to number of columns displayed
#'                    e.g. c("single","single","single"). All possible input can be found in
#'                    `r2rtf:::border_type()$name`.
#' @param border_right Right border type. To vary right border by column, use
#'                     character vector with length of vector equal to number of columns displayed
#'                     e.g. c("single","single","single"). All possible input can be found in
#'                     `r2rtf:::border_type()$name`.
#' @param border_top Top border type. To vary top border by column, use
#'                   character vector with length of vector equal to number of columns displayed
#'                   e.g. c("single","single","single"). If it is the first row in a table for this
#'                   page, the top border is set to "double" otherwise the border is set to "single".
#'                   All possible input can be found in `r2rtf:::border_type()$name`.
#' @param border_bottom Bottom border type.
#'                      To vary bottom border by column, use character vector with length of vector
#'                      equal to number of columns displayed e.g. c("single","single","single").
#'                      All possible input can be found in `r2rtf:::border_type()$name`.
#' @param border_color_left Left border color type. Default is NULL for black. To vary left
#'                          border color by column, use character vector with length of vector
#'                          equal to number of columns displayed e.g. c("white","red","blue").
#'                          All possible input can be found in `grDevices::colors()`.
#' @param border_color_right Right border color type. Default is NULL for black. To vary right
#'                           border color by column, use character vector with length of vector
#'                           equal to number of columns displayed e.g. c("white","red","blue").
#'                           All possible input can be found in `grDevices::colors()`.
#' @param border_color_top Top border color type. Default is NULL for black. To vary top
#'                         border color by column, use character vector with length of vector
#'                         equal to number of columns displayed e.g. c("white","red","blue").
#'                         All possible input can be found in `grDevices::colors()`.
#' @param border_color_bottom Bottom border color type. Default is NULL for black. To vary bottom
#'                            border color by column, use character vector with length of vector
#'                            equal to number of columns displayed e.g. c("white","red","blue").
#'                            All possible input can be found in `grDevices::colors()`.
#' @param border_width Border width in twips. Default is 15 for 0.0104 inch.
#' @param cell_justification Justification type for cell. Default is "c" for center justification.
#'                           All possible input can be found in `r2rtf:::justification()$type`.
#' @param cell_height Cell height in inches. Default is 0.15 for 0.15 inch.
#' @param cell_nrow Number of rows required in each cell.
#' @param text_justification Justification type for text. Default is "c" for center justification.
#'                           To vary text justification by column, use character vector with
#'                           length of vector equal to number of columns displayed e.g. c("c","l","r").
#'                           All possible input can be found in `r2rtf:::justification()$type`.
#' @param text_font Text font type. Default is 1 for Times New Roman. To vary text font type
#'                  by column, use numeric vector with length of vector equal to number of
#'                  columns displayed e.g. c(1,2,3).All possible input can be found
#'                  in `r2rtf:::font_type()$type`.
#' @param text_font_size Text font size.  To vary text font size by column, use
#'                       numeric vector with length of vector equal to number of columns
#'                       displayed e.g. c(9,20,40).
#' @param text_format Text format type. Default is NULL for normal. Combination of format type
#'                    are permitted as input for e.g. "ub" for bold and underlined text. To vary
#'                    text format by column, use character vector with length of vector equal to
#'                    number of columns displayed e.g. c("i","u","ib"). All possible input
#'                    can be found in `r2rtf:::font_format()$type`.
#' @param text_color Text color type. Default is NULL for black. To vary text color by column,
#'                   use character vector with length of vector equal to number of columns
#'                   displayed e.g. c("white","red","blue"). All possible input can be found
#'                   in `grDevices::colors()`.
#' @param text_background_color Text background color type. Default is NULL for white. To vary
#'                              text color by column, use character vector with length of vector
#'                              equal to number of columns displayed e.g. c("white","red","blue").
#'                              All possible input can be found in `grDevices::colors()`.
#' @param text_indent_first A value of text indent in first line.
#' @param text_indent_left  A value of text left indent.
#' @param text_indent_right A value of text right indent.
#' @param text_indent_reference The reference start point of text indent. Accept `table` or `page_margin`
#' @param text_space Line space between paragraph in twips. Default is 0.
#' @param text_space_before Line space before a paragraph in twips.
#' @param text_space_after Line space after a paragraph in twips.
#' @param as_table A logical value to display it as a table.
#' @param text_convert A logical value to convert special characters.
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Define footnote attributes of \code{tbl} based on the input.
#'    \item Return \code{tbl}.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @return the same data frame \code{tbl} with additional attributes for table footnote
#'
#' @examples
#' library(dplyr) # required to run examples
#' data(r2rtf_tbl1)
#' r2rtf_tbl1 %>%
#'   rtf_footnote("\\dagger Based on an ANCOVA model.") %>%
#'   attr("rtf_footnote")
#' @export
rtf_footnote <- function(tbl,
                         footnote = "",
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
                         text_justification = "l",
                         text_indent_first = 0,
                         text_indent_left = 0,
                         text_indent_right = 0,
                         text_indent_reference = "table",
                         text_space = 1,
                         text_space_before = 15,
                         text_space_after = 15,
                         text_convert = TRUE,
                         as_table = TRUE) {

  # Check argument type
  check_args(footnote, type = "character")
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
  footnote <- obj_rtf_text(footnote,
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

  if (attr(footnote, "use_color")) attr(tbl, "page")$use_color <- TRUE

  # Define border object
  if (as_table) {
    footnote <- obj_rtf_border(footnote,
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

    if (attr(footnote, "use_color")) attr(tbl, "page")$use_color <- TRUE
  }

  attr(footnote, "as_table") <- as_table
  attr(footnote, "col_rel_width") <- 1
  attr(tbl, "rtf_footnote") <- footnote

  tbl
}
