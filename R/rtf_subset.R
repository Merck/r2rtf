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

#' @title Pass Table Attributes to Subset Table
#'
#' @description
#' Pass original table attributes assigned through like `rtf_page`, `rtf_title`, `rtf_body`... to subsetted table
#' because original attributes won't be automatically carried over.
#'
#' @param tbl A data frame with attributes.
#' @param row a numeric vector for the row index to keep in the subsetted data.
#' @param col a numeric vector for the column index to keep in the subsetted data.
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item \code{tbl} is a data frame with attributes to be subsetted.
#'    \item Return a data frame \code{tbl_sub} subsetted from \code{tbl} with original table attributes.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @return the subsetted data frame \code{tbl_sub} with original attributes from \code{tbl}
#'
#' @examples
#' library(dplyr)
#' data(r2rtf_tbl1)
#' sub_table <- r2rtf_tbl1 %>%
#'              rtf_body() %>%
#'              r2rtf:::rtf_subset(row=1:2, col=c(1, 4:5))
#'
#' attributes(sub_table)
rtf_subset <- function(tbl,
                       row = 1:nrow(tbl),
                       col = 1:ncol(tbl)){

  # Check argument type
  check_args(tbl, type = c("data.frame"))
  check_args(row, type = c("integer", "numeric"))
  check_args(col, type = c("integer", "numeric"))

  # collect all attributes name from input data frame
  attr_all <- names(attributes(tbl))

  # collect border and text attributes
  attr_matrix <- attributes(tbl)[c(
    "border_top", "border_left", "border_right", "border_bottom", "border_first", "border_last",
    "border_color_left", "border_color_right", "border_color_top", "border_color_bottom",
    "border_color_first", "border_color_last",
    "text_font", "text_format", "text_font_size", "text_color",
    "text_background_color", "text_justification", "text_convert", "cell_nrow"
  )]
  attr_matrix <- attr_matrix[!is.na(names(attr_matrix))]

  # collect scale attributes
  attr_scale <- attributes(tbl)[c(
    "border_width", "cell_height", "cell_justification",
    "text_space_before", "text_space_after"
  )]

  # collect all other attributes
  attr_other <- attr_all[! attr_all %in% c(names(attr_matrix), names(attr_scale),
                                           "col_rel_width", "names", "row.names", "class")]


  # pass attributes to subset data frame
  tbl_sub <- tbl[row, col]
  if(! "data.frame" %in% class(tbl_sub)){
    tbl_sub <- data.frame(x = tbl_sub)
  }
  attributes(tbl_sub) <- append(
    attributes(tbl_sub),
    lapply(attr_matrix, function(x) if (!is.null(x)) as.matrix(x[row, col]))
  )

  attributes(tbl_sub) <- append(attributes(tbl_sub), attr_scale)
  attributes(tbl_sub) <- append(attributes(tbl_sub), attributes(tbl)[attr_other])

  attr(tbl_sub, "col_rel_width") <- attr(tbl, "col_rel_width")[col]

  tbl_sub
}

