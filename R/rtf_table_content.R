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

#' Create RTF Table Body Encode
#'
#' @param tbl A data frame
#' @param border_left Left border type. Default is the corresponding attribute from `tbl`.
#' @param border_right Right border type. Default is the corresponding attribute from `tbl`.
#' @param border_top Top border type. Default is the corresponding attribute from `tbl`.
#' @param border_bottom Bottom border type. Default is the corresponding attribute from `tbl`.
#' @param border_color_left Left border color. Default is the corresponding attribute from `tbl`.
#' @param border_color_right Right border color. Default is the corresponding attribute from `tbl`.
#' @param border_color_top Top border color. Default is the corresponding attribute from `tbl`.
#' @param border_color_bottom Bottom border color. Default is the corresponding attribute from `tbl`.
#' @param border_width Border width in twips. Default is the corresponding attribute from `tbl`.
#' @param cell_justification Justification for cell. Default is the corresponding attribute from `tbl`.
#' @param col_rel_width Column relative width in a vector eg. c(2,1,1) refers to 2:1;1
#' @param col_total_width Column total width for the table. Default is the corresponding attribute from `tbl`.
#' @param cell_height Height for cell in twips. Default is the corresponding attribute from `tbl`.
#' @param text_font Text font type. Default is the corresponding attribute from `tbl`.
#' @param text_font_size Text font size. Default is the corresponding attribute from `tbl`.
#' @param text_format  Text format. Default is the corresponding attribute from `tbl`.
#' @param text_color Text color. Default is the corresponding attribute from `tbl`.
#' @param text_background_color Text background color. Default is the corresponding attribute from `tbl`.
#' @param text_justification Justification for text. Default is the corresponding attribute from `tbl`.
#' @param text_space_before Line space before text. Default is the corresponding attribute from `tbl`.
#' @param text_space_after  Line space after text. Default is the corresponding attribute from `tbl`.
#' @param use_border_bottom Logical value of using the bottom border. Default is the corresponding attribute from `tbl`.
#' @param text_convert a logical value to convert special characters. Default is the corresponding attribute from `tbl`.
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Define table begin and end in RTF syntax.
#'    \item Define cell justification using `justification()`, then covert the cell from inch to twip using `inch_to_twip()` in RTF syntax.
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
rtf_table_content <- function(tbl,

                               col_total_width       = attr(tbl, "page")$col_width,
                               use_border_bottom     = FALSE,

                               border_left           = attr(tbl, "border_left"),
                               border_right          = attr(tbl, "border_right"),
                               border_top            = attr(tbl, "border_top"),
                               border_bottom         = attr(tbl, "border_bottom"),

                               border_color_left     = attr(tbl, "border_color_left"),
                               border_color_right    = attr(tbl, "border_color_right"),
                               border_color_top      = attr(tbl, "border_color_top"),
                               border_color_bottom   = attr(tbl, "border_color_bottom"),

                               border_width          = attr(tbl, "border_width"),

                               col_rel_width         = attr(tbl, "col_rel_width"),
                               cell_height           = attr(tbl, "cell_height"),
                               cell_justification    = attr(tbl, "cell_justification"),

                               text_font             = attr(tbl, "text_font"),
                               text_format           = attr(tbl, "text_format"),
                               text_color            = attr(tbl, "text_color"),
                               text_background_color = attr(tbl, "text_background_color"),
                               text_justification    = attr(tbl, "text_justification"),
                               text_font_size        = attr(tbl, "text_font_size"),
                               text_space_before     = attr(tbl, "text_space_before"),
                               text_space_after      = attr(tbl, "text_space_after"),

                               text_convert          = attr(tbl, "text_convert")
                               ) {

  ## get dimension of tbl
  n_row <- nrow(tbl)
  n_col <- ncol(tbl)

  ## Ensure Missing value display nothing
  for(i in 1:n_col){
    tbl[,i] <- ifelse(is.na(tbl[,i]), "", as.character(tbl[,i]))
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
  border_top_left <- matrix(paste0(border_left_rtf, border_top_rtf, text_background_color_rtf, "\\cellx", cell_size), nrow = n_row, ncol = n_col)
  border_top_left_right <- matrix(paste0(border_left_rtf, border_top_rtf, border_right_rtf, text_background_color_rtf, "\\cellx", cell_size), nrow = n_row, ncol = n_col)
  border_top_left_bottom <- matrix(paste0(border_left_rtf, border_top_rtf, border_bottom_rtf, text_background_color_rtf, "\\cellx", cell_size), nrow = n_row, ncol = n_col)
  border_all <- matrix(paste0(border_left_rtf, border_top_rtf, border_right_rtf, border_bottom_rtf, text_background_color_rtf, "\\cellx", cell_size), nrow = n_row, ncol = n_col)

  if(use_border_bottom){
    border_rtf <- border_top_left_bottom
    border_rtf[, n_col] <- border_all[, n_col]
  }else{
    border_rtf <- border_top_left
    border_rtf[, n_col] <- border_top_left_right[, n_col]
  }

  border_rtf <- t(border_rtf)

  # Encoding RTF Cell Content/Text
  cell <- paste0("\\pard\\intbl\\sb", text_space_before, "\\sa", text_space_after)

  ## content/text justification
  text_justification_rtf <- factor(text_justification, levels = justification$type, labels = justification$rtf_code_text)

  # if align in decimal always justified at center.
  text_justification_rtf <- ifelse(text_justification == "d", paste0(text_justification_rtf, "\\tqdec\\tx", round(foo(cell_width) / 2, 0)), as.character(text_justification_rtf))

  ## content/text font and font size
  font_type <- font_type()
  text_font_rtf <- factor(text_font, levels = font_type$type, labels = font_type$rtf_code)
  text_font_size_rtf <- paste0("\\fs", round(text_font_size * 2, 0))

  ## content/text format
  ## The combination of type should be valid.
  ## e.g. type = "bi" or "ib" should be bold and italics.
  font_format <- font_format()

  if (!is.null(text_format)) {
    text_format_rtf <- lapply(strsplit(text_format, ""), function(x) {
      paste0(factor(x, levels = font_format$type, labels = font_format$rtf_code),
             collapse = ""
      )
    })
    text_format_rtf <- unlist(text_format_rtf)
  } else {
    text_format_rtf <- NULL
  }

  ## cell content/text color
  if (!is.null(text_color)) {
    text_color_rtf <- factor(text_color, levels = col_tb$color, labels = col_tb$type)
    text_color_rtf <- paste0("\\cf", text_color_rtf)
  } else {
    text_color_rtf <- NULL
  }

  content_matrix <- matrix("", nrow = nrow(tbl), ncol = ncol(tbl))
  for(i in 1:ncol(tbl)){
    content_matrix[, i] <- ifelse( text_convert[, i], convert(tbl[,i]), tbl[,i])
  }

  ## Combine cell content/text attributes of justification, font, font-size, format and color.
  cell_rtf <- paste0(
    cell, text_justification_rtf,
    "{", text_font_rtf, text_font_size_rtf, text_color_rtf, text_format_rtf,
    " ", content_matrix, "}", "\\cell"
  )
  cell_rtf <- t(matrix(cell_rtf, nrow = n_row, ncol = n_col))

  rbind(row_begin, border_rtf, cell_rtf, row_end)
}
