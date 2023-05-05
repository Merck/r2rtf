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

#' @title Add
#'  Sublineby Attributes to Table
#'
#' @inheritParams rtf_body
#'
#' @noRd
rtf_by_subline <- function(tbl,
                           subline_by) {
  if (is.null(subline_by)) {
    attr(tbl, "rtf_by_subline") <- list(
      new_page = FALSE,
      by_var = NULL,
      id = NULL
    )
  } else {
    by <- subline_by
    # Define Index
    if (length(by) > 1) {
      id <- apply(tbl[, by], 1, paste, collapse = "-")
    } else {
      id <- tbl[, by]
    }

    id <- factor(id, levels = unique(id))

    order_var <- order(id)
    index_var <- which(names(tbl) %in% by)

    # start, end and number of row
    row <- data.frame(nrow = as.numeric(table(id)))
    row$row_end <- cumsum(row$nrow)
    row$row_start <- with(row, row_end - nrow + 1)

    db <- rtf_subset(tbl, row$row_start, index_var)

    attr(db, "row") <- row
    attr(tbl, "rtf_by_subline_row") <- db
    attr(tbl, "rtf_by_subline") <- list(
      new_page = TRUE,
      by_var = by,
      id = id
    )
  }

  tbl
}
