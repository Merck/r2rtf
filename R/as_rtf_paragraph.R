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

#' Create Paragraph RTF Encode
#'
#' @param text A character string.
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Obtain title and subtitle text from \code{tbl} using \code{rtf_text()}.
#'    \item Define title and subtitle text font, size, format and color attributes.
#'    \item Return title/subtitle to header using \code{rtf_paragraph()} if not NULL, otherwise return NULL to header.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
as_rtf_paragraph <- function(text){

  attr_text <- attributes(text)
  text      <- paste(text, collapse = " \n ")

  text_rtftext <- rtf_text(text,
                           font              = attr_text$text_font,
                           font_size         = attr_text$text_font_size,
                           format            = attr_text$text_format,
                           color             = attr_text$text_color,
                           background_color  = attr_text$text_background_color,
                           text_convert      = attr_text$text_convert)

  paragraph_rtftext <- rtf_paragraph(text_rtftext,
                                     justification = attr_text$text_justification,

                                     indent_first  = attr_text$text_indent_first,
                                     indent_left   = attr_text$text_indent_left,
                                     indent_right  = attr_text$text_indent_right,

                                     space         = attr_text$text_space,
                                     space_before  = attr_text$text_space_before,
                                     space_after   = attr_text$text_space_after,

                                     new_page      = attr_text$text_new_page,
                                     hyphenation   = attr_text$text_hyphenation)

  paragraph_rtftext

}
