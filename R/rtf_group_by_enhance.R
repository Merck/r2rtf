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


#' Remove Duplicate Records
#'
#' @param tbl A data frame.
#' @param group_by A character vector of variable names in `tbl`.
#' @param page_index A numeric vector of page index.
#'
#' @return Return \code{tbl}.
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Define \code{id} variable to split data frame.
#'    \item Remove duplicate records within each splitted data frame.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
rtf_group_by_enhance <- function(tbl, group_by, page_index) {
  for (i in length(group_by):1) {
    by <- group_by[1:i]
    meta <- cbind(page_index = page_index, tbl[, by])
    # Define Index
    id <- apply(meta, 1, paste, collapse = "-")

    id <- factor(id, levels = unique(id))

    # if (i == length(group_by)) {
    #   order_var <- order(id)
    #   index_var <- which(names(tbl) %in% by)
    #
    #   if (!all(order_var == 1:nrow(tbl))) {
    #     stop("Data is not sorted by ", paste(by, collapse = ", "))
    #   }
    # }

    # Remove duplicate records
    tbl <- do.call(
      rbind,
      lapply(split(tbl, id), function(x) {
        x[-1, group_by[i]] <- NA
        x
      })
    )
  }

  rownames(tbl) <- NULL
  tbl
}
