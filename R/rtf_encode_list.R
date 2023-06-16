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

#' Render List to RTF Encoding
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Collect color attributes from \code{tbl} object.
#'    \item Initiate RTF using \code{as_rtf_init()}, \code{as_rtf_font()} and color syntax obtained from previous step.
#'    \item Translate all \code{tbl} attributes into RTF syntax.
#'    \item Combine all components into a single RTF code string.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @inheritParams rtf_encode
#'
#' @noRd
rtf_encode_list <- function(tbl) {
  # Page Input checking
  page <- lapply(tbl, function(x) attr(x, "page"))
  width <- length(unique(lapply(page, function(x) x$width))) > 1
  height <- length(unique(lapply(page, function(x) x$height))) > 1
  orientation <- length(unique(lapply(page, function(x) x$orientation))) > 1
  use_color <- length(unique(lapply(page, function(x) x$use_color))) > 1

  if (width) {
    stop("Page width must be the same")
  }
  if (height) {
    stop("Page height must be the same")
  }
  if (orientation) {
    stop("Page orientation must be the same")
  }

  page_title <- unlist(unique(lapply(page, function(x) x$page_title)))
  page_footnote <- unlist(unique(lapply(page, function(x) x$page_footnote)))
  page_source <- unlist(unique(lapply(page, function(x) x$page_source)))
  if (length(page_title) > 1) {
    stop("Table title location must be the same")
  }
  if (length(page_footnote) > 1) {
    stop("Table footnote location must be the same")
  }
  if (length(page_source) > 1) {
    stop("Table source location must be the same")
  }
  if (page_title != "all") {
    stop("Only page_title = 'all' is supported in list")
  }
  if (page_footnote != "last") {
    stop("Only page_footnote = 'last' is supported in list")
  }
  if (page_source != "last") {
    stop("Only page_source = 'last' is supported in list")
  }

  # Number of tbls
  n <- length(tbl)
  if (n < 2) {
    stop("The length of input list must >= 2")
  }

  # Footnote and Data Source
  tbl[2:n] <- lapply(tbl[2:n], function(x) {
    if (!is.null(attr(x, "rtf_footnote"))) {
      message("Only rtf_footnote in first item is used")
    }

    if (!is.null(attr(x, "rtf_source"))) {
      message("Only rtf_source in first item is used")
    }

    attr(x, "page")$nrow <- attr(tbl[[1]], "page")$nrow
    x
  })

  if (n > 2) {
    tbl[2:(n - 1)] <- lapply(tbl[2:(n - 1)], function(x) {
      attr(x, "page")$border_first <- NULL
      attr(x, "page")$border_last <- NULL
      attr(x, "page")$border_color_first <- NULL
      attr(x, "page")$border_color_last <- NULL
      x
    })
  }

  attr(tbl[[1]], "page")$border_last <- NULL
  attr(tbl[[1]], "page")$border_color_last <- NULL
  attr(tbl[[1]], "page")$use_color <- use_color
  attr(tbl[[n]], "page")$border_first <- NULL
  attr(tbl[[n]], "page")$border_color_first <- NULL
  attr(tbl[[n]], "rtf_footnote") <- attr(tbl[[1]], "rtf_footnote")
  attr(tbl[[n]], "rtf_source") <- attr(tbl[[1]], "rtf_source")
  attr(tbl[[1]], "rtf_footnote") <- NULL
  attr(tbl[[1]], "rtf_source") <- NULL

  # Split page if necessary
  item <- 0
  iter <- 0
  item_next <- tbl[[1]]
  while (nrow(item_next) > 0) {
    if (item == 0) {
      # Render first time
      encode <- lapply(tbl, rtf_encode_table, verbose = TRUE)
    } else {
      index <- item_next$index[item_next$page1 == item_next$page1[1]]

      tbl0 <- list()
      tbl0[[1]] <- rtf_subset(tbl[[item - iter]], row = index)
      tbl0[[2]] <- rtf_subset(tbl[[item - iter]], row = -index)

      # Update border
      attr(tbl0[[1]], "page")$border_last <- NULL
      attr(tbl0[[1]], "page")$border_color_last <- NULL
      attr(tbl0[[1]], "rtf_title") <- NULL
      attr(tbl0[[1]], "rtf_footnote") <- NULL
      attr(tbl0[[1]], "rtf_source") <- NULL
      encode0 <- c(encode[1:(item - 1)], lapply(tbl0, rtf_encode_table, verbose = TRUE))

      if (item < length(encode)) {
        encode0 <- c(encode0, encode[(item + 1):n])
      }

      encode <- encode0

      iter <- iter + 1
    }

    # Split page
    info <- list()
    for (i in 1:length(encode)) {
      info[[i]] <- data.frame(item = i, encode[[i]]$info)
    }
    info <- do.call(rbind, info)

    info$total <- min(info$total)

    info$page1 <- page_dict_page(info)

    page1 <- info[info$page == 1, ]
    page1 <- split(page1, page1$item)
    item1 <- which(unlist(lapply(page1, function(x) length(unique(x$page1)))) > 1)[1]
    if (is.na(item1)) {
      item1 <- 0
    }
    item_next <- info[info$item == item1 & info$page == 1, ]
    item <- item1
  }


  start <- encode[[1]]$start
  new_page_rtftext <- as_rtf_new_page()


  body <- lapply(encode, function(x) {
    n_page <- length(x$body)
    paste(
      x$page,
      x$margin,
      x$header,
      x$subline,
      x$sublineby,
      x$colheader,
      x$body,
      x$footnote,
      x$source,
      c(rep(new_page_rtftext, n_page - 1), ""),
      sep = "\n"
    )
  })

  # add page break
  break_index <- lapply(split(info, info$page1), function(x) {
    unique(x$item)[-length(unique(x$item))]
  })
  break_index <- sort(unique(unlist(break_index)))

  page_break <- rep(new_page_rtftext, length(body))
  page_break[c(break_index, length(body))] <- ""

  for (i in 1:length(body)) {
    body[[i]] <- c(body[[i]], page_break[i])
  }
  body <- paste(unlist(body), collapse = "\n")
  rtf <- list(start = start, body = body, end = as_rtf_end())

  rtf
}
