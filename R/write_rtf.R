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

#' @title Write an RTF Table or Figure to an RTF File
#'
#' @description
#' The write_rtf function writes rtf encoding string to an .rtf file
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Export a single RTF string into an file using \code{write} function.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @param rtf A character rtf encoding string rendered by `rtf_encode()`.
#' @param file A character string naming a file to save rtf file.
#'
#' @export
write_rtf <- function(rtf, file) {
  write(paste(unlist(rtf), collapse = "\n"), file)

  invisible(file)
}


#' Write a Paragraph to an RTF File
#'
#' @param rtf rtf code for text paragraph, obtained using `rtf_paragraph(text,...)` function
#' @param file file name to save rtf text paragraph, eg. filename.rtf
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Define table color using \code{color_table()} and translate in RTF syntax.
#'    \item Initiate rtf using \code{as_rtf_init()} and \code{as_rtf_font()}.
#'    \item Combine the text with other components into a single RTF code string.
#'    \item Output the paragraph into a file.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
write_rtf_para <- function(rtf, file) {
  col_tb <- color_table()
  rtf_color <- paste(c("{\\colortbl\n;", col_tb$rtf_code, "}"), collapse = "\n")

  start_rtf <- paste(

    as_rtf_init(),
    as_rtf_font(),
    rtf_color,
    sep = "\n"
  )

  rtf <- paste(start_rtf, "{\\pard \\par}", paste(rtf, collapse = ""), as_rtf_end(), sep = "\n")
  write(rtf, file)

  invisible(file)
}
