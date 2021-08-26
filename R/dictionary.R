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


#' RTF Text Font Dictionary
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Collect most commonly used fonts (Times New Roman, Times New Roman Greek, and Arial Greek, etc.).
#'    \item Define font types from 1 to 10.
#'    \item Define font styles.
#'    \item Create a mapping between font types and their RTF code.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
font_type <- function() {
  data.frame(
    type = 1:10,
    name = c(
      "Times New Roman", "Times New Roman Greek", "Arial Greek",
      "Arial", "Helvetica", "Calibri", "Georgia",
      "Cambria", "Courier New", "Symbol"
    ),
    style = c(
      "\\froman", "\\froman", "\\fswiss",
      "\\fswiss", "\\fswiss", "\\fswiss", "\\froman",
      "\\ffroman", "\\fmodern", "\\ftech"
    ),
    rtf_code = c(
      "\\f0", "\\f1", "\\f2",
      "\\f3", "\\f4", "\\f5", "\\f6",
      "\\f7", "\\f8", "\\f9"
    ),
    family = c(
      "Times", "Times", "ArialMT", "ArialMT", "Helvetica",
      "Calibri", "Georgia", "Cambria", "Courier", "Times"
    ),
    stringsAsFactors = FALSE
  )
}


#' RTF Text Color Dictionary
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Collect all possible colors from R graphics devices.
#'    \item Define the colors to RGB conversion in RTF syntax.
#'    \item Combine all RGB components into a single RTF code string.
#'    \item Create a mapping between colors and their RTF code.
#'    \item Return to `color_table()` data frame to see the complete mapping.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
color_table <- function() {
  .tb <- data.frame(color = grDevices::colors())
  .tb$type <- 1:nrow(.tb)
  .tb <- cbind(.tb, t(grDevices::col2rgb(.tb$color)))
  .tb$rtf_code <- paste0("\\red", .tb$red, "\\green", .tb$green, "\\blue", .tb$blue, ";")

  .tb
}


#' RTF Text Format Dictionary
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Collect most commonly used font formats (normal, bold, italics, underline, strike, superscript, and subscript).
#'    \item Define font format types in "", "b", "i", "u", "s", "^", "_".
#'    \item Create a mapping between font formats and their RTF code.
#'  }
#'
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
font_format <- function() {
  data.frame(
    type = c("", "b", "i", "u", "s", "^", "_"),
    name = c("normal", "bold", "italics", "underline", "strike", "superscript", "subscript"),
    rtf_code = c("", "\\b", "\\i", "\\ul", "\\strike", "\\super", "\\sub"),
    stringsAsFactors = FALSE
  )
}


#' RTF Text Justification Dictionary
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Collect most commonly used alignments for texts or rows (left, center, right, decimal, and justified).
#'    \item Define alignments/justifications in "l", "c", "r", "d", "j".
#'    \item Define the alignments/justifications for texts in RTF syntax.
#'    \item Define the alignments/justifications for rows in RTF syntax.
#'    \item Create a mapping between justifications and their RTF code.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
justification <- function() {
  data.frame(
    type = c("l", "c", "r", "d", "j"),
    name = c("left", "center", "right", "decimal", "justified"),
    rtf_code_text = c("\\ql", "\\qc", "\\qr", "\\qj", "\\qj"),
    rtf_code_row = c("\\trql", "\\trqc", "\\trqr", "", ""),
    stringsAsFactors = FALSE
  )
}


#' RTF Border Type Dictionary
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Collect most commonly used border types for a table.
#'    \item Define the border types in RTF syntax.
#'    \item Create a mapping between border types and their RTF code.
#'    \item Return to `border_type()` data frame to see all available border types.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
border_type <- function() {
  data.frame(
    name = c(
      "", "single", "double", "dot", "dash", "small dash", "dot dash", "dot dot"
    ),
    rtf_code = c(
      "", "\\brdrs", "\\brdrdb", "\\brdrdot", "\\brdrdash",
      "\\brdrdashsm", "\\brdrdashd", "\\brdrdashdd"
    ),
    stringsAsFactors = FALSE
  )
}


#' RTF Paragraph Spacing Dictionary
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Collect most commonly used paragraph spacing (single-space, double-space, and 1.5-space).
#'    \item Define the paragraph spacing type in 1, 2, 1.5.
#'    \item Create a mapping between paragraph spacing and their RTF code.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
spacing <- function() {
  data.frame(
    type = c(1, 2, 1.5),
    name = c("single-space", "double-space", "1.5-space"),
    rtf_code = c("", "\\sl480\\slmult1", "\\sl360\\slmult1"),
    stringsAsFactors = FALSE
  )
}
