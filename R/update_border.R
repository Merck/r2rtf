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

#' @title Update First Border Line Based on Page Information
#'
#' @description
#' Update first border line type and color type based on page information.
#'
#' @param tbl A data frame
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item \code{tbl} is a data frame.
#'    \item Return a data frame \code{tbl} with updated top border type and top border color type attributes.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @return a data frame \code{tbl} with updated top border type and top border color type attributes
#'
#' @examples
#' library(dplyr)
#' tbl <- iris[c(1:3, 51:54), ] |>
#'   rtf_body(page_by = "Species") |>
#'   r2rtf:::update_border_first()
#'
#' @noRd
update_border_first <- function(tbl) {
  page <- attr(tbl, "page")
  colheader <- attr(tbl, "rtf_colheader")
  pageby <- attr(tbl, "rtf_pageby_table")

  if (is.null(colheader)) {
    row_first <- "body"
  } else {
    row_first <- "colheader"
  }

  if (is.null(page$border_first)) {
    row_first <- "null"
  }


  if (row_first == "colheader") {
    attributes(colheader[[1]])$border_top <- matrix(page$border_first, nrow = 1, ncol = ncol(colheader[[1]]))

    if (!is.null(page$border_color_first)) {
      attributes(colheader[[1]])$border_color_top <- matrix(page$border_color_first, nrow = 1, ncol = ncol(colheader[[1]]))
    }
  }

  if (row_first == "body") {
    attributes(tbl)$border_first[1, ] <- matrix(page$border_first, nrow = 1, ncol = ncol(tbl))

    if (!is.null(page$border_color_first)) {
      attributes(tbl)$border_color_first[1, ] <- matrix(page$border_color_first, nrow = 1, ncol = ncol(tbl))
    }

    if (!is.null(pageby)) {
      attributes(pageby)$border_first[1, ] <- matrix(page$border_first, nrow = 1, ncol = ncol(pageby))

      if (!is.null(page$border_color_first)) {
        attributes(pageby)$border_color_first[1, ] <- matrix(page$border_color_first, nrow = 1, ncol = ncol(pageby))
      }
    }
  }

  attr(tbl, "page") <- page
  attr(tbl, "rtf_colheader") <- colheader
  attr(tbl, "rtf_pageby_table") <- pageby

  tbl
}


#' @title Update Last Border Line Based on Page Information
#'
#' @description
#' Update last border line type and color type based on page information.
#'
#' @param tbl A data frame
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item \code{tbl} is a data frame.
#'    \item Return a data frame \code{tbl} with updated last border type and last border color type attributes.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @return a data frame \code{tbl} with updated last border type and last border color type attributes
#'
#' @examples
#' library(dplyr)
#' tbl <- iris[c(1:3, 51:54), ] |>
#'   rtf_body(page_by = "Species") |>
#'   r2rtf:::update_border_last()
#'
#' @noRd
update_border_last <- function(tbl) {
  page <- attr(tbl, "page")
  pageby <- attr(tbl, "rtf_pageby_table")
  footnote <- attr(tbl, "rtf_footnote")
  source <- attr(tbl, "rtf_source")

  if (is.null(source)) {
    if (is.null(footnote)) {
      row_last <- "body"
    } else {
      if (attr(footnote, "as_table")) {
        row_last <- "footnote"
      } else {
        row_last <- "body"
      }
    }
  } else {
    if (attr(source, "as_table")) {
      row_last <- "source"
    } else {
      if (is.null(footnote)) {
        row_last <- "body"
      } else {
        if (attr(footnote, "as_table")) {
          row_last <- "footnote"
        } else {
          row_last <- "body"
        }
      }
    }
  }

  if (is.null(page$border_last)) {
    row_last <- "null"
  }

  if (row_last == "footnote") {
    attributes(footnote)$border_bottom <- page$border_last

    if (!is.null(page$border_color_last)) {
      attributes(footnote)$border_color_bottom <- page$border_color_last
    }
  }

  if (row_last == "source") {
    attributes(source)$border_bottom <- page$border_last

    if (!is.null(page$border_color_last)) {
      attributes(source)$border_color_bottom <- page$border_color_last
    }
  }

  if (row_last == "body") {
    attributes(tbl)$border_last[nrow(tbl), ] <- matrix(page$border_last, nrow = 1, ncol = ncol(tbl))

    if (!is.null(page$border_color_last)) {
      attributes(tbl)$border_color_last[nrow(tbl), ] <- matrix(page$border_color_last, nrow = 1, ncol = ncol(tbl))
    }

    if (!is.null(pageby)) {
      attributes(pageby)$border_last[nrow(pageby), ] <- matrix(page$border_last, nrow = 1, ncol = ncol(pageby))

      if (!is.null(page$border_color_last)) {
        attributes(pageby)$border_color_last[nrow(pageby), ] <- matrix(page$border_color_last, nrow = 1, ncol = ncol(pageby))
      }
    }
  }

  attr(tbl, "page") <- page
  attr(tbl, "rtf_pageby_table") <- pageby
  attr(tbl, "rtf_footnote") <- footnote
  attr(tbl, "rtf_source") <- source

  tbl
}
