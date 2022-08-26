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

#' @title Calculate Number of Lines of a String Vector
#'
#' @description
#' Calculate number of lines that a string vector (e.g., title, subline, footnote, source) broken to given a specific cell size
#'
#' @param text a vector of string
#' @param strwidth a vector of string width in inches
#' @param size a vector of cell size in inches
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item \code{text} is a vector of string
#'    \item \code{strwidth} is a vector of string width in inches
#'    \item \code{size} is a vector of cell size in inches
#'    \item Return a vector of integer (number of lines)
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @return a vector of integer (number of lines)
#'
#' @examples
#' r2rtf:::rtf_nline_vector(
#'   text = c("title 1", "this is a sentence for title 2"),
#'   strwidth = c(0.4, 2),
#'   size = 0.5
#' )
rtf_nline_vector <- function(text, strwidth, size) {
  index <- strwidth / size > 1
  n_row <- rep(1, length(text))

  if (any(na.omit(index))) {
    l <- length(text)

    if (length(strwidth) < l) {
      strwidth <- rep(strwidth, length.out = l)
    }
    if (length(size) < l) {
      size <- rep(size, length.out = l)
    }

    text0 <- text[index]
    strwidth0 <- strwidth[index]
    size0 <- size[index]
    n <- nchar(as.character(text0))
    width0 <- floor(n / strwidth0 * size0)
    n_row[index] <- unlist(lapply(Map(strwrap, x = text0, width = width0), length))
  }

  n_row
}


#' @title Calculate Number of Lines of a String Matrix
#'
#' @description
#' Calculate each string matrix (e.g., table body in matrix format) row's maximum number of lines broken to given a specific cell size
#'
#' @param text a matrix of string
#' @param strwidth a matrix of string width in inches
#' @param size a matrix of cell size in inches
#'
#' #' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item \code{text} is a matrix of string
#'    \item \code{strwidth} is a matrix of string width in inches
#'    \item \code{size} is a matrix of cell size in inches
#'    \item Return a vector of integer (number of lines)
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @return a vector of integer (number of lines)
#'
#' @examples
#' text <- matrix("this is a sentence", nrow = 2, ncol = 2)
#' strwidth <- matrix(6:9, nrow = 2)
#' size <- matrix(1:4, nrow = 2)
#' r2rtf:::rtf_nline_matrix(text = text, strwidth = strwidth, size = size)
rtf_nline_matrix <- function(text, strwidth, size) {
  n_row <- matrix(1, nrow = nrow(text), ncol = ncol(text))
  for (i in 1:ncol(text)) {
    n_row[, i] <- rtf_nline_vector(text[, i], strwidth[, i], size[, i])
  }

  apply(n_row, 1, max)
}


#' @title Calculate Number of Rows for a Paragraph
#'
#' @description
#' Calculate number of rows for a paragraph like title, subline, footnote, source
#'
#' @param tbl A data frame's `rtf_title`, `rtf_subline`, `rtf_footnote`, or `rtf_source` attribute containing `strwidth` attribute
#' @param size Size of a line in inches
#' @param padding Cell padding in inches
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item \code{tbl} is a data frame's `rtf_title`, `rtf_subline`, `rtf_footnote`, or `rtf_source` attribute containing `strwidth` attribute.
#'    \item Return an integer (number of rows) for title, subline, footnote, or source
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @return an integer (number of rows) for title, subline, footnote, or source
#'
#' @examples
#' library(dplyr) # required for running example
#' tb <- head(iris) %>%
#'   rtf_title(title = "Iris example") %>%
#'   rtf_footnote(footnote = c("footnote 1", "footnote 2")) %>%
#'   rtf_body()
#'
#' r2rtf:::nrow_paragraph(attr(tb, "rtf_title"), 6.25)
#' r2rtf:::nrow_paragraph(attr(tb, "rtf_footnote"), 6.25)
nrow_paragraph <- function(tbl, size, padding = 0.2) {
  if (is.null(tbl)) {
    return(0)
  }

  size <- size - padding

  n_row <- sum(ceiling(attr(tbl, "strwidth") / size))
  n_row <- ifelse(n_row < 1, 1, n_row)
  n_row
}


