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

#' Add RTF File Page Information
#'
#' @param tbl a data frame
#' @param orientation page orientation
#' @param width a numeric value of page width in inches.
#'              Default is 8.5 inch in portrait orientation or 11.0 inch in landscape orientation.
#' @param height a numeric value of page width in inches.
#'               Default is 11.0 inch in portrait orientation or 8.5 inch in landscape orientation.
#' @param margin a numeric vector of length 6 for page margin. The value set left, right, top, bottom, header and footer
#'               margin in order. Default value depends on the page orientation and set by `r2rtf:::set_margin("wma", orientation)`
#' @param nrow   number of rows in each page. Default is 42 rows if portrait orientation
#'                 and 26 rows in landscape orientation.
#' @param border_first First top border type of the whole table. Default is "double" indicating double line bottom border.
#'                      All possible input can be found in `r2rtf:::border_type()$name`.
#' @param border_last  Last bottom border type of the whole table. Default is "double" indicating double line bottom border.
#'                      All possible input can be found in `r2rtf:::border_type()$name`.
#' @param border_color_first First top border color type of the whole table. Default is NULL for black.
#'                         All possible input can be found in `grDevices::colors()`.
#' @param border_color_last Last bottom border color type of the whole table. Default is NULL for black.
#'                            All possible input can be found in `grDevices::colors()`.
#' @param col_width A numeric value of total column width in inch. Default is `width - ifelse(orientation == "portrait", 2, 2.5)`
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'
#'    \item Check if all argument types and values are valid inputs.
#'    \item Add attributes to `tbl` based on the inputs.
#'    \item Register the use of color in page attributes.
#'    \item Return to `tbl` with page attributes.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @return the same data frame \code{tbl} with additional attributes for page features
#'
#' @examples
#' library(dplyr) # required to run examples
#' data(tbl_1)
#' tbl_1 %>% rtf_page() %>% attr("page")
#'
#' @export
rtf_page <- function(tbl,
                     orientation = "portrait",
                     width  = ifelse(orientation == "portrait", 8.5, 11),
                     height = ifelse(orientation == "portrait", 11, 8.5),
                     margin = set_margin("wma", orientation),
                     nrow   = ifelse(orientation == "portrait", 40, 28),

                     border_first = "double",
                     border_last  = "double",

                     border_color_first = NULL,
                     border_color_last  = NULL,

                     col_width = width - ifelse(orientation == "portrait", 2.25, 2.5)
                     ){


  # Check argument type
  check_args(width ,      type = c("integer", "numeric"), length = 1)
  check_args(height,      type = c("integer", "numeric"), length = 1)
  check_args(orientation, type = c("character"), length = 1)
  check_args(margin,      type = c("integer", "numeric"), length = 6)
  check_args(nrow,        type = c("integer", "numeric"), length = 1)
  check_args(col_width,   type = c("integer", "numeric"), length = 1)

  # Check argument values
  stopifnot(width > 0)
  stopifnot(height > 0)
  stopifnot( all(margin > 0) )
  match.arg(orientation, c("portrait", "landscape"))
  stopifnot(nrow > 0)
  stopifnot(col_width > 0)

  # Add attributes
  attr(tbl, "page")$width         <- width
  attr(tbl, "page")$height        <- height
  attr(tbl, "page")$orientation   <- orientation
  attr(tbl, "page")$margin        <- margin
  attr(tbl, "page")$nrow          <- nrow
  attr(tbl, "page")$col_width     <- col_width

  attr(tbl, "page")$border_first  <- border_first
  attr(tbl, "page")$border_last   <- border_last

  attr(tbl, "page")$border_color_first <- border_color_first
  attr(tbl, "page")$border_color_last  <- border_color_last


  # Register Color Use
  color <- list(border_color_first, border_color_last)
  if( ! all( unlist(color) %in% c("black", "") )){
    attr(tbl, "page")$use_color <- TRUE
  }else{
    attr(tbl, "page")$use_color  <- FALSE
  }

  tbl

}

#' Add RTF Page Header Information
#'
#' @inheritParams rtf_footnote
#' @param text a character string.
#'
#' @export
rtf_page_header <- function(tbl,
                            text = "Page \\chpgn  of {\\field{\\*\\fldinst NUMPAGES }}",

                            text_font = 1,
                            text_format = NULL,
                            text_font_size = 12,
                            text_color = NULL,
                            text_background_color = NULL,
                            text_justification = "r",

                            text_indent_first = 0,
                            text_indent_left = 0,
                            text_indent_right = 0,

                            text_space = 1,
                            text_space_before = 15,
                            text_space_after = 15,

                            text_convert = TRUE){


  text <- obj_rtf_text(text,

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

                       text_new_page = NULL,
                       text_hyphenation = NULL,

                       text_convert = text_convert
  )

  attr(tbl, "rtf_page_header") <- text

  # Set Default Page Attributes
  if(is.null(attr(tbl, "page"))){
    tbl <- rtf_page(tbl)
  }

  # Register Color Use
  if(attr(text, "use_color")) attr(tbl, "page") <- TRUE

  tbl

}

#' Add RTF Page Footer Information
#'
#' @inheritParams rtf_footnote
#' @param text a character string.
#'
#' @export
rtf_page_footer <- function(tbl,
                            text,

                            text_font = 1,
                            text_format = NULL,
                            text_font_size = 12,
                            text_color = NULL,
                            text_background_color = NULL,
                            text_justification = "c",

                            text_indent_first = 0,
                            text_indent_left = 0,
                            text_indent_right = 0,

                            text_space = 1,
                            text_space_before = 15,
                            text_space_after = 15,

                            text_convert = TRUE){


  text <- obj_rtf_text(text,

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

                       text_new_page = NULL,
                       text_hyphenation = NULL,

                       text_convert = text_convert
  )

  attr(tbl, "rtf_page_footer") <- text

  # Set Default Page Attributes
  if(is.null(attr(tbl, "page"))){
    tbl <- rtf_page(tbl)
  }

  # Register Color Use
  if(attr(text, "use_color")) attr(tbl, "page") <- TRUE

  tbl

}



