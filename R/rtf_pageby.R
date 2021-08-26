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

#' @title Add Pageby Attributes to Table
#'
#' @inheritParams rtf_body
#'
rtf_pageby <- function(tbl,
                       page_by = NULL,
                       new_page = FALSE,
                       pageby_header = TRUE,
                       pageby_row = "column") {
  if (is.null(page_by)) {
    if (new_page) {
      stop("new_page must be FALSE if page_by is not specified")
    }

    attr(tbl, "rtf_pageby") <- list(
      new_page = new_page,
      by_var = NULL,
      id = NULL
    )
  } else {
    by <- page_by
    # Define Index
    if (length(by) > 1) {
      id <- apply(tbl[, by], 1, paste, collapse = "-")
    } else {
      id <- tbl[, by]
    }

    id <- factor(id, levels = unique(id))

    order_var <- order(id)
    index_var <- which(names(tbl) %in% by)

    db <- list()
    for (i in 1:length(by)) {
      by_i <- by[1:i]
      index_var_i <- which(names(tbl) %in% by[i])

      if (!is.null(attr(tbl, "rtf_by_subline"))) {
        by_i <- c(attr(tbl, "rtf_by_subline")$by_var, by_i)
      }

      if (length(by_i) > 1) {
        id_i <- apply(tbl[, by_i], 1, paste, collapse = "-")
      } else {
        id_i <- tbl[, by_i]
      }

      id_i <- factor(id_i, levels = unique(id_i))

      # start, end and number of row
      row <- data.frame(nrow = as.numeric(table(id_i)))
      row$row_end <- cumsum(row$nrow)
      row$row_start <- with(row, row_end - nrow + 1)

      # Split information for each row

      db[[i]] <- switch(pageby_row,
        "column" =  rtf_subset(tbl, row$row_start, index_var_i),
        "first_row" = rtf_subset(tbl, row = row$row_start, col = -index_var_i)
      )

      attr(db[[i]], "row") <- row
    }
    names(db) <- by

    # re-arrange source data columns
    if (pageby_row == "first_row") {
      first_row_index <- unlist(lapply(db, function(x) attr(x, "row")$row_start))

      tbl0 <- rtf_subset(tbl, row = -first_row_index)
      for (i in 1:length(by)) {
        by_i <- by[1:i]

        if (!is.null(attr(tbl, "rtf_by_subline"))) {
          by_i <- c(attr(tbl, "rtf_by_subline")$by_var, by_i)
        }

        if (length(by_i) > 1) {
          id_i <- apply(tbl0[, by_i], 1, paste, collapse = "-")
        } else {
          id_i <- tbl0[, by_i]
        }

        id_i <- factor(id_i, levels = unique(id_i))

        # start, end and number of row
        row <- data.frame(nrow = as.numeric(table(id_i)))
        row$row_end <- cumsum(row$nrow)
        row$row_start <- with(row, row_end - nrow + 1)

        attr(db[[i]], "row") <- row
      }

      db_table <- rtf_subset(tbl, row = -first_row_index, col = -index_var)
      id <- id[-first_row_index]
    }

    if (pageby_row == "column") {
      db_table <- rtf_subset(tbl, col = -index_var)
    }

    if (!is.null(attr(tbl, "rtf_by_subline")$by_var)) {
      index_subline <- which(names(db_table) %in% attr(tbl, ("rtf_by_subline"))$by_var)
      db_table <- rtf_subset(db_table, col = -index_subline)

      if (pageby_row == "first_row") {
        attr(db_table, "rtf_by_subline")$id <- attr(db_table, "rtf_by_subline")$id[-first_row_index]
        db <- lapply(db, function(x) rtf_subset(x, col = -index_subline))
      }
    }

    attr(db_table, "row") <- row
    attr(tbl, "rtf_pageby_row") <- db
    attr(tbl, "rtf_pageby_table") <- db_table
    attr(tbl, "rtf_pageby") <- list(
      by_var = by,
      new_page = new_page,
      id = id,
      pageby_header = pageby_header,
      pageby_row = pageby_row
    )
  }

  tbl
}
