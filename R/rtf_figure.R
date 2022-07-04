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

#' Add Figure Attributes
#'
#' @inheritParams rtf_body
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item If page attributes are NULL then assign default page attributes using `rtf_page()` function.
#'    \item Check if input width and height are greater than zero.
#'    \item Define figure width and height attributes based on the inputs.
#'    \item Return to `tbl` with figure width and height attributes.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @param fig_width the width of figures in inch
#' @param fig_height the height of figures in inch
#' @param fig_format the figure format defined in `r2rtf:::fig_format()`
#'
#' @return the same data frame \code{tbl} with additional attributes for figure body
#'
#' @examples
#' \dontrun{
#' library(dplyr) # required to run examples
#' file <- file.path(tempdir(), "figure1.png")
#' png(file)
#' plot(1:10)
#' dev.off()
#'
#' # Read in PNG file in binary format
#' rtf_read_figure(file) %>%
#'   rtf_figure() %>%
#'   attributes()
#' }
#'
#' @export
rtf_figure <- function(tbl,
                       fig_width = 5,
                       fig_height = 5,
                       fig_format = NULL) {

  # Set Default Page Attributes
  if (is.null(attr(tbl, "page"))) {
    tbl <- rtf_page(tbl)
  }

  # Check argument values
  stopifnot(fig_width > 0)
  stopifnot(fig_height > 0)

  attr(tbl, "fig_width") <- matrix(fig_width, nrow = length(tbl), ncol = 1, byrow = TRUE)
  attr(tbl, "fig_height") <- matrix(fig_height, nrow = length(tbl), ncol = 1, byrow = TRUE)

  if(is.null(attr(tbl, "fig_format"))){
    if(is.null(fig_format)) stop("fig_format is required")
    attr(tbl, "fig_format") <- matrix(fig_format, nrow = length(tbl), ncol = 1, byrow = TRUE)
  }

  tbl
}
