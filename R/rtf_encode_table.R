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

#' Render Table to RTF encoding
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Initiate RTF using \code{as_rtf_init()}, \code{as_rtf_font()} and \code{as_rtf_color()}.
#'    \item Define page, margin, header, footnote, source and new_page in RTF syntax.
#'    \item Define column header, first border and last border type in RTF syntax.
#'    \item Check whether footnote and source will be displayed as table if they exist.
#'    \item Define table content in RTF syntax.
#'    \item Get page title display location ("all", "first", "last") from arg input and display it in page accordinly.
#'    \item Get page footnote display location ("all", "first", "last") from arg input and display it in page accordinly.
#'    \item Get page source display location ("all", "first", "last") from arg input and display it in page accordinly.
#'    \item Translate all \code{tbl} attributes into RTF syntax.
#'    \item Combine all components into a single RTF code string.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @inheritParams rtf_encode
#'
rtf_encode_table <- function(tbl,
                             page_title    = "all",
                             page_footnote = "last",
                             page_source   = "last") {

    start_rtf <- paste(

      as_rtf_init(),
      as_rtf_font(),
      as_rtf_color(tbl),
      sep = "\n"
    )

    ## get rtf code for page, margin, header, footnote, source, new_page
    page_rtftext     <- as_rtf_page(tbl)
    margin_rtftext   <- as_rtf_margin(tbl)
    header_rtftext   <- as_rtf_title(tbl)
    subline_rtftext <- as_rtf_subline(tbl)
    footnote_rtftext <- as_rtf_footnote(tbl)
    source_rtftext   <- as_rtf_source(tbl)
    new_page_rtftext <- as_rtf_new_page()

    ## rtf encode for column header
    colheader_rtftext <- as_rtf_colheader(tbl)

    ## Define first border type of the whole table with column header
    colheader <- attr(tbl, "rtf_colheader")
    if(length(colheader) > 0){
      head <- attributes(colheader[[1]])$border_top
      attributes(colheader[[1]])$border_top <- matrix( attr(tbl, "page")$border_first, nrow = 1, ncol = ncol(head))

      if(! is.null(attr(tbl, "page")$border_color_first)){
        attributes(colheader[[1]])$border_color_top <- matrix( attr(tbl, "page")$border_color_first, nrow = 1, ncol = ncol(head))
      }

      colheader_rtftext_1 <- lapply(colheader, rtf_table_content,
                         col_total_width = attr(tbl, "page")$col_width
      )

      colheader_rtftext_1 <- unlist(colheader_rtftext_1)
    }else{
      colheader_rtftext_1 <- as_rtf_colheader(tbl)
    }
    colheader_rtftext <- paste(unlist(colheader_rtftext), collapse = "\n")
    colheader_rtftext_1 <- paste(unlist(colheader_rtftext_1), collapse = "\n")


    ## Define last border type of the whole table
    footnote   <- attr(tbl, "rtf_footnote")
    tbl_source <- attr(tbl, "rtf_source")
    source_rtftext_1 <- source_rtftext
    footnote_rtftext_1 <- footnote_rtftext

    if(is.null(footnote)){
      footnote_as_table <- FALSE
    }else{
      footnote_as_table <- attr(footnote, "as_table")
    }

    if(is.null(tbl_source)){
      source_as_table <- FALSE
    }else{
      source_as_table <- attr(tbl_source, "as_table")
    }

    if( source_as_table ){

      # Data Source table as last row
      attr(tbl_source, "border_bottom") <- attr(tbl, "page")$border_last
      attr(tbl, "rtf_source") <- tbl_source
      source_rtftext_1 <- as_rtf_source(tbl)

    } else if(footnote_as_table){

      # Footnote table as last row
      attr(footnote, "border_bottom") <- attr(tbl, "page")$border_last
      attr(tbl, "rtf_footnote") <- footnote
      footnote_rtftext_1 <- as_rtf_footnote(tbl)

    }else{

      pageby <- attr(tbl, "rtf_pageby")
      n <- nrow(tbl)
      if(is.null(pageby$by_var)){
        attr(tbl, "border_last")[n, ] <- matrix( attr(tbl, "page")$border_last, nrow = 1, ncol = ncol(attr(tbl, "border_bottom")))
        if(! is.null(pageby$border_color_last)){
          attr(tbl, "border_color_last")[n, ] <- matrix( attr(tbl, "page")$border_color_last,
                                                           nrow = n, ncol = ncol(attr(tbl, "border_color_bottom")))
        }

      }else{
        tbl_pageby <- attr(tbl, "rtf_pageby_table")
        attr(tbl_pageby, "border_last")[n, ] <- matrix( attr(tbl, "page")$border_last, nrow = 1, ncol = ncol(attr(tbl_pageby, "border_bottom")))
        if(! is.null(pageby$border_color_last)){
          attr(tbl_pageby, "border_color_last")[n, ] <- matrix( attr(tbl, "page")$border_color_last,
                                                                  nrow = 1, ncol = ncol(attr(tbl_pageby, "border_color_bottom")))
        }
        attr(tbl, "rtf_pageby_table") <- tbl_pageby
      }

    }

    ## RTF encode for table body
    pageby <- attr(tbl, "rtf_pageby")

    if(is.null(pageby$by_var)){
      table_rtftext <- as_rtf_table(tbl)
    }else{
      table_rtftext <- as_rtf_pageby(tbl)
    }

    info   <- attr(table_rtftext, "info")

    if(pageby$new_page){
      body_rtftext <- tapply(table_rtftext, paste0(info$id, info$page), FUN = function(x) paste(x, collapse = "\n"))
    }else{
      body_rtftext <- tapply(table_rtftext, info$page, FUN = function(x) paste(x, collapse = "\n"))
    }

    n_page <- length(body_rtftext)

    # Page Title Display Location
    if(page_title == "first"){
      if(! is.null(header_rtftext)) header_rtftext <- c(header_rtftext, rep("", n_page - 1))
      if(! is.null(subline_rtftext)) subline_rtftext <- c(subline_rtftext, rep("", n_page - 1))
    }

    if(page_title == "last"){
      if(! is.null(header_rtftext))  header_rtftext <- c(rep("", n_page - 1), header_rtftext)
      if(! is.null(subline_rtftext)) subline_rtftext <- c(rep("", n_page - 1), subline_rtftext)
    }

    # Page Title Display Location
    if(page_footnote == "first"){
      footnote_rtftext <- c(footnote_rtftext, rep("", n_page - 1))
    }

    if(page_footnote == "last"){
      footnote_rtftext <- c(rep("", n_page - 1), footnote_rtftext_1)
    }

    if(page_footnote == "all"){
      footnote_rtftext <- c( rep(footnote_rtftext, n_page - 1), footnote_rtftext_1)
    }

    # Page Title Display Location
    if(page_source == "first"){
      source_rtftext <- c(source_rtftext, rep("", n_page - 1))
    }

    if(page_source == "last"){
      source_rtftext <- c(rep("", n_page - 1), source_rtftext_1)
    }

    if(page_source == "all"){
      source_rtftext <- c( rep(source_rtftext, n_page - 1), source_rtftext_1)
    }


    rtf_feature <- paste(
      page_rtftext,
      margin_rtftext,
      header_rtftext,
      subline_rtftext,
      c( colheader_rtftext_1, rep(colheader_rtftext, n_page - 1)),
      body_rtftext,
      footnote_rtftext,
      source_rtftext,
      c( rep(new_page_rtftext, n_page - 1), ""),
      sep = "\n"
    )

    rtf_feature <- paste(unlist(rtf_feature), collapse = "\n")

    rtf <- list(start = start_rtf, body = rtf_feature, end = as_rtf_end())

    rtf
}

