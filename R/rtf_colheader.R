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

#' @title Add Column Header Attributes to Table
#'
#' @param tbl A data frame.
#' @param colheader A character string that uses " | " to separate column names. Default is NULL for a blank column header.
#' @param col_rel_width A Column relative width in a vector e.g. c(2,1,1) refers to 2:1:1.
#'                      Default is NULL for equal column width.
#' @inheritParams rtf_footnote
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Input checks using \code{check_args()}, \code{match_arg()} and \code{stopifnot()}. The required argument is \code{tbl}, i.e. A data frame must define by \code{tbl}.
#'    \item Set default page attributes and register use_color attribute.
#'    \item Define column header attributes of \code{tbl} based on the input.
#'    \item Return \code{tbl}.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @return The same data frame \code{tbl} with additional attributes for table column header.
#'
#' @examples
#' library(dplyr) # required to run examples
#' data(r2rtf_tbl1)
#' r2rtf_tbl1 %>%
#'   rtf_colheader(
#'     colheader = "Treatment | N | Mean (SD) | N | Mean (SD) | N |
#'                   Mean (SD) | LS Mean (95% CI)\\dagger",
#'     text_format = c("b", "", "u", "", "u", "", "u", "i")
#'   ) %>%
#'   attr("rtf_colheader")
#' @export
rtf_colheader <- function(tbl,

                          colheader = NULL,
                          col_rel_width = NULL,

                          border_left = "single",
                          border_right = "single",
                          border_top = "single",
                          border_bottom = "",

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

                          text_space = 1,
                          text_space_before = 15,
                          text_space_after = 15,

                          text_convert = TRUE) {

  # Check argument type
  check_args(tbl, type = c("data.frame"))

  check_args(colheader, type = c("character"))
  check_args(col_rel_width, type = c("integer", "numeric"))

  # Set Default Page Attributes
  if (is.null(attr(tbl, "page"))) {
    tbl <- rtf_page(tbl)
  }

  # Return NULL if colheader is NULL
  if (is.null(colheader)) {
    return(tbl)
  }
  if (colheader == "") {
    return(tbl)
  }

  # Split input by "|".
  colheader <- data.frame(t(trimws(unlist(strsplit(colheader, "|", fixed = TRUE)))))

  # Define text attributes
  colheader <- obj_rtf_text(colheader,

    text_font,
    text_format,
    text_font_size,
    text_color,
    text_background_color,
    text_justification,

    text_indent_first,
    text_indent_left,
    text_indent_right,
    text_space = 1,
    text_space_before,
    text_space_after,

    text_new_page = FALSE,
    text_hyphenation = TRUE,

    text_convert = text_convert
  )
  if (attr(colheader, "use_color")) attr(tbl, "page")$use_color <- TRUE

  # Define border attributes
  colheader <- obj_rtf_border(colheader,

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

  if (attr(colheader, "use_color")) attr(tbl, "page")$use_color <- TRUE

  # Set default value for column relative width
  if (is.null(col_rel_width)) {
    col_rel_width <- rep(1, ncol(colheader))
  }

  # Define column relative width attribute
  attr(colheader, "col_rel_width") <- col_rel_width

  # Define a list for column header
  if (is.null(attr(tbl, "rtf_colheader"))) {
    attr(tbl, "rtf_colheader") <- list()
  }

  attr(tbl, "rtf_colheader")[[length(attr(tbl, "rtf_colheader")) + 1]] <- colheader

  tbl
}
