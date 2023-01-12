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

#' Read Figures into Binary Files
#'
#' Supported format is listed in \code{r2rtf:::fig_format()}.
#'
#' @param file A character vector of figure file paths.
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Read PNG figures into binary file using \code{lapply} and \code{readBin}
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @return a list of binary data vector returned by \code{readBin}
#'
#' @examples
#' \dontrun{
#'
#' # Read in PNG file in binary format
#' file <- tempfile("figure", fileext = ".png")
#' png(file)
#' plot(1:10)
#' dev.off()
#'
#'
#' rtf_read_figure(file)
#'
#' # Read in EMF file in binary format
#' library(devEMF)
#' file <- tempfile("figure", fileext = ".emf")
#' emf(file)
#' plot(1:10)
#' dev.off()
#'
#' rtf_read_figure(file)
#' }
#' @export
rtf_read_figure <- function(file) {
  out <- lapply(file, readBin, what = "raw", size = 1, signed = TRUE, endian = "little", n = 1e8)

  attr(out, "fig_format") <- tools::file_ext(file)

  out
}

#' Read PNG Figures into Binary Files
#'
#' @param file A character vector of PNG file paths.
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Deprecated: rtf_read_png. Use rtf_read_figure instead
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @return a list of binary data vector returned by \code{readBin}
#'
#' @export
rtf_read_png <- function(file) {
  warning("Deprecated: rtf_read_png. Use rtf_read_figure instead")
  rtf_read_figure(file)
}