#' @title Calculate Number of Lines Broken to for Each Table Row
#'
#' @description
#' Calculate number of lines broken to for each row of a table
#'
#' @param tbl A data frame with attributes or a data frame's `rtf_footnote` or `rtf_source` attributes
#' @param size Table size in inches
#' @param page_size Page size in inches
#' @param padding Cell padding in inches
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item \code{tbl} is a data frame.
#'    \item Size is table's  width in inches.
#'    \item Page_size is page's width in inches.
#'    \item Return to a numeric vector of number of maximum lines broken to for each row.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @return a numeric vector of number of maximum lines broken to for each row
#'
#' @examples
#' library(dplyr) # required for running example
#' tbl <- iris[c(1:4, 50:54), ] %>%
#'   rtf_title(title = "Iris example") %>%
#'   rtf_body()
#' r2rtf:::nrow_table(tbl, size = 2.55)
nrow_table <- function(tbl, size, page_size = size, padding = 0.2) {
  if (is.null(tbl)) {
    return(0)
  }

  padding <- (attr(tbl, "text_indent_left") + attr(tbl, "text_indent_right")) / 1440 + padding

  if (!is.null(attr(tbl, "as_table"))) {
    if (!attr(tbl, "as_table")) {
      return(nrow_paragraph(tbl, page_size, padding = padding))
    }
  }

  ## actual column width
  rel_width <- attr(tbl, "col_rel_width")
  width <- size * rel_width / sum(rel_width)
  if (!is.null(dim(tbl))) {
    width <- matrix(width, nrow = nrow(tbl), ncol = ncol(tbl), byrow = TRUE) - padding
    n_row <- rtf_nline_matrix(tbl, attr(tbl, "strwidth"), size = width)
  } else {
    width <- width - padding
    n_row <- rtf_nline_vector(tbl, attr(tbl, "strwidth"), size = width)
  }

  n_row <- ifelse(n_row < 1, 1, n_row)
  n_row
}


#' @title Add Number of Row Attributes for a Table
#'
#' @description
#' Add number of row attributes for a table
#'
#' @param tbl A data frame
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item \code{tbl} is a data frame.
#'    \item Return to a data frame with number of row attributes.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @return a data frame with number of row attributes
#'
#' @examples
#' library(dplyr) # required for running example
#' tbl <- iris[c(1:4, 50:54), ] %>%
#'   rtf_title(title = "Iris example") %>%
#'   rtf_body()
#' r2rtf:::rtf_nrow(tbl)
rtf_nrow <- function(tbl) {
  page <- attr(tbl, "page")
  page_size <- page$width - sum(page$margin[c(1, 2)])
  col_width <- page$col_width

  # Add nrow attributes for each meta component
  attr(tbl, "rtf_nrow_meta") <- data.frame(
    page = attr(tbl, "page")$nrow,
    title = sum(nrow_paragraph(attr(tbl, "rtf_title"), page_size)),
    subline = sum(nrow_paragraph(attr(tbl, "rtf_subline"), page_size)),
    col_header = sum(unlist(lapply(attr(tbl, "rtf_colheader"), nrow_table, size = col_width))),
    footnote = sum(nrow_table(attr(tbl, "rtf_footnote"), size = col_width, page_size = page_size)),
    source = sum(nrow_table(attr(tbl, "rtf_source"), size = col_width, page_size = page_size))
  )

  # Add nrow attributes for original table
  attr(tbl, "rtf_nrow") <- nrow_table(tbl, size = col_width)

  # Add nrow attributes for pageby table
  if (!is.null(attr(tbl, "rtf_pageby_table"))) {
    attr(attr(tbl, "rtf_pageby_table"), "rtf_nrow") <- nrow_table(attr(tbl, "rtf_pageby_table"), size = col_width)
  }

  # Add nrow attributes for pageby_row table
  if (!is.null(attr(tbl, "rtf_pageby_row"))) {
    attr(tbl, "rtf_pageby_row") <- lapply(attr(tbl, "rtf_pageby_row"), function(tbl) {
      attr(tbl, "rtf_nrow") <- nrow_table(tbl, size = col_width)
      tbl
    })
  }

  tbl
}
