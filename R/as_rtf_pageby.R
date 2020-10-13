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

#' RTF Table Page By Encoding
#'
#' @param tbl a data frame
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
as_rtf_pageby <- function(tbl){

  pageby       <- attr(tbl, "rtf_pageby")
  pageby_row   <- attr(tbl, "rtf_pageby_row")
  group_by     <- attr(tbl, "rtf_groupby")
  col_width    <- attr(tbl, "page")$col_width

  # Get number of row for each entry
  row <- lapply(pageby_row, function(x) attr(x, "row"))
  row_index <- do.call(rbind, row)

  rtf_nrow <- data.frame(
    page =        attr(tbl, "page")$nrow,
    pageby =      length(row),
    title =       ifelse(is.null(attr(tbl, "rtf_title")),     0, length(attr(tbl, "rtf_title"))),
    subline =     ifelse(is.null(attr(tbl, "rtf_subline")),   0, length(attr(tbl, "rtf_subline"))),
    col_header =  ifelse(is.null(attr(tbl, "rtf_colheader")), 0, length(attr(tbl, "rtf_colheader"))),
    footnote =    ifelse(is.null(attr(tbl, "rtf_footnote")),  0, length(attr(tbl, "rtf_footnote"))),
    source =      ifelse(is.null(attr(tbl, "rtf_source")),    0, length(attr(tbl, "rtf_source")))
  )

  # Identify Table Content
  if(is.null(attr(tbl, "rtf_pageby_table"))){
    cell_tbl <- tbl
  }else{
    cell_tbl <- attr(tbl, "rtf_pageby_table")
  }

  # Number of rows in cells based on column size
  index = sort(c(1:nrow(cell_tbl), do.call(rbind, row)$row_start))

  ## actual column width
  width <- col_width * attr(cell_tbl, "col_rel_width") / sum(attr(cell_tbl, "col_rel_width"))

  ## text font size is 1/72 inch height
  ## default font height and width ratio is 1.65
  cell_nrow <- apply(cell_tbl, 2, nchar) * attr(cell_tbl, "text_font_size") / width / 72 / 1.65

  ##  maximum num of rows in cells per line
  table_nrow <- ceiling(apply(cell_nrow, 1, max, na.rm = TRUE))
  table_nrow <- ifelse(is.na(table_nrow), 0, table_nrow)

  # Page Dictionary
  page_dict <- data.frame(
    id = pageby$id[index],
    pageby = c(diff(index) == 0, FALSE),
    nrow = table_nrow[index],
    total = rtf_nrow$page - sum(rtf_nrow[-1])
  )
  page_dict$nrow <- ifelse(page_dict$pageby, 1, page_dict$nrow)

  # Define page number for each row
  page_dict_page <- function(page_dict){
    # Page Number
    page <- cumsum(page_dict$nrow) %/% page_dict$total

    # If the last row is a page by row, move it to next row
    retain <- unlist(lapply( split(page_dict, page), function(x){
      rev(cumsum(rev(x$pageby)) == 1:nrow(x))
    }))

    page + retain + 1
  }

    ## Adjust page number if pageby$new_page is true
  if(pageby$new_page){
    page_dict$page <- unlist(lapply(split(page_dict, page_dict$id), page_dict_page))
    page_dict$page <- as.numeric(page_dict$id) * 1e6 + page_dict$page
  }else{
    page_dict$page <- page_dict_page(page_dict)
  }

  page_dict$index <- cumsum(! page_dict$pageby)
  page_dict_db <- subset(page_dict, ! pageby)

  if(pageby$new_page){
    split_id <- paste0(page_dict_db$id, page_dict_db$page)
  }else{
    split_id <- page_dict_db$page
  }

    ## Remove repeated records if group_by is not null
  if(! is.null(group_by)){
    cell_tbl <- remove_group_by(cell_tbl,
                                group_by = group_by,
                                page = subset(page_dict, ! pageby)$page)
  }

  # Add border type for first and last row
  page_dict_first <- do.call(rbind, lapply( split(page_dict_db, split_id), function(x) x[1,] ))
  page_dict_last  <- do.call(rbind, lapply( split(page_dict_db, split_id), function(x) x[nrow(x),] ))

  if(! is.null(attr(cell_tbl, "border_first"))){
    attr(cell_tbl, "border_top")[page_dict_first$index, ]   <- attr(cell_tbl, "border_first")[page_dict_first$index, ]
  }

  if(! is.null(attr(cell_tbl, "border_last"))){
    attr(cell_tbl, "border_bottom")[page_dict_last$index, ] <- attr(cell_tbl, "border_last")[page_dict_last$index, ]
  }
  if(! is.null(attr(cell_tbl, "border_color_first"))){
    attr(cell_tbl, "border_color_top")[page_dict_first$index, ]   <- attr(cell_tbl, "border_color_first")[page_dict_first$index, ]
  }

  if(! is.null(attr(cell_tbl, "border_color_last"))){
    attr(cell_tbl, "border_color_bottom")[page_dict_last$index, ]   <- attr(cell_tbl, "border_color_last")[page_dict_last$index, ]
  }


  # Encode RTF
  rtf_row_list <- lapply(pageby_row, rtf_table_content,
                    col_total_width = col_width,
                    use_border_bottom = TRUE)

  rtf_table <- rtf_table_content(cell_tbl,
                                  col_total_width = col_width,
                                  use_border_bottom = TRUE)

  # Order Section Title
  rtf_row   <- do.call(cbind, rtf_row_list)
  rtf_row   <- rtf_row[, order(row_index$row_start, -row_index$row_end)]

  if(is.null(ncol(rtf_row))) rtf_row <- as.matrix(rtf_row)
  # Combine Section Title and Table body
  rtf <- c()
  rtf[! page_dict$pageby]  <- apply(rtf_table, 2, paste, collapse = "\n")

  rtf_row_encode <- apply(rtf_row, 2, paste, collapse = "\n")
  rtf[page_dict$pageby] <- rtf_row_encode

  page_dict$index <- 1:nrow(page_dict)

  if(pageby$pageby_header){
    # Show pageby header at the top of each page

      ## Define Pageby header
    pageby_header <- lapply(split(page_dict, page_dict$page), function(x){x[1, ]})
    pageby_header <- do.call(rbind, pageby_header)

    pageby_dict <- subset(page_dict, pageby)

    pageby_header <- merge(pageby_dict[, c("id", "pageby", "nrow", "total")],
                           subset(pageby_header, !pageby)[, c("id", "page", "index")], all.y = TRUE)
    pageby_header$index <- pageby_header$index - 0.1
    pageby_header <- pageby_header[order(pageby_header$index), ]

    rtf_pageby_header <- lapply(split(pageby_header, pageby_header$page), function(x){ rtf_row_encode[ which( pageby_dict$id %in% x$id) ]})
    rtf_pageby_header <- unlist(rtf_pageby_header)

    # Restructure page_dict to add pageby header
    page_dict <- rbind(page_dict, pageby_header)
    page_dict_order <- order(page_dict$index)
    page_dict <- page_dict[page_dict_order, ]
    page_dict$index <- 1:nrow(page_dict)

    # Restructure rtf encoding
    rtf <- c(rtf, rtf_pageby_header)[page_dict_order]
  }

  ## Define Nested Header
  if(rtf_nrow$pageby > 1 & pageby$pageby_header & max(page_dict$page) > 1 ){

    # Identify page with non-nested header
    pageby_header <- lapply(split(page_dict, page_dict$page),
                            function(x){if(! x[2, "pageby"]) x[1, ]})

    pageby_header <- do.call(rbind, pageby_header)

    if(! is.null(pageby_header)){
      # By variable dictionary
      by_var_dict    <- unique(tbl[, pageby$by_var])
      by_var_dict$id <- apply(by_var_dict, 1, paste, collapse = "-")
      pageby_header_nested  <- merge(pageby_header, by_var_dict, all.x = TRUE)
      pageby_header_nested$index <-  pageby_header_nested$index - 0.1

      # RTF encode for nested header
      rtf_header_nested <- rep("", nrow(pageby_header))
      for(i in 1:(rtf_nrow$pageby - 1)){

        rtf_nested_index <- pageby_header_nested[[pageby$by_var[[i]]]]

        rtf_nested <- apply(rtf_row_list[[i]], 2, paste, collapse = "\n")
        names(rtf_nested) <- pageby_row[[i]]$x

        rtf_header_nested <- paste(rtf_header_nested, rtf_nested[rtf_nested_index], sep = "\n")

      }

      # Restructure page_dict to add pageby nested header
      page_dict <- rbind(page_dict, pageby_header_nested[, names(page_dict)])
      page_dict_order <- order(page_dict$index)
      page_dict <- page_dict[page_dict_order, ]
      page_dict$index <- 1:nrow(page_dict)

      # Restrcuture rtf encoding
      rtf <- c(rtf, rtf_header_nested)[page_dict_order]
    }


  }

  ## Group By Feature
  ## Remove duplicate records within a page



  attr(rtf, "info") <- page_dict
  rtf

}

