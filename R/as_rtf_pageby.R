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

#' RTF Table Page By Encoding
#'
#' @param tbl A data frame.
#' @importFrom utils tail
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Collect all attributes from \code{tbl} object.
#'    \item Define table attributes using \code{rtf_table_content()}.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
as_rtf_pageby <- function(tbl) {
  # Calculate Number of rows for each entry.
  tbl <- rtf_nrow(tbl)

  # Other attributes
  page <- attr(tbl, "page")
  pageby <- attr(tbl, "rtf_pageby")
  pageby_row <- attr(tbl, "rtf_pageby_row")
  group_by <- attr(tbl, "rtf_groupby")
  col_width <- attr(tbl, "page")$col_width
  rtf_nrow <- attr(tbl, "rtf_nrow_meta")

  # Get number of row for each entry
  row <- lapply(pageby_row, function(x) attr(x, "row"))
  row_index <- do.call(rbind, row)
  rtf_nrow$pageby <- length(row)

  # Check if column is used to display pageby header
  pageby_column <- attr(tbl, "rtf_pageby")$pageby_row == "column"

  # Identify Table Content
  if (is.null(attr(tbl, "rtf_pageby_table"))) {
    cell_tbl <- tbl
  } else {
    cell_tbl <- attr(tbl, "rtf_pageby_table")
  }

  # Number of rows in cells based on column size
  index <- sort(c(seq_len(nrow(cell_tbl)), do.call(rbind, row)$row_start))

  # Number of row in each table entry
  if (is.null(attr(cell_tbl, "cell_nrow"))) {
    table_nrow <- attr(cell_tbl, "rtf_nrow")
  } else {
    table_nrow <- attr(cell_tbl, "cell_nrow")
  }

  # Page Dictionary
  if (rtf_nrow$page - sum(rtf_nrow[-1]) < 1) {
    print(rtf_nrow)
    stop("Increase nrow in rtf_page, can not display table body")
  }


  rtf_nrow_body <- rtf_nrow
  if (page$page_title != "all") rtf_nrow_body$title <- 0
  if (page$page_footnote != "all") rtf_nrow_body$footnote <- 0
  if (page$page_source != "all") rtf_nrow_body$source <- 0

  page_dict <- data.frame(
    page_id = pageby$id[index],
    id = pageby$id[index],
    subline = pageby$id[index],
    pageby = c(diff(index) == 0, FALSE),
    nrow = table_nrow[index],
    total = rtf_nrow$page - sum(rtf_nrow_body[-1]),
    stringsAsFactors = FALSE
  )
  page_dict$nrow <- ifelse(page_dict$pageby, 1, page_dict$nrow)

  if (!is.null(attr(tbl, "rtf_by_subline")$id)) {
    page_dict$subline <- attr(cell_tbl, "rtf_by_subline")$id[index]
    page_dict$id <- paste(page_dict$id, page_dict$subline, sep = "-")
    page_dict$id <- factor(page_dict$id, levels = unique(page_dict$id))
  }

  # Define page number for each row
  page_dict_page <- function(page_dict) {
    # Page Number
    page <- cumsum(page_dict$nrow) %/% page_dict$total

    # If the last row is a page by row, move it to next row
    retain <- unlist(lapply(split(page_dict, page), function(x) {
      rev(cumsum(rev(x$pageby)) == seq_len(nrow(x)))
    }))

    page + retain + 1
  }

  ## Adjust page number if pageby$new_page is true
  new_page <- pageby$new_page | attr(tbl, "rtf_by_subline")$new_page
  if (new_page) {
    if (pageby$new_page) page_id <- page_dict$page_id
    if (attr(tbl, "rtf_by_subline")$new_page) page_id <- page_dict$subline
    if (pageby$new_page & attr(tbl, "rtf_by_subline")$new_page) page_id <- page_dict$id

    page_dict$page <- unlist(lapply(split(page_dict, page_id), page_dict_page))
    page_dict$page <- as.numeric(page_id) * 1e6 + page_dict$page
  } else {
    page_dict$page <- page_dict_page(page_dict)
  }

  page_dict$index <- cumsum(!page_dict$pageby)

  # Move to next page for footnote and data source
  total_all <- rtf_nrow$page - sum(rtf_nrow[-1])
  if (sum(page_dict$nrow[page_dict$page == tail(page_dict$page, 1)]) > total_all) {
    page_dict$page[c(-2:0) + nrow(page_dict)] <- page_dict$page[c(-2:0) + nrow(page_dict)] + 1
  }

  page_dict_db <- subset(page_dict, !pageby)

  if (new_page & pageby_column) {
    split_id <- paste0(page_dict_db$id, page_dict_db$page)
  } else {
    split_id <- page_dict_db$page
  }

  ## Remove repeated records if group_by is not null
  if (!is.null(group_by)) {
    tmp <- cell_tbl
    tmp$`.pageby` <- pageby$id
    tmp$`.order` <- seq_len(nrow(tmp))
    tmp <- rtf_group_by_enhance(tmp,
      group_by = c(".pageby", group_by),
      page_index = subset(page_dict, !pageby)$page
    )

    stopifnot(all(seq_len(nrow(tmp)) == tmp$`.order`))
    tmp <- tmp[ , ! names(tmp) %in% c(".pageby", ".order"), drop = FALSE]
    attributes(tmp) <- attributes(cell_tbl)
    cell_tbl <- tmp
  }

  # Add border type for first and last row
  page_dict_first <- do.call(rbind, lapply(split(page_dict_db, split_id), function(x) x[1, ]))
  page_dict_last <- do.call(rbind, lapply(split(page_dict_db, split_id), function(x) x[nrow(x), ]))

  if ((!is.null(attr(cell_tbl, "border_first"))) & pageby_column) {
    attr(cell_tbl, "border_top")[page_dict_first$index, ] <- attr(cell_tbl, "border_first")[page_dict_first$index, ]
  }

  if (!is.null(attr(cell_tbl, "border_last"))) {
    attr(cell_tbl, "border_bottom")[page_dict_last$index, ] <- attr(cell_tbl, "border_last")[page_dict_last$index, ]
  }
  if ((!is.null(attr(cell_tbl, "border_color_first"))) & pageby_column) {
    attr(cell_tbl, "border_color_top")[page_dict_first$index, ] <- attr(cell_tbl, "border_color_first")[page_dict_first$index, ]
  }

  if (!is.null(attr(cell_tbl, "border_color_last"))) {
    attr(cell_tbl, "border_color_bottom")[page_dict_last$index, ] <- attr(cell_tbl, "border_color_last")[page_dict_last$index, ]
  }


  # Encode RTF
  rtf_row_list <- lapply(pageby_row, rtf_table_content,
    col_total_width = col_width,
    use_border_bottom = TRUE
  )

  rtf_table <- rtf_table_content(cell_tbl,
    col_total_width = col_width,
    use_border_bottom = TRUE
  )

  # Order Section Title
  rtf_row <- do.call(cbind, rtf_row_list)
  rtf_row <- rtf_row[, order(row_index$row_start, -row_index$row_end)]

  if (is.null(ncol(rtf_row))) rtf_row <- as.matrix(rtf_row)
  # Combine Section Title and Table body
  rtf <- c()
  rtf[!page_dict$pageby] <- apply(rtf_table, 2, paste, collapse = "\n")

  rtf_row_encode <- apply(rtf_row, 2, paste, collapse = "\n")
  rtf[page_dict$pageby] <- rtf_row_encode

  page_dict$index <- seq_len(nrow(page_dict))

  if (pageby$pageby_header) {
    # Show pageby header at the top of each page

    ## Define Pageby header
    pageby_header <- lapply(split(page_dict, page_dict$page), function(x) {
      x[1, ]
    })
    pageby_header <- do.call(rbind, pageby_header)

    pageby_dict <- subset(page_dict, pageby)

    pageby_header <- merge(pageby_dict[, c("page_id", "id", "pageby", "nrow", "total")],
      subset(pageby_header, !pageby)[, c("page_id", "id", "subline", "page", "index")],
      all.y = TRUE
    )
    pageby_header$index <- pageby_header$index - 0.1
    pageby_header <- pageby_header[order(pageby_header$index), ]

    rtf_pageby_header <- lapply(split(pageby_header, pageby_header$page), function(x) {
      rtf_row_encode[which(pageby_dict$page_id %in% x$page_id)]
    })
    rtf_pageby_header <- unlist(rtf_pageby_header)

    # Restructure page_dict to add pageby header
    page_dict <- rbind(page_dict, pageby_header)
    page_dict_order <- order(page_dict$index)
    page_dict <- page_dict[page_dict_order, ]
    page_dict$index <- seq_len(nrow(page_dict))

    # Restructure rtf encoding
    rtf <- c(rtf, rtf_pageby_header)[page_dict_order]
  }

  ## Define Nested Header
  if (rtf_nrow$pageby > 1 & pageby$pageby_header & max(page_dict$page) > 1) {
    # Identify page with non-nested header
    pageby_header <- lapply(
      split(page_dict, page_dict$page),
      function(x) {
        if (nrow(x) < 2) stop("The page contain now table. Try to increase nrow in rtf_page")
        if (!x[2, "pageby"]) {
          return(x[1, ])
        }
      }
    )

    pageby_header <- do.call(rbind, pageby_header)

    if (!is.null(pageby_header)) {
      # By variable dictionary

      if (!is.null(attr(tbl, "rtf_by_subline")$id)) {
        by_var <- unique(c(pageby$by_var, attr(tbl, "rtf_by_subline")$by_var))
      } else {
        by_var <- pageby$by_var
      }

      by_var_dict <- unique(tbl[, by_var])
      by_var_dict$id <- apply(by_var_dict, 1, paste, collapse = "-")



      pageby_header_nested <- merge(pageby_header, by_var_dict, all.x = TRUE)
      pageby_header_nested$index <- pageby_header_nested$index - 0.1

      # RTF encode for nested header
      rtf_header_nested <- rep("", nrow(pageby_header))

      for (i in seq_len(rtf_nrow$pageby - 1)) {
        rtf_nested_index <- pageby_header_nested[[pageby$by_var[[i]]]]

        rtf_nested <- apply(rtf_row_list[[i]], 2, paste, collapse = "\n")
        names(rtf_nested) <- pageby_row[[i]]$x

        rtf_header_nested <- paste(rtf_header_nested, rtf_nested[rtf_nested_index], sep = "\n")
      }

      # Restructure page_dict to add pageby nested header
      page_dict <- rbind(page_dict, pageby_header_nested[, names(page_dict)])
      page_dict_order <- order(page_dict$index)
      page_dict <- page_dict[page_dict_order, ]
      page_dict$index <- seq_len(nrow(page_dict))

      # Restructure rtf encoding
      rtf <- c(rtf, rtf_header_nested)[page_dict_order]
    }
  }

  # Remove lines with "-----"
  rtf_index <- page_dict$index[!(page_dict$page_id == "-----" & page_dict$pageby)]
  rtf <- rtf[rtf_index]
  page_dict <- page_dict[rtf_index, ]
  page_dict$index <- seq_len(nrow(page_dict))

  attr(rtf, "info") <- page_dict
  rtf
}
