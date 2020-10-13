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

#' Render List to RTF encoding
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
rtf_encode_list <- function(tbl,
                            page_title    = "all",
                            page_footnote = "last",
                            page_source   = "last"){

  color_rtftext <- lapply(tbl, as_rtf_color)

  start_rtf <- paste(

    as_rtf_init(),
    as_rtf_font(),
    unlist(unique(color_rtftext)),
    sep = "\n"
  )

  rtf_feature <- paste(

    as_rtf_page(tbl[[1]]),

    as_rtf_margin(tbl[[1]]),

    paste(unlist(lapply(tbl, function(x) as_rtf_title(x))), sep = "\n"),

    paste(unlist(lapply(tbl, function(x) as_rtf_subline(x))), sep = "\n"),

    paste(unlist(lapply(tbl, function(x) {
      paste(
        paste(unlist(as_rtf_colheader(x)), collapse = "\n"),
        paste(as_rtf_table(x), collapse = "\n"),
        sep = "\n"
      )
    })),
    collapse = "\n"
    ),

    paste(unlist(lapply(tbl, function(x) as_rtf_footnote(x))), sep = ""),

    paste(unlist(lapply(tbl, function(x) as_rtf_source(x))), sep = ""),
    sep = "\n"
  )

  rtf_feature <- paste(unlist(rtf_feature), collapse = "\n")

  rtf <- list(start = start_rtf, body = rtf_feature, end = as_rtf_end())

  rtf


}
