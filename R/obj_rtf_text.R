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

#' Create an RTF Text Object
#'
#' @inheritParams rtf_footnote
#' @param text A character string.
#' @param text_new_page A logical value to control whether display text in new page.
#' @param text_hyphenation A logical value to control whether display text linked with hyphenation.
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Input checks using \code{check_args()}, \code{match_arg()} and \code{stopifnot()}.
#'    \item Define text attributes based on the input.
#'    \item Return text with attributes.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @return the same text (data frame or text) with additional attributes
#'
#' @importFrom grDevices colors
obj_rtf_text <- function(text,
                         text_font = 1,
                         text_format = NULL,
                         text_font_size = 9,
                         text_color = NULL,
                         text_background_color = NULL,
                         text_justification = "l",
                         text_indent_first = 0,
                         text_indent_left = 0,
                         text_indent_right = 0,
                         text_space = 1,
                         text_space_before = 15,
                         text_space_after = 15,
                         text_new_page = FALSE,
                         text_hyphenation = TRUE,
                         text_convert = TRUE) {

  # Check argument type
  check_args(text, type = c("character", "data.frame"))

  check_args(text_font, type = c("integer", "numeric"))
  check_args(text_format, type = c("character"))
  check_args(text_font_size, type = c("integer", "numeric"))

  check_args(text_color, type = c("character"))
  check_args(text_background_color, type = c("character"))
  check_args(text_justification, type = c("character"))

  check_args(text_space_before, type = c("integer", "numeric"))
  check_args(text_space_after, type = c("integer", "numeric"))

  check_args(text_new_page, type = c("logical"))
  check_args(text_hyphenation, type = c("logical"))
  check_args(text_convert, type = c("logical"))

  stopifnot(c(text_font) %in% font_type()$type)

  # Validate argument value
  if (!is.null(text_format)) {
    match_arg(unlist(strsplit(text_format, "")), font_format()$type, several.ok = TRUE)
  }

  stopifnot(text_font_size > 0)

  match_arg(text_color, colors(), several.ok = TRUE)
  match_arg(text_background_color, colors(), several.ok = TRUE)
  match_arg(text_justification, justification()$type, several.ok = TRUE)

  # If text is a data.frame or matrix
  # Transfer attributes vector to matrix by row
  if (!is.null(dim(text))) {
    n_row <- nrow(text)
    n_col <- ncol(text)

    foo <- function(x) {
      if ((is.null(dim(x))) & (!is.null(x))) {
        if (!length(x) %in% c(1, n_col, n_col * n_row)) {
          warning("The input is not a single value, with length equal to number of columns or a matrix with same dimension of the table.")
        }

        stopifnot(length(x) %in% c(1, n_col) | all(dim(x) == c(n_row, n_col)))
        x <- matrix(x, nrow = n_row, ncol = n_col, byrow = TRUE)
      }
      x
    }
  } else {
    l <- length(text)
    foo <- function(x) {
      if (!is.null(x)) rep(x, length.out = l)
    }
  }

  text_font <- foo(text_font)
  text_format <- foo(text_format)
  text_font_size <- foo(text_font_size)

  text_color <- foo(text_color)
  text_background_color <- foo(text_background_color)
  text_justification <- foo(text_justification)

  text_convert <- foo(text_convert)

  text_indent_first <- foo(text_indent_first)
  text_indent_left <- foo(text_indent_left)
  text_indent_right <- foo(text_indent_right)

  # Add attributes

  attr(text, "text_font") <- text_font
  attr(text, "text_format") <- text_format
  attr(text, "text_font_size") <- text_font_size

  attr(text, "text_color") <- text_color
  attr(text, "text_background_color") <- text_background_color
  attr(text, "text_justification") <- text_justification

  attr(text, "text_space") <- text_space
  attr(text, "text_space_before") <- text_space_before
  attr(text, "text_space_after") <- text_space_after

  attr(text, "text_indent_first") <- text_indent_first
  attr(text, "text_indent_left") <- text_indent_left
  attr(text, "text_indent_right") <- text_indent_right

  attr(text, "text_new_page") <- text_new_page
  attr(text, "text_hyphenation") <- text_hyphenation
  attr(text, "text_convert") <- text_convert
  attr(text, "strwidth") <- rtf_strwidth(text)

  # Register Color Use
  color <- list(text_color, text_background_color)
  if (!all(unlist(color) %in% c("black", ""))) {
    attr(text, "use_color") <- TRUE
  } else {
    attr(text, "use_color") <- FALSE
  }

  # Define Class
  class(text) <- c(class(text), "rtf_text")

  text
}
