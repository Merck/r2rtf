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

#' Render Figure to RTF Encoding
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Collect footnote attributes from \code{tbl} object.
#'    \item Define page, margin, header, footnote, source and new_page in RTF syntax.
#'    \item Define page height and width in RTF syntax.
#'    \item Initiate RTF using \code{as_rtf_init()} and \code{as_rtf_font()}.
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
#'
rtf_encode_figure <- function(tbl) {
  # Footnote always be free text in figures
  page <- attr(tbl, "page")
  footnote <- attr(tbl, "rtf_footnote")

  if (!is.null(footnote)) {
    attr(footnote, "as_table") <- FALSE
    attr(tbl, "rtf_footnote") <- footnote
  }
  ## get rtf code for page, margin, header, footnote, source, new_page
  page_rtftext <- as_rtf_page(tbl)
  margin_rtftext <- as_rtf_margin(tbl)
  header_rtftext <- as_rtf_title(tbl)
  subline_rtftext <- as_rtf_subline(tbl)
  footnote_rtftext <- as_rtf_footnote(tbl)
  source_rtftext <- as_rtf_source(tbl)
  new_page_rtftext <- as_rtf_new_page()

  ## get rtf code for figure width and height
  fig_width <- attr(tbl, "fig_width")
  fig_height <- attr(tbl, "fig_height")

  ## get rtf code for figure format
  fig_format <- fig_format()
  fig_format <- factor(attr(tbl, "fig_format"), levels = fig_format$type, labels = fig_format$rtf_code)

  rtf_fig <- paste0(
    "{\\pict", fig_format, "\\picwgoal",
    round(fig_width * 1440), "\\pichgoal",
    round(fig_height * 1440), " ", lapply(tbl, paste, collapse = ""), "}"
  )

  start_rtf <- paste(
    as_rtf_init(),
    as_rtf_font(),
    sep = "\n"
  )

  n_page <- length(tbl)
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
    last  = c(rep("", n_page - 1), footnote_rtftext),
    all   = rep(footnote_rtftext, n_page)
  )

  # Source RTF encoding by page
  source_rtftext <- switch(page$page_source,
    first = c(source_rtftext, rep("", n_page - 1)),
    last  = c(rep("", n_page - 1), source_rtftext),
    all   = rep(source_rtftext, n_page)
  )

  rtf_feature <- paste(
    page_rtftext,
    margin_rtftext,
    header_rtftext,
    subline_rtftext,
    rtf_fig,
    rtf_paragraph(""), # new line after figure
    footnote_rtftext,
    source_rtftext,
    c(rep(new_page_rtftext, length(rtf_fig) - 1), ""),
    sep = "\n"
  )

  rtf_feature <- paste(rtf_feature, collapse = "\n")

  ## Post Processing
  rtf_feature <- gsub("\\totalpage", n_page, rtf_feature, fixed = TRUE) # total page number

  list(start = start_rtf, body = rtf_feature, end = as_rtf_end())
}
