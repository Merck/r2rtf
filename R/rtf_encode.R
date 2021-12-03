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

#' Render to RTF Encoding
#'
#' This function extracts table/figure attributes and render to RTF encoding that is ready to save
#'     to an RTF file.
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Input check for doc_type ("table" or "figure").
#'    \item Input check for title, footnote and source position ("all", "first" or "last").
#'    \item If doc_type is "table" and class is data.frame then run \code{rtf_encode_table(tbl)}.
#'    \item If doc_type is "table" and class is list then run \code{rtf_encode_list(tbl)}.
#'    \item If doc_type is "figure" then run \code{rtf_encode_figure(tbl)}.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @name rtf_encode
#' @param tbl A data frame for table or a list of binary string for figure.
#' @param doc_type The doc_type of input, default is table.
#' @param page_title A character of title displaying location.
#'                   Possible values are "first", "last" and "all".
#' @param page_footnote A character of title displaying location.
#'                   Possible values are "first", "last" and "all".
#' @param page_source A character of title displaying location.
#'                   Possible values are "first", "last" and "all".
#' @param verbose a boolean value to return more details of RTF encoding.
#'
#' @return
#'     For \code{rtf_encode}, a vector of RTF code.
#'     For \code{write_rtf}, no return value.
#'
#' @examples
#'
#' library(dplyr) # required to run examples
#'
#' # Example 1
#' head(iris) %>%
#'   rtf_body() %>%
#'   rtf_encode() %>%
#'   write_rtf(file = file.path(tempdir(), "table1.rtf"))
#'
#' # Example 2
#' \dontrun{
#' library(dplyr) # required to run examples
#' file <- file.path(tempdir(), "figure1.png")
#' png(file)
#' plot(1:10)
#' dev.off()
#'
#' # Read in PNG file in binary format
#' rtf_read_figure(file) %>%
#'   rtf_figure() %>%
#'   rtf_encode(doc_type = "figure") %>%
#'   write_rtf(file = file.path(tempdir(), "figure1.rtf"))
#' }
#' # Example 3
#'
#' ## convert tbl_1 to the table body. Add title, subtitle, two table
#' ## headers, and footnotes to the table body.
#' data(r2rtf_tbl2)
#' ## convert r2rtf_tbl2 to the table body. Add a table column header to table body.
#' t2 <- r2rtf_tbl2 %>%
#'   rtf_colheader(
#'     colheader = "Pairwise Comparison |
#'                    Difference in LS Mean(95% CI)\\dagger | p-Value",
#'     text_justification = c("l", "c", "c")
#'   ) %>%
#'   rtf_body(
#'     col_rel_width = c(8, 7, 5),
#'     text_justification = c("l", "c", "c"),
#'     last_row = FALSE
#'   )
#' # concatenate a list of table and save to an RTF file
#' t2 %>%
#'   rtf_encode() %>%
#'   write_rtf(file.path(tempdir(), "table2.rtf"))
#' @rdname rtf_encode
#'
#' @export
rtf_encode <- function(tbl,
                       doc_type = "table",
                       page_title = "all",
                       page_footnote = "last",
                       page_source = "last",
                       verbose = FALSE) {
  match_arg(doc_type, c("table", "figure"))
  match_arg(page_title, c("all", "first", "last"))
  match_arg(page_footnote, c("all", "first", "last"))
  match_arg(page_source, c("all", "first", "last"))

  if (doc_type == "table") {
    if (any(class(tbl) %in% "list")) {

      for(i in 1:length(tbl)){
        attr(tbl[[i]], "page")$page_title <- page_title
        attr(tbl[[i]], "page")$page_footnote <- page_footnote
        attr(tbl[[i]], "page")$page_source <- page_source
        # attr(tbl[[i]], "rtf_title") <- attr(tbl[[1]], "rtf_title")
      }
      return(rtf_encode_list(tbl))

    }

    if (any(class(tbl) %in% "data.frame")) {

      attr(tbl, "page")$page_title <- page_title
      attr(tbl, "page")$page_footnote <- page_footnote
      attr(tbl, "page")$page_source <- page_source

      return(rtf_encode_table(tbl, verbose = verbose))
    }
  }

  if (doc_type == "figure") {
    return(rtf_encode_figure(tbl))
  }
}
