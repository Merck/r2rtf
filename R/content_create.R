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


#' Create RTF Header Encode
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Initiate RTF table by defining language #1033 (U.S. English).
#'    \item Define the initiation in RTF syntax.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @noRd
as_rtf_init <- function() {
  # The number 1033 is U.S. English
  paste("{", "\\rtf1\\ansi\n\\deff0\\deflang1033", sep = "")
}


#' Create RTF Font Encode
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Initiate RTF font type using \code{font_type()}.
#'    \item Combine all components into a single RTF code string.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @noRd
as_rtf_font <- function() {
  font_type <- font_type()
  font_rtf <- factor(seq_along(font_type$type), levels = font_type$type, labels = font_type$rtf_code)
  font_style <- factor(seq_along(font_type$type), levels = font_type$type, labels = font_type$style)
  font_name <- factor(seq_along(font_type$type), levels = font_type$type, labels = font_type$name)
  font_charset <- factor(seq_along(font_type$type), levels = font_type$type, labels = font_type$charset)

  font_table <- paste0(
    "{\\fonttbl",
    paste(paste0("{", font_rtf, font_style, font_charset, "\\fprq2 ", font_name, ";}\n"), collapse = ""),
    "}\n"
  )

  font_table
}


#' Create RTF Color Encode
#'
#' @param tbl A data frame.
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Initiate RTF color using \code{color_table()} if use_color is TRUE in page attribute.
#'    \item Combine all components into a single RTF code string.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @noRd
as_rtf_color <- function(tbl) {
  rtf_color <- NULL

  if (attr(tbl, "page")$use_color) {
    col_tb <- color_table()
    rtf_color <- paste(c("{\\colortbl\n;", col_tb$rtf_code, "}"), collapse = "\n")
  }

  rtf_color
}


#' Create RTF Page Size Encode
#'
#' @param tbl A data frame.
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Collect page attributes from \code{tbl} object.
#'    \item Convert page size from inch to twip using \code{inch_to_twip()}.
#'    \item Define page size in width, height and orientation (landscape or portrait) in RTF syntax.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @noRd
as_rtf_page <- function(tbl) {
  page <- attr(tbl, "page")

  page_size <- c("\\paperw", "\\paperh")
  page_size <- paste(paste0(page_size, inch_to_twip(c(page$width, page$height))), collapse = "")

  if (page$orientation == "landscape") {
    page_size <- paste0(page_size, "\\landscape\n")
  }

  if (page$orientation == "portrait") {
    page_size <- paste0(page_size, "\n")
  }

  # Page Footer
  if (!is.null(attr(tbl, "rtf_page_footer"))) {
    encode <- c(
      "{\\footer",
      as_rtf_paragraph(attr(tbl, "rtf_page_footer"), combine = FALSE),
      "}"
    )

    encode <- paste(encode, collapse = "\n")
    page_size <- paste(encode, page_size, sep = "\n")
  }

  # Page Header
  if (!is.null(attr(tbl, "rtf_page_header"))) {
    encode <- c(
      "{\\header",
      as_rtf_paragraph(attr(tbl, "rtf_page_header"), combine = FALSE),
      "}"
    )

    encode <- paste(encode, collapse = "\n")
    page_size <- paste(encode, page_size, sep = "\n")
  }

  page_size
}


#' Create RTF Page Margin Encode
#'
#' @param tbl A data frame.
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Collect margin attributes from \code{tbl} object.
#'    \item Convert margin from inch to twip using \code{inch_to_twip()}.
#'    \item Define margin in RTF syntax.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @noRd
as_rtf_margin <- function(tbl) {
  page <- attr(tbl, "page")

  margin <- c("\\margl", "\\margr", "\\margt", "\\margb", "\\headery", "\\footery")
  margin <- paste(paste0(margin, inch_to_twip(page$margin)), collapse = "")
  margin <- paste0(margin, "\n")

  margin
}


#' Create RTF New Page Encode
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Define new page in RTF syntax.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @noRd
as_rtf_new_page <- function() {
  paste("{\\pard\\fs2\\par}\\page{\\pard\\fs2\\par}")
}


#' Create Table Title RTF Encode
#'
#' @param tbl A data frame.
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Obtain title attributes from \code{tbl} object.
#'    \item Define title in RTF syntax using \code{as_rtf_paragraph()} if it is not NULL, otherwise return NULL.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @noRd
as_rtf_title <- function(tbl) {
  title <- attr(tbl, "rtf_title")

  if (is.null(title)) {
    return(NULL)
  }

  if (length(unique(attr(title, "text_justification"))) > 1) {
    paste0(as_rtf_paragraph(title, combine = FALSE), collapse = "")
  } else {
    as_rtf_paragraph(title, combine = TRUE)
  }
}

