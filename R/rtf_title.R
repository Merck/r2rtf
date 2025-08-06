#    Copyright (c) 2022 Merck & Co., Inc., Rahway, NJ, USA and its affiliates. All rights reserved.
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

#' @title Add Title Attributes to Table
#'
#' @description
#' Add title, subtitle, and other attributes to the object
#'
#' @param tbl A data frame.
#' @param title Title in a character string.
#' @param subtitle Subtitle in a character string.
#' @param text_hyphenation A logical value to control whether display text linked with hyphenation.
#' @inheritParams rtf_footnote
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Input checks using \code{check_args()}, \code{match_arg()} and \code{stopifnot()}. The required argument is \code{tbl}, i.e. A data frame must define by \code{tbl}.
#'    \item Set default page attributes and register use_color attribute.
#'    \item Define title attributes of \code{tbl} based on the input.
#'    \item Return \code{tbl}.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @return the same data frame \code{tbl} with additional attributes for table title
#'
#' @examples
#' library(dplyr) # required to run examples
#' data(r2rtf_tbl1)
#' r2rtf_tbl1 %>%
#'   rtf_title(title = "ANCOVA of Change from Baseline at Week 8") %>%
#'   attr("rtf_title")
#' @export
rtf_title <- function(tbl,
                      title = NULL,
                      subtitle = NULL,
                      text_font = 1,
                      text_format = NULL,
                      text_font_size = 12,
                      text_color = NULL,
                      text_background_color = NULL,
                      text_justification = "c",
                      text_indent_first = 0,
                      text_indent_left = 0,
                      text_indent_right = 0,
                      text_indent_reference = "table",
                      text_space = 1,
                      text_space_before = 180,
                      text_space_after = 180,
                      text_hyphenation = TRUE,
                      text_convert = TRUE) {
  # check argument types
  check_args(title, type = c("character"))
  check_args(subtitle, type = c("character"))
  text <- unlist(c(title, subtitle))

  # Convert tbl to a data frame, each column is a character
  if (any(class(tbl) %in% "data.frame")) tbl <- as.data.frame(tbl, stringsAsFactors = FALSE)

  # Set Default Page Attributes
  if (is.null(attr(tbl, "page"))) {
    tbl <- rtf_page(tbl)
  }

  text_indent_left <- ifelse(text_justification == "l",
    text_indent_left + footnote_source_space(tbl, text_indent_reference),
    text_indent_left
  )

  text_indent_right <- ifelse(text_justification == "r",
    text_indent_right + footnote_source_space(tbl, text_indent_reference),
    text_indent_right
  )

  # Get use_i18n from page attributes
  use_i18n <- attr(tbl, "page")$use_i18n %||% FALSE
  
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
    text_new_page = FALSE,
    text_hyphenation = text_hyphenation,
    text_convert = text_convert,
    use_i18n = use_i18n
  )

  # Register Color Use
  if (attr(text, "use_color")) attr(tbl, "page")$use_color <- TRUE

  attr(tbl, "rtf_title") <- text

  tbl
}


#' @title Add Subline Attributes to Table
#'
#' @description
#' Add subline attributes to the object
#'
#' @param tbl A data frame.
#' @param text A character vector of subline
#' @param text_hyphenation A logical value to control whether display text linked with hyphenation.
#' @inheritParams rtf_footnote
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Define title attributes of \code{tbl} based on the input.
#'    \item Return \code{tbl}.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @return the same data frame \code{tbl} with additional attributes for table title
#'
#' @export
rtf_subline <- function(tbl,
                        text,
                        text_font = 1,
                        text_format = NULL,
                        text_font_size = 12,
                        text_color = NULL,
                        text_background_color = NULL,
                        text_justification = "l",
                        text_indent_first = 0,
                        text_indent_left = 0,
                        text_indent_right = 0,
                        text_indent_reference = "table",
                        text_space = 1,
                        text_space_before = 180,
                        text_space_after = 180,
                        text_hyphenation = TRUE,
                        text_convert = TRUE) {
  # Input checking
  check_args(text, type = c("character"))

  # Convert tbl to a data frame, each column is a character
  if (any(class(tbl) %in% "data.frame")) tbl <- as.data.frame(tbl, stringsAsFactors = FALSE)

  # Set Default Page Attributes
  if (is.null(attr(tbl, "page"))) {
    tbl <- rtf_page(tbl)
  }

  if (text_justification == "l") {
    text_indent_left <- text_indent_left + footnote_source_space(tbl, text_indent_reference)
  }

  if (text_justification == "r") {
    text_indent_right <- text_indent_right + footnote_source_space(tbl, text_indent_reference)
  }

  # Get use_i18n from page attributes
  use_i18n <- attr(tbl, "page")$use_i18n %||% FALSE
  
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
    text_new_page = FALSE,
    text_hyphenation = text_hyphenation,
    text_convert = text_convert,
    use_i18n = use_i18n
  )

  # Register Color Use
  if (attr(text, "use_color")) attr(tbl, "page")$use_color <- TRUE

  attr(tbl, "rtf_subline") <- text

  tbl
}
