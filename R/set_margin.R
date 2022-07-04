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

#' Define Margin Type
#'
#' @param doc_type doc_type in 'csr', 'wma', 'wmm' or 'narrow'
#' @param orientation Orientation in 'portrait' or 'landscape'.
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Define document margin by assigning margin values for left, right, top, bottom, header and footer.
#'    \item Define document orientation.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
set_margin <- function(doc_type, orientation) {
  if (!doc_type %in% c("csr", "wma", "wmm", "narrow")) {
    stop("input doc_type must be 'csr', 'wma', 'wmm' or 'narrow' ")
  }

  if (!orientation %in% c("portrait", "landscape")) {
    stop("input orientation must be 'portrait' or 'landscape' ")
  }

  margin <- list(
    csr = list(
      portrait = c(1.25, 1, 1.5, 1, 0.5, 0.5),
      landscape = c(0.5, 0.5, 1.27986111111111, 1.25, 1.25, 1)
    ),
    wma = list(
      portrait = c(1.25, 1, 1.75, 1.25, 1.75, 1.00625),
      landscape = c(1.0, 1.0, 2, 1.25, 1.25, 1.25)
    ),
    wmm = list(
      portrait = c(1.25, 1, 1, 1, 1.75, 1.00625),
      landscape = c(0.5, 0.5, 1.25, 1, 1.25, 1.25)
    ),
    narrow = list(
      portrait  = rep(0.5, 6),
      landscape = rep(0.5, 6)
    )
  )

  margin[[doc_type]][[orientation]]
}
