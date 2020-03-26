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

#' Read PNG figures into Binary Files
#'
#' @param file a vector of PNG file path
#'
#' @examples
#' \dontrun{
#'   file <- file.path(tempdir(), "figure1.png")
#'   png(file)
#'   plot(1:10)
#'   dev.off()
#'
#'   # Read in PNG file in binary format
#'   rtf_read_png(file)
#' }
#'
#' @export
rtf_read_png <- function(file) {
  lapply(file, readBin, what = "raw", size = 1, signed = TRUE, endian = "little", n = 1e8)
}

#' Add Figure Attributes
#'
#' @inheritParams rtf_body
#'
#' @param fig_width the width of figures in inch
#' @param fig_height the height of figures in inch
#'
#' @examples
#' \dontrun{
#'   library(dplyr) # required to run examples
#'   file <- file.path(tempdir(), "figure1.png")
#'   png(file)
#'   plot(1:10)
#'   dev.off()
#'
#'   # Read in PNG file in binary format
#'   rtf_read_png(file) %>% rtf_figure() %>%
#'   attributes()
#' }
#'
#' @export
rtf_figure <- function(tbl,

                       page_width = 8.5,
                       page_height = 11,
                       orientation = "portrait",
                       doctype = "wma",

                       fig_width = 5,
                       fig_height = 5) {
  tbl <- .rtf_page_size(tbl,
    page_width = page_width,
    page_height = page_height,
    orientation = orientation
  )

  tbl <- .rtf_page_margin(tbl,
    doctype = doctype,
    orientation = orientation
  )

  attr(tbl, "fig_width") <- matrix(fig_width, nrow = length(tbl), ncol = 1, byrow = TRUE)
  attr(tbl, "fig_height") <- matrix(fig_height, nrow = length(tbl), ncol = 1, byrow = TRUE)

  tbl
}