#' Create Table Subline RTF Encode
#'
#' @param tbl A data frame.
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
#' @noRd
as_rtf_subline <- function(tbl) {
  subline <- attr(tbl, "rtf_subline")

  if (is.null(subline)) {
    return(NULL)
  }

  if (length(unique(attr(subline, "text_justification"))) > 1) {
    paste0(as_rtf_paragraph(subline, combine = FALSE), collapse = "")
  } else {
    as_rtf_paragraph(subline, combine = TRUE)
  }
}

#' Create Column Header RTF Encode
#'
#' @param tbl A data frame.
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Obtain column header attributes from \code{tbl} object.
#'    \item Extract column header total width from page col_width attribute.
#'    \item Define column header in RTF syntax using \code{rtf_table_content()}.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @noRd
as_rtf_colheader <- function(tbl) {
  rtf_colheader <- attr(tbl, "rtf_colheader")

  rtf_code <- lapply(rtf_colheader, rtf_table_content,
    use_border_bottom = TRUE,
    col_total_width = attr(tbl, "page")$col_width
  )

  unlist(rtf_code)
}


#' Create Footnote RTF Encode
#'
#' @param tbl A data frame.
#' @param attr_name a character value of attribute name.
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Obtain footnote attributes from \code{tbl}.
#'    \item Define footnote in RTF syntax using \code{rtf_table_content()} if as_table attribute is TRUE.
#'    \item Define footnote in RTF syntax using \code{rtf_paragraph()} if as_table attribute is FALSE.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @noRd
as_rtf_footnote <- function(tbl, attr_name = "rtf_footnote") {
  text <- attr(tbl, attr_name)

  if (is.null(text)) {
    return(NULL)
  }

  if (attr(text, "as_table")) {
    indent <- unlist(c(
      attr(text, "text_indent_first"),
      attr(text, "text_indent_left"),
      attr(text, "text_indent_right")
    ))

    if (any(indent != 0)) {
      text_matrix <- matrix(text, ncol = 1)
      attributes(text_matrix) <- append(attributes(text_matrix), attributes(text))

      # handle border bottom to only display the last one
      border_bottom <- matrix("", nrow = nrow(text_matrix), ncol = 1)
      border_bottom[nrow(border_bottom), 1] <- tail(unlist(attr(text_matrix, "border_bottom")), 1)
      attr(text_matrix, "border_bottom") <- border_bottom

      encode <- rtf_table_content(text_matrix,
        col_total_width = attr(tbl, "page")$col_width,
        use_border_bottom = TRUE
      )
    } else {
      if (any(attr(text, "text_convert"))) {
        text_matrix <- convert(text)
      } else {
        text_matrix <- text
      }

      text_matrix <- matrix(paste(text_matrix, collapse = "\\line "), nrow = 1, ncol = 1)

      attr(text, "text_convert") <- matrix(FALSE, nrow = 1, ncol = 1)
      attributes(text_matrix) <- append(attributes(text_matrix), lapply(attributes(text), `[`, 1))
      attr(text_matrix, "col_rel_width") <- 1

      encode <- rtf_table_content(text_matrix,
        col_total_width = attr(tbl, "page")$col_width,
        use_border_bottom = TRUE
      )
    }
    paste(encode, collapse = "\n")
  } else {
    if (length(unique(attr(text, "text_justification"))) > 1) {
      paste0(as_rtf_paragraph(text, combine = FALSE), collapse = "")
    } else {
      as_rtf_paragraph(text, combine = TRUE)
    }
  }
}


#' Create Data Source RTF Encode
#'
#' @param tbl A data frame.
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Obtain source attributes from \code{tbl}.
#'    \item Define source in RTF syntax using \code{rtf_table_content()} if as_table attribute is TRUE.
#'    \item Define source in RTF syntax using \code{rtf_paragraph()} if as_table attribute is FALSE.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @noRd
as_rtf_source <- function(tbl) {
  as_rtf_footnote(tbl, "rtf_source")
}

#' End RTF Encode
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Add symbol right curly bracket at the end of code.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @noRd
as_rtf_end <- function() {
  paste("}", sep = "")
}
