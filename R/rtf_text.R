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

#' Text to RTF Encode
#'
#' @param text Plain text.
#' @param font Text font type.
#' @param font_size Text font size.
#' @param format  Text format.
#' @param color Text color.
#' @param background_color Text background color.
#' @param text_convert A logical value to convert special characters.
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Set font color default value to black if background color value is not NULL and color value is NULL.
#'    \item Validate if input font type is valid using \code{font_type()}.
#'    \item Validate if input font format is valid using \code{font_format()}.
#'    \item Validate if input table color is valid using \code{color_table()}.
#'    \item Convert latex character to Unicode using \code{convert()}.
#'    \item Add left curly bracket to start of code and right curly bracket to the end of code.
#'    \item Combine all components into a single code string.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
rtf_text <- function(text,
                     font = 1,
                     font_size = 12,
                     format = NULL,
                     color = NULL,
                     background_color = NULL,
                     text_convert = TRUE) {

  ## Set default value
  if ((!is.null(background_color)) & is.null(color)) {
    color <- "black"
  }

  ## Define dictionary
  font_type <- font_type()
  font_format <- font_format()
  col_tb <- color_table()


  if (!is.null(format)) {
    format_check <- unlist(strsplit(format, ""))
  } else {
    format_check <- NULL
  }

  ## check whether input arguments are valid
  stopifnot(
    font %in% font_type$type,
    as.vector(format_check) %in% font_format$type,
    is.numeric(font_size),
    color %in% col_tb$color,
    background_color %in% col_tb$color
  )

  begin <- "{"

  ### Font
  font <- factor(font, levels = font_type$type, labels = font_type$rtf_code)
  font_size <- paste0("\\fs", round(font_size * 2, 0))

  ## The combination of text format should be valid.
  ## e.g. type = "bi" or "ib" should be bold and italics.
  if (!is.null(format)) {
    format <- lapply(strsplit(format, ""), function(x) {
      paste0(factor(x, levels = font_format$type, labels = font_format$rtf_code),
        collapse = ""
      )
    })
    format <- unlist(format)
  } else {
    format <- NULL
  }

  ### Color
  text_color <- NULL
  if (!is.null(color)) {
    fg_color <- factor(color, levels = col_tb$color, labels = col_tb$type)
    text_color <- paste0("\\cf", fg_color)
  }

  if (!is.null(background_color)) {
    bg_color <- factor(background_color, levels = col_tb$color, labels = col_tb$type)
    text_color <- paste0(text_color, "\\chshdng0", "\\chcbpat", bg_color, "\\cb", bg_color)
  }

  ### Convert Latex Character
  text <- as.matrix(text)
  text_convert <- matrix(text_convert, nrow = nrow(text), ncol = ncol(text))
  text_vector <- ifelse(text_convert, convert(text), text)

  end <- "}"

  text_rtf <- paste0(
    font_size,
    begin,
    font,
    format,
    text_color, " ",
    text_vector,
    end
  )

  # Convert back to matrix
  if (!is.null(dim(text))) {
    text_rtf <- matrix(text_rtf, nrow = nrow(text), ncol = ncol(text))
  }

  text_rtf
}
