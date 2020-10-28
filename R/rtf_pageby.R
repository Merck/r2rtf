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

#' @title Add Table Body Pageby Attributes to the Table
#'
#' @inheritParams rtf_body
#'
rtf_pageby <- function(tbl, page_by, new_page, pageby_header){

  if(is.null(page_by)){

    if(new_page){ stop("new_page must be FALSE if page_by is not specified")}

    attr(tbl, "rtf_pageby") <- list(new_page = new_page,
                                    by_var = NULL,
                                    id = NULL)
  }else{

    by <- page_by
    # Define Index
    if(length(by) > 1){
      id <- apply( tbl[, by], 1, paste, collapse = "-")
    }else{
      id <- tbl[, by]
    }

    id <- factor(id, levels = unique(id))

    order_var <- order(id)
    index_var <- which( names(tbl) %in% by )

    if( ! all(order_var == 1:nrow(tbl)) ){
      stop("Data is not sorted by ", paste(by, collapse = ", ") )
    }

    # Collect attributes by type
    attr_matrix <- attributes(tbl)[c("border_top", "border_left", "border_right", "border_bottom", "border_first", "border_last",
                                     "border_color_left", "border_color_right", "border_color_top", "border_color_bottom",
                                     "border_color_first", "border_color_last",
                                     "text_font", "text_format", "text_font_size", "text_color",
                                     "text_background_color", "text_justification", "text_convert", "cell_nrow")]
    attr_matrix <- attr_matrix[! is.na(names(attr_matrix))]

    attr_scale  <- attributes(tbl)[c("border_width", "cell_height", "cell_justification",
                                     "text_space_before", "text_space_after")]

    db <- list()
    for(i in 1:length(by)){

      by_i <- by[1:i]

      if(length(by_i) > 1){
        id_i <- apply( tbl[, by_i], 1, paste, collapse = "-")
      }else{
        id_i <- tbl[, by_i]
      }

      id_i <- factor(id_i, levels = unique(id_i))

      # start, end and number of row
      row <- data.frame(nrow = as.numeric(table(id_i)))
      row$row_end  <-  cumsum(row$nrow)
      row$row_start <- with(row, row_end - nrow + 1 )

      # Split information for each row


      db[[i]] <- data.frame(x = tbl[row$row_start, by_i[i]])

      attributes(db[[i]]) <- append( attributes(db[[i]]),
                                lapply(attr_matrix, function(x) if(!is.null(x)) as.matrix(x[row$row_start, index_var[i]]) )
                                )

      attributes(db[[i]]) <- append( attributes(db[[i]]), attr_scale)


      attr(db[[i]], "col_rel_width") <- attr(tbl, "col_rel_width")[index_var[i]]
      attr(db[[i]], "row") <- row
    }
    names(db) <- by

    # re-arrange source data columns
    db_table <- tbl[, - index_var]
    attributes(db_table) <- append( attributes(db_table),
                              lapply(attr_matrix, function(x) if(!is.null(x)) matrix(x[, -index_var], nrow = nrow(x))))

    attributes(db_table) <- append( attributes(db_table), attr_scale)

    attr(db_table, "col_rel_width") <- attr(tbl, "col_rel_width")[-index_var]
    attr(db_table, "row") <- row

    attr(tbl, "rtf_pageby_row")   <- db
    attr(tbl, "rtf_pageby_table") <- db_table
    attr(tbl, "rtf_pageby")       <- list(by_var = by,
                                          new_page = new_page,
                                          id = id,
                                          pageby_header = pageby_header)
  }

  tbl

}
