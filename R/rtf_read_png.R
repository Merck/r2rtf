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

#' Read PNG Figures into Binary Files
#'
#' @param file A character vector of PNG file paths.
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
#' file <- file.path(tempdir(), "figure1.png")
#' png(file)
#' plot(1:10)
#' dev.off()
#'
#' # Read in PNG file in binary format
#' rtf_read_png(file)
#' }
#'
#' @export
rtf_read_png <- function(file) {
  lapply(file, readBin, what = "raw", size = 1, signed = TRUE, endian = "little", n = 1e8)
}
