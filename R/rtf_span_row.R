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

#' @title Add Horizontal Span Row Attributes to Table
#'
#' @param tbl A data frame.
#' @param span_row A logical vector of length \code{nrow(tbl)} indicating
#'   which rows should span all columns, or an integer vector of row indices.
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Validate that \code{tbl} has body attributes from \code{rtf_body()}.
#'    \item Normalize \code{span_row} to a logical vector of length \code{nrow(tbl)}.
#'    \item Set the \code{"rtf_span_row"} attribute on \code{tbl}.
#'    \item Return \code{tbl}.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @return the same data frame \code{tbl} with additional attributes for horizontal span rows
#'
#' @examples
#' library(dplyr) # required to run examples
#' data(r2rtf_tbl1)
#' r2rtf_tbl1 %>%
#'   rtf_body() %>%
#'   rtf_span_row(span_row = c(rep(TRUE, 2), rep(FALSE, nrow(r2rtf_tbl1) - 2))) %>%
#'   attr("rtf_span_row")
#'
#' @export
rtf_span_row <- function(tbl, span_row) {
  check_args(tbl, type = "data.frame")

  if (is.null(attr(tbl, "border_top"))) {
    stop("rtf_span_row() must be called after rtf_body()")
  }

  n_row <- nrow(tbl)

  if (is.numeric(span_row) || is.integer(span_row)) {
    indices <- as.integer(span_row)
    if (any(indices < 1L | indices > n_row)) {
      stop("span_row indices must be between 1 and nrow(tbl)")
    }
    span_logical <- rep(FALSE, n_row)
    span_logical[indices] <- TRUE
    span_row <- span_logical
  }

  check_args(span_row, type = "logical", length = n_row)

  attr(tbl, "rtf_span_row") <- span_row
  tbl
}
