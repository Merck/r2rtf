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


#' create a data frame as dictionary to look up for rtf table font type
#'
#' @noRd
.font_type <- function() {
  data.frame(
    type = 1:3,
    name = c("Times New Roman", "Times New Roman Greek", "Arial Greek"),
    style = c("\\froman", "\\froman", "\\fswiss"),
    rtf_code = c("\\f0", "\\f166", "\\f266"),
    stringsAsFactors = FALSE
  )
}


#' create a data frame as dictionary to look up for rtf table color
#'
#' @noRd
.color_table <- function() {
  .tb <- data.frame(color = grDevices::colors())
  .tb$type <- 1:nrow(.tb) + 1

  .tb <- cbind(.tb, t(grDevices::col2rgb(.tb$color)))
  .tb$rtf_code <- paste0("\\red", .tb$red, "\\green", .tb$green, "\\blue", .tb$blue, ";")

  .tb
}


#' create a data frame as dictionary to look up for rtf table font format
#'
#'
#' @noRd
.font_format <- function() {
  data.frame(
    type = c("", "b", "i", "u", "s", "^", "_"),
    name = c("normal", "bold", "italics", "underline", "strike", "superscript", "subscript"),
    rtf_code = c("", "\\b", "\\i", "\\ul", "\\strike", "\\super", "\\sub"),
    stringsAsFactors = FALSE
  )
}

#' create a data frame as dictionary to look up for rtf table justification (left, right, center)
#'
#' @noRd
.justification <- function() {
  data.frame(
    type = c("l", "c", "r", "d", "j"),
    name = c("left", "center", "right", "decimal", "justified"),
    rtf_code_text = c("\\ql", "\\qc", "\\qr", "\\qj", "\\qj"),
    rtf_code_row = c("\\trql", "\\trqc", "\\trqr", "", ""),
    stringsAsFactors = FALSE
  )
}

#' create a data frame as dictionary to look up for rtf table border type
#'
#' @noRd
.border_type <- function() {
  data.frame(
    name = c(
      "", "single", "double thick", "shadowed", "double", "dot", "dash", "hairline", "small dash", "dot dash", "dot dot", "triple",
      "thick thin small", "thin thick small", "thin thick thin small",
      "thick thin medium", "thin thick medium", "thin thick thin medium",
      "thick thin large", "thin thick large", "thin thick thin large",
      "wavy", "double wavy", "stripe", "emboss", "engrave"
    ),

    rtf_code = c(
      "", "\\brdrs", "\\brdrth", "\\brdrsh", "\\brdrdb", "\\brdrdot", "\\brdrdash",
      "\\brdrhair", "\\brdrdashsm", "\\brdrdashd", "\\brdrdashdd", "\\brdrtriple",
      "\\brdrtnthsg", "\\brdrthtnsg", "\\brdrtnthtnsg",
      "\\brdrtnthmg", "\\brdrthtnmg", "\\brdrtnthtnmg",
      "\\brdrtnthlg", "\\brdrthtnlg", "\\brdrtnthtnlg",
      "\\brdrwavy", "\\brdrwavydb", "\\brdrdashdotstr",
      "\\brdremboss", "\\brdrengrave"
    ),
    stringsAsFactors = FALSE
  )
}

#' create a data frame as dictionary to look up for rtf paragraph spacing
#'
#' @noRd
.spacing <- function() {
  data.frame(
    type = c(1, 2, 1.5),
    name = c("single-space", "double-space", "1.5-space"),
    rtf_code = c("", "\\sl480\\slmult1", "\\sl360\\slmult1"),
    stringsAsFactors = FALSE
  )
}
