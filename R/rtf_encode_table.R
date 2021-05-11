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

#' Render Table to RTF Encoding
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Initiate RTF using \code{as_rtf_init()}, \code{as_rtf_font()} and \code{as_rtf_color()}.
#'    \item Define page, margin, header, footnote, source and new_page in RTF syntax.
#'    \item Define column header, first border and last border type in RTF syntax.
#'    \item Check whether footnote and source will be displayed as table if they exist.
#'    \item Define table content in RTF syntax.
#'    \item Get page title display location ("all", "first", "last") from arg input and display it in page accordingly.
#'    \item Get page footnote display location ("all", "first", "last") from arg input and display it in page accordingly.
#'    \item Get page source display location ("all", "first", "last") from arg input and display it in page accordingly.
#'    \item Translate all \code{tbl} attributes into RTF syntax.
#'    \item Combine all components into a single RTF code string.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @inheritParams rtf_encode
#' @param verbose a boolean value to return more details of RTF encoding.
#'
rtf_encode_table <- function(tbl, verbose = FALSE) {

  # Update First and Last Border
  tbl_1  <- update_border_first(tbl)
  tbl_1  <- update_border_last(tbl_1)

  # Get content
  page <- attr(tbl, "page")
  pageby <- attr(tbl, "rtf_pageby")

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
  subline_rtftext  <- as_rtf_subline(tbl)


  new_page_rtftext <- as_rtf_new_page()

  ## rtf encode for column header
  colheader_rtftext_1 <- paste(unlist(as_rtf_colheader(tbl_1)), collapse = "\n")  # First page
  colheader_rtftext   <- paste(unlist(as_rtf_colheader(tbl)), collapse = "\n")   # Rest of page

  ## rtf encode for footnote
  footnote_rtftext_1  <- paste(as_rtf_footnote(tbl_1), collapse = "\n")    # Last page
  footnote_rtftext    <- paste(as_rtf_footnote(tbl), collapse = "\n")      # Rest of pages

  ## rtf encode for source
  source_rtftext_1    <- paste(as_rtf_source(tbl_1), collapse = "\n")      # Last page
  source_rtftext      <- paste(as_rtf_source(tbl), collapse = "\n")        # Rest of pages

  ## RTF encode for table body
  if (is.null(pageby$by_var)) {
    table_rtftext <- as_rtf_table(tbl_1)
  } else {
    table_rtftext <- as_rtf_pageby(tbl_1)
  }

  ## RTF encoding for subline_by row
  info <- attr(table_rtftext, "info")

  if(is.null(attr(tbl, "rtf_by_subline")$by_var) ){
    sublineby_rtftext <- NULL
  }else{
    info_dict <- unique(info[, c("subline", "page")])
    sublineby_index <- as.numeric(factor(info_dict$subline, levels = unique(info_dict$subline)))

    sublineby_rtftext <- as_rtf_paragraph(attr(tbl, "rtf_by_subline_row"), combine = FALSE)

    if(! is.null(dim(sublineby_rtftext))){
      sublineby_rtftext <- apply(sublineby_rtftext, 1, paste, collapse = "\n")
    }

    sublineby_rtftext <- sublineby_rtftext[sublineby_index]
  }

  # if (pageby$new_page) {
  #   body_rtftext <- tapply(table_rtftext, paste0(info$id, info$page), FUN = function(x) paste(x, collapse = "\n"))
  # } else {
    body_rtftext <- tapply(table_rtftext, info$page, FUN = function(x) paste(x, collapse = "\n"))
  # }

  n_page <- length(body_rtftext)

  # Page Title Display Location
  if (page$page_title == "first") {
    if (!is.null(header_rtftext)) header_rtftext <- c(header_rtftext, rep("", n_page - 1))
    if (!is.null(subline_rtftext)) subline_rtftext <- c(subline_rtftext, rep("", n_page - 1))
  }

  if (page$page_title == "last") {
    if (!is.null(header_rtftext)) header_rtftext <- c(rep("", n_page - 1), header_rtftext)
    if (!is.null(subline_rtftext)) subline_rtftext <- c(rep("", n_page - 1), subline_rtftext)
  }

  # Title RTF encoding by page

  # Footnote RTF encoding by page
  footnote_rtftext <- switch(page$page_footnote,
                             first = c(footnote_rtftext, rep("", n_page - 1)),
                             last  = c(rep("", n_page - 1), footnote_rtftext_1),
                             all   = c(rep(footnote_rtftext, n_page - 1), footnote_rtftext_1) )

  # Source RTF encoding by page
  source_rtftext <- switch(page$page_source,
                           first = c(source_rtftext, rep("", n_page - 1)),
                           last  = c(rep("", n_page - 1), source_rtftext_1),
                           all   = c(rep(source_rtftext, n_page - 1), source_rtftext_1))


  # Combine RTF body encoding
  rtf_feature <- paste(
    page_rtftext,
    margin_rtftext,
    header_rtftext,
    subline_rtftext,
    sublineby_rtftext,
    c(colheader_rtftext_1, rep(colheader_rtftext, n_page - 1)),
    body_rtftext,
    footnote_rtftext,
    source_rtftext,
    c(rep(new_page_rtftext, n_page - 1), ""),
    sep = "\n"
  )

  rtf_feature <- paste(unlist(rtf_feature), collapse = "\n")

  ## Post Processing for total page number
  rtf_feature <- gsub("\\totalpage", n_page, rtf_feature, fixed = TRUE) # total page number


  if(verbose){
    rtf <- list(start     = start_rtf,
                page      = page_rtftext,
                margin    = margin_rtftext,
                header    = header_rtftext,
                subline   = subline_rtftext,
                sublineby = sublineby_rtftext,
                colheader = c(colheader_rtftext_1, rep(colheader_rtftext, n_page - 1)),
                body      = body_rtftext,
                footnote  = footnote_rtftext,
                source    = source_rtftext,
                end       = end,
                info      = info
        )
  }else{
    rtf <- list(start = start_rtf, body = rtf_feature, end = as_rtf_end())
  }

  rtf
}
