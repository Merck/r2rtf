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

#' Create an RTF Table Border Object
#'
#' @inheritParams rtf_footnote
#' @inheritParams rtf_page
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Input checks using \code{check_args()}, \code{match_arg()} and \code{stopifnot()}.
#'    \item Define border attributes based on the input.
#'    \item Register use_color attribute.
#'    \item Return \code{tbl} with attributes.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @return the same \code{tbl} with additional border attributes
#'
#' @importFrom grDevices colors
obj_rtf_border <- function(tbl,
                           border_left = "single",
                           border_right = "single",
                           border_top = "",
                           border_bottom = "",
                           border_first = "single",
                           border_last = "single",
                           border_color_left = NULL,
                           border_color_right = NULL,
                           border_color_top = NULL,
                           border_color_bottom = NULL,
                           border_color_first = NULL,
                           border_color_last = NULL,
                           border_width = 15,
                           cell_height = 0.15,
                           cell_justification = "c",
                           cell_vertical_justification = "top",
                           cell_nrow = NULL) {
  # Check argument type
  check_args(border_left, type = c("character"))
  check_args(border_right, type = c("character"))
  check_args(border_top, type = c("character"))
  check_args(border_bottom, type = c("character"))

  check_args(border_color_left, type = c("character"))
  check_args(border_color_right, type = c("character"))
  check_args(border_color_top, type = c("character"))
  check_args(border_color_bottom, type = c("character"))

  check_args(border_width, type = c("integer", "numeric"))

  check_args(cell_height, type = c("integer", "numeric"))
  check_args(cell_justification, type = c("character"))
  check_args(cell_justification, type = c("character"))
  check_args(cell_nrow, type = c("integer", "numeric"))

  # Check argument values
  match_arg(border_left, border_type()$name, several.ok = TRUE)
  match_arg(border_right, border_type()$name, several.ok = TRUE)
  match_arg(border_top, border_type()$name, several.ok = TRUE)
  match_arg(border_bottom, border_type()$name, several.ok = TRUE)

  match_arg(border_color_left, colors(), several.ok = TRUE)
  match_arg(border_color_right, colors(), several.ok = TRUE)
  match_arg(border_color_top, colors(), several.ok = TRUE)
  match_arg(border_color_bottom, colors(), several.ok = TRUE)

  stopifnot(border_width > 0)

  stopifnot(cell_height > 0)
  match_arg(cell_justification, justification()$type, several.ok = TRUE)
  match_arg(cell_vertical_justification, vertical_justification()$type, several.ok = TRUE)

  if (is.null(border_color_top) & !is.null(border_color_first)) {
    stop("border_color_top can not be NULL if border_color_first is used")
  }

  if (is.null(border_color_bottom) & !is.null(border_color_last)) {
    stop("border_color_top can not be NULL if border_color_first is used")
  }

  if (!is.null(attr(tbl, "page")$border_color_first)) {
    border_color_first <- ""
    border_color_top <- ""
  }

  if (!is.null(attr(tbl, "page")$border_color_last)) {
    border_color_last <- ""
    border_color_bottom <- ""
  }


  # Transfer vector to matrix by row
  n_row <- nrow(tbl)
  n_col <- ncol(tbl)

  foo <- function(x) {
    if (is.null(n_row) | is.null(n_col)) {
      stopifnot(length(x) %in% c(0, 1))
      return(x)
    }

    if ((is.null(dim(x))) & (!is.null(x))) {
      if (!length(x) %in% c(1, n_col, n_col * n_row)) {
        warning("The input is not a single value, with length equal to number of columns or a matrix with same dimension of the table.")
      }

      stopifnot(length(x) %in% c(1, n_col) | all(dim(x) == c(n_row, n_col)))
      x <- matrix(x, nrow = n_row, ncol = n_col, byrow = TRUE)
    }
    x
  }

  border_top <- foo(border_top)
  border_left <- foo(border_left)
  border_right <- foo(border_right)
  border_bottom <- foo(border_bottom)

  border_first <- foo(border_first)
  border_last <- foo(border_last)

  border_color_left <- foo(border_color_left)
  border_color_right <- foo(border_color_right)
  border_color_top <- foo(border_color_top)
  border_color_bottom <- foo(border_color_bottom)

  border_color_first <- foo(border_color_first)
  border_color_last <- foo(border_color_last)

  if (!is.null(cell_nrow)) {
    cell_nrow <- rep_len(cell_nrow, length.out = n_row)
  }

  # Add Attributions
  attr(tbl, "border_top") <- border_top
  attr(tbl, "border_left") <- border_left
  attr(tbl, "border_right") <- border_right
  attr(tbl, "border_bottom") <- border_bottom

  attr(tbl, "border_first") <- border_first
  attr(tbl, "border_last") <- border_last

  attr(tbl, "border_color_left") <- border_color_left
  attr(tbl, "border_color_right") <- border_color_right
  attr(tbl, "border_color_top") <- border_color_top
  attr(tbl, "border_color_bottom") <- border_color_bottom

  attr(tbl, "border_color_first") <- border_color_first
  attr(tbl, "border_color_last") <- border_color_last

  attr(tbl, "border_width") <- border_width

  attr(tbl, "cell_height") <- cell_height
  attr(tbl, "cell_justification") <- cell_justification
  attr(tbl, "cell_vertical_justification") <- cell_vertical_justification
  attr(tbl, "cell_nrow") <- cell_nrow

  # Register Color Use
  color <- list(
    border_color_left, border_color_right, border_color_top,
    border_color_bottom, border_color_first, border_color_last
  )

  if (!all(unlist(color) %in% c("black", ""))) {
    attr(tbl, "use_color") <- TRUE
  } else {
    attr(tbl, "use_color") <- FALSE
  }

  # Define Class
  class(tbl) <- c(class(tbl), "rtf_border")

  tbl
}
