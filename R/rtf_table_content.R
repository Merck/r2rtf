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

#' Create RTF Table Body Encode
#'
#' @param tbl A data frame.
#' @param col_total_width Column total width for the table. Default is the corresponding attribute from `tbl`.
#' @param use_border_bottom A logical value of using the bottom border. Default is the corresponding attribute from `tbl`.
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Define table begin and end in RTF syntax.
#'    \item Define cell justification using `justification()` and `vertical_justification`, then covert the cell from inch to twip using `inch_to_twip()` in RTF syntax.
#'    \item Define cell border type using `border_type()` and cell border width in RTF syntax.
#'    \item Define cell border color using `color_table()` in RTF syntax.
#'    \item Define cell background color using input variable text_background_color in RTF syntax.
#'    \item Define cell size using `cell_size()` in RTF syntax.
#'    \item Combine cell component attributes into a single code string.
#'    \item Define cell content in encoded RTF syntax.
#'    \item Check if cell content format is a valid value.
#'    \item Combine cell content and content component attributes into a single code string.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @noRd
rtf_table_content <- function(tbl,
                              col_total_width = attr(tbl, "page")$col_width,
                              use_border_bottom = FALSE) {
  border_left <- attr(tbl, "border_left")
  border_right <- attr(tbl, "border_right")
  border_top <- attr(tbl, "border_top")
  border_bottom <- attr(tbl, "border_bottom")

  border_color_left <- attr(tbl, "border_color_left")
  border_color_right <- attr(tbl, "border_color_right")
  border_color_top <- attr(tbl, "border_color_top")
  border_color_bottom <- attr(tbl, "border_color_bottom")

  border_width <- attr(tbl, "border_width")

  col_rel_width <- attr(tbl, "col_rel_width")
  cell_height <- attr(tbl, "cell_height")
  cell_justification <- attr(tbl, "cell_justification")
  cell_vertical_justification <- attr(tbl, "cell_vertical_justification")

  text_font <- attr(tbl, "text_font")
  text_format <- attr(tbl, "text_format")
  text_color <- attr(tbl, "text_color")
  text_background_color <- attr(tbl, "text_background_color")
  text_justification <- attr(tbl, "text_justification")
  text_font_size <- attr(tbl, "text_font_size")
  text_space <- attr(tbl, "text_space")
  text_space_before <- attr(tbl, "text_space_before")
  text_space_after <- attr(tbl, "text_space_after")

  text_indent_first <- attr(tbl, "text_indent_first")
  text_indent_left <- attr(tbl, "text_indent_left")
  text_indent_right <- attr(tbl, "text_indent_right")



  text_convert <- attr(tbl, "text_convert")

  ## get dimension of tbl
  n_row <- nrow(tbl)
  n_col <- ncol(tbl)

  ## Ensure Missing value display nothing
  for (i in 1:n_col) {
    tbl[, i] <- ifelse(is.na(tbl[, i]), "", as.character(tbl[, i]))
  }

  ## Transfer vector to matrix by row
  foo <- function(x) {
    if ((is.null(dim(x))) & (!is.null(x))) {
      x <- matrix(x, nrow = n_row, ncol = n_col, byrow = TRUE)
    }
    x
  }

  # Encoding RTF Cell Justification
  justification <- justification()
  cell_justification_rtf <- factor(cell_justification, levels = justification$type, labels = justification$rtf_code_row)

  vertical_justification <- vertical_justification()
  cell_vertical_justification <- factor(cell_vertical_justification, levels = vertical_justification$type, labels = vertical_justification$rtf_code)

  cell_height <- round(inch_to_twip(cell_height) / 2, 0)

  # rtf code for table begin and end
  row_begin <- paste0("\\trowd\\trgaph", cell_height, "\\trleft0", cell_justification_rtf)
  row_end <- "\\intbl\\row\\pard"

  # Encoding RTF Cell Border type and width
  border_lrtb <- c("\\clbrdrl", "\\clbrdrr", "\\clbrdrt", "\\clbrdrb")
  names(border_lrtb) <- c("left", "right", "top", "bottom")
  border_wid <- paste0("\\brdrw", border_width)

  ## cell border type
  border_type <- border_type()
  border_left_rtf <- factor(border_left, levels = border_type$name, labels = border_type$rtf_code)
  border_right_rtf <- factor(border_right, levels = border_type$name, labels = border_type$rtf_code)
  border_top_rtf <- factor(border_top, levels = border_type$name, labels = border_type$rtf_code)
  border_bottom_rtf <- factor(border_bottom, levels = border_type$name, labels = border_type$rtf_code)

  border_left_rtf <- paste0(border_lrtb["left"], border_left_rtf, border_wid)
  border_right_rtf <- paste0(border_lrtb["right"], border_right_rtf, border_wid)
  border_top_rtf <- paste0(border_lrtb["top"], border_top_rtf, border_wid)
  border_bottom_rtf <- paste0(border_lrtb["bottom"], border_bottom_rtf, border_wid)

  ## Encoding RTF Cell Border color
  col_tb <- color_table()

  if (!is.null(border_color_left)) {
    border_color_left_rtf <- factor(border_color_left, levels = col_tb$color, labels = col_tb$type)
    border_color_left_rtf <- paste0("\\brdrcf", border_color_left_rtf)
    border_left_rtf <- paste0(border_left_rtf, border_color_left_rtf)
  }

  if (!is.null(border_color_right)) {
    border_color_right_rtf <- factor(border_color_right, levels = col_tb$color, labels = col_tb$type)
    border_color_right_rtf <- paste0("\\brdrcf", border_color_right_rtf)
    border_right_rtf <- paste0(border_right_rtf, border_color_right_rtf)
  }

  if (!is.null(border_color_top)) {
    border_color_top_rtf <- factor(border_color_top, levels = col_tb$color, labels = col_tb$type)
    border_color_top_rtf <- paste0("\\brdrcf", border_color_top_rtf)
    border_top_rtf <- paste0(border_top_rtf, border_color_top_rtf)
  }

  if (!is.null(border_color_bottom)) {
    border_color_bottom_rtf <- factor(border_color_bottom, levels = col_tb$color)
    levels(border_color_bottom_rtf) <- col_tb$type
    border_color_bottom_rtf <- paste0("\\brdrcf", border_color_bottom_rtf)
    border_bottom_rtf <- paste0(border_bottom_rtf, border_color_bottom_rtf)
  }

  ## Cell Background Color
  if (!is.null(text_background_color)) {
    text_background_color_rtf <- factor(text_background_color, levels = col_tb$color)
    levels(text_background_color_rtf) <- col_tb$type
    text_background_color_rtf <- paste0("\\clcbpat", text_background_color_rtf)
  } else {
    text_background_color_rtf <- NULL
  }

  # Cell Size
  cell_width <- cell_size(col_rel_width, col_total_width)
  cell_size <- cumsum(cell_width)
  cell_size <- foo(cell_size)

  # Combine Cell Attributes of cell justification, cell border type, cell border width, cell border color, cell background color and cell size.
  border_top_left <- matrix(paste0(border_left_rtf, border_top_rtf, text_background_color_rtf, cell_vertical_justification, "\\cellx", cell_size), nrow = n_row, ncol = n_col)
  border_top_left_right <- matrix(paste0(border_left_rtf, border_top_rtf, border_right_rtf, text_background_color_rtf, cell_vertical_justification, "\\cellx", cell_size), nrow = n_row, ncol = n_col)
  border_top_left_bottom <- matrix(paste0(border_left_rtf, border_top_rtf, border_bottom_rtf, text_background_color_rtf, cell_vertical_justification, "\\cellx", cell_size), nrow = n_row, ncol = n_col)
  border_all <- matrix(paste0(border_left_rtf, border_top_rtf, border_right_rtf, border_bottom_rtf, text_background_color_rtf, cell_vertical_justification, "\\cellx", cell_size), nrow = n_row, ncol = n_col)

  if (use_border_bottom) {
    border_rtf <- border_top_left_bottom
    border_rtf[, n_col] <- border_all[, n_col]
  } else {
    border_rtf <- border_top_left
    border_rtf[, n_col] <- border_top_left_right[, n_col]
  }

  border_rtf <- t(border_rtf)

  # Encode RTF Text and Paragraph
  # Get use_i18n flag from page attributes
  use_i18n <- attr(tbl, "page")$use_i18n %||% FALSE

  text_rtf <- rtf_text(tbl,
    font = text_font,
    font_size = text_font_size,
    format = text_format,
    color = text_color,
    background_color = text_background_color,
    text_convert = text_convert,
    use_i18n = use_i18n
  )

  cell_rtf <- rtf_paragraph(text_rtf,
    justification = text_justification,
    indent_first = text_indent_first,
    indent_left = text_indent_left,
    indent_right = text_indent_right,
    space = text_space,
    space_before = text_space_before,
    space_after = text_space_after,
    new_page = FALSE,
    hyphenation = FALSE,
    cell = TRUE
  )

  rbind(row_begin, border_rtf, t(cell_rtf), row_end)
}
