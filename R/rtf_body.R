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

#' @title Add Table Body Attributes to the Table
#'
#' @param tbl A data frame.
#' @param as_colheader A boolean value to indicate whether to add default column header to the table.
#'                  Default is TRUE to use data frame column names as column header.
#' @param col_rel_width Column relative width in a vector e.g. c(2,1,1) refers to 2:1:1.
#'                      Default is NULL for equal column width.
#' @param text_convert A logical value to convert special characters.
#' @param group_by A character vector of variable names in `tbl`.
#' @param page_by Column names in a character vector to group by table in sections.
#' @param new_page A boolean value to indicate whether to separate grouped table into pages
#'                 by sections. Default is FALSE.
#' @param pageby_header A boolean value to display `pageby` header at the beginning of each page.
#' Default is `TRUE`. If the value is `FALSE`, the `pageby` header is displayed in the first page of the `pageby`
#' group. The special `pageby` value `"-----"` is to avoid displaying a `pageby` header for this group.
#' @param pageby_row A character vector of location of page_by variable. Possible input are 'column'
#' or 'first_row'.
#' @param subline_by Column names in a character vector to subline by table in sections.
#' @param last_row A boolean value to indicate whether the table contains the last row of the
#'                 final table.
#' @inheritParams rtf_footnote
#' @inheritParams rtf_page
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Validate if input tbl argument is of type data.frame.
#'    \item Validate if input column relative width argument is of type integer or numeric.
#'    \item Validate if input column header argument is of type logical.
#'    \item Validate if input border and border color arguments are of type character.
#'    \item Validate if input border width and cell height arguments are of type integer or numeric.
#'    \item Validate if input cell justification argument is of type character.
#'    \item Validate if input text font, font size, space before and space after arguments are of type integer or numeric.
#'    \item Validate if input text format, color, background color and justification arguments are of type character.
#'    \item Validate if input group by and page by arguments are of type character.
#'    \item Validate if input new page, pageby header and last row arguments are of type integer or numeric.
#'    \item Validate if input border left, right, top, bottom, first and last arguments are valid using \code{border_type()$name}.
#'    \item Validate if input border color left, right, top, bottom, first and last arguments are valid using \code{colors()}.
#'    \item Validate if input text color and background color arguments are valid using \code{colors()}.
#'    \item Validate if input cell justification and text justification arguments are valid using \code{justification()$type}.
#'    \item Validate if input text font argument is valid using \code{font_type()$type}.
#'    \item Validate if input text format argument is valid using \code{font_format()$type}.
#'    \item Validate if input border width, cell height and text font size arguments are greater than 0.#'
#'    \item Validate if input text space before and text space after arguments are greater than or equal to 0.
#'    \item Add default page attributes if missing for input table data frame using \code{rtf_page()}.
#'    \item Add page attribute use_color as TRUE if the input text, background or border color arguments are not black.
#'    \item Add column header attribute rtf_colheader if input column header argument is TRUE using \code{rtf_colheader()}.
#'    \item Add black as default text color attribute if input text background color argument is not NULL and text color argument is NULL.
#'    \item Define matrices of same dimensions as input table data frame for non missing input arguments for border top, bottom, left, right, first and last.
#'    \item Define matrices of same dimensions as input table data frame for non missing input arguments for border color top, bottom, left, right, first and last.
#'    \item Define matrices of same dimensions as input table data frame for non missing input arguments for text font, format, color, background color, justification and font size.
#'    \item Add the defined matrices as attributes to input table data frame.
#'    \item Define pageby attributes using input page by, new page, pageby header arguments and \code{rtf_pageby()}.
#'    \item Define table body attributes of \code{tbl} based on the input.
#'    \item Return \code{tbl}.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @return the same data frame \code{tbl} with additional attributes for table body
#'
#' @examples
#' library(dplyr) # required to run examples
#' data(r2rtf_tbl1)
#' r2rtf_tbl1 |>
#'   rtf_body(
#'     col_rel_width = c(3, 1, 3, 1, 3, 1, 3, 5),
#'     text_justification = c("l", rep("c", 7)),
#'     last_row = FALSE
#'   ) |>
#'   attributes()
#' @export
rtf_body <- function(tbl,
                     col_rel_width = rep(1, ncol(tbl)),
                     as_colheader = TRUE,
                     border_left = "single",
                     border_right = "single",
                     border_top = NULL,
                     border_bottom = NULL,
                     border_first = "single",
                     border_last = "single",
                     border_color_left = NULL,
                     border_color_right = NULL,
                     border_color_top = NULL,
                     border_color_bottom = NULL,
                     border_color_first = NULL,
                     border_color_last = NULL,
                     border_width = 15,
                     cell_height = 0.15,
                     cell_justification = "c",
                     cell_vertical_justification = "top",
                     cell_nrow = NULL,
                     text_font = 1,
                     text_format = NULL,
                     text_font_size = 9,
                     text_color = NULL,
                     text_background_color = NULL,
                     text_justification = NULL,
                     text_indent_first = 0,
                     text_indent_left = 0,
                     text_indent_right = 0,
                     text_space = 1,
                     text_space_before = 15,
                     text_space_after = 15,
                     text_convert = TRUE,
                     group_by = NULL,
                     page_by = NULL,
                     new_page = FALSE,
                     pageby_header = TRUE,
                     pageby_row = "column",
                     subline_by = NULL,
                     last_row = TRUE) {
  # Check argument type
  check_args(tbl, type = c("data.frame"))

  check_args(col_rel_width, type = c("integer", "numeric"))
  check_args(as_colheader, type = c("logical"))

  check_args(group_by, type = c("character"))

  check_args(page_by, type = c("character"))
  check_args(new_page, type = c("logical"))
  check_args(pageby_header, type = c("logical"))
  check_args(pageby_row, type = c("character"))

  check_args(last_row, type = c("logical"))

  # Check valid value
  match_arg(group_by, names(tbl), several.ok = TRUE)
  match_arg(page_by, names(tbl), several.ok = TRUE)
  match_arg(pageby_row, c("first_row", "column"))

  # Convert tbl to a data frame, each column is a character
  if (any(class(tbl) %in% "data.frame")) tbl <- as.data.frame(tbl, stringsAsFactors = FALSE)

  # Sort data in proper order if subline_by, page_by or group_by is used.
  by_var <- c(subline_by, page_by, group_by)

  if (pageby_row == "first_row") {
    by_var1 <- c(subline_by, page_by)
    if (length(by_var) > 1) {
      id_i <- apply(tbl[, by_var1], 1, paste, collapse = "-")
    } else {
      id_i <- tbl[, by_var1]
    }

    pageby_nrow <- as.numeric(table(id_i))

    if (any(pageby_nrow <= 1)) {
      stop("first_row can not be used if a group only have one record")
    }
  }

  if (!is.null(by_var)) {
    if (length(by_var) != length(unique(by_var))) stop("Variables in subline_by, page_by and group_by can not be overlapped")

    # Define Index
    # for(i in 1:length(by_var)){
    #   if(class(tbl[[by_var[i]]]) == "character"){
    #     tbl[[by_var[i]]] <- factor(tbl[[by_var[i]]], levels = unique(tbl[[by_var[i]]]))
    #   }
    # }

    for (i in 1:length(by_var)) {
      if (i == 1) {
        id <- tbl[[by_var[i]]]
      } else {
        id <- apply(tbl[, by_var[1:i]], 1, paste, collapse = "-")
      }

      order_var <- order(factor(id, levels = unique(id)))
      if (!all(order_var == 1:nrow(tbl))) {
        stop("Data is not sorted by ", paste(by_var, collapse = ", "))
      }
    }
  }

  # Redefine value to character
  for (i in 1:ncol(tbl)) {
    tbl[[i]] <- as.character(tbl[[i]])
  }

  # Set Default Page Attributes
  if (is.null(attr(tbl, "page"))) {
    tbl <- rtf_page(tbl)
  }

  # Set Default Value for Boarder Top and Bottom
  if (is.null(border_top)) {
    top_null <- TRUE
    border_top <- rep("", ncol(tbl))

    if (pageby_row == "column") {
      border_top[names(tbl) %in% page_by] <- "single"
    }
  } else {
    top_null <- FALSE
  }

  if (is.null(border_bottom)) {
    bottom_null <- TRUE
    border_bottom <- rep("", ncol(tbl))

    if (pageby_row == "column") {
      border_bottom[names(tbl) %in% page_by] <- "single"
    }
  } else {
    bottom_null <- FALSE
  }

  # Set Default Value for Text Justification
  if (is.null(text_justification)) {
    text_justification <- rep("c", ncol(tbl))
    text_justification[names(tbl) %in% c(subline_by, page_by)] <- "l"
  }

  ## check whether to add column header or not
  if (as_colheader == TRUE) {
    if (is.null(attr(tbl, "rtf_colheader"))) {
      col_name <- attr(tbl, "names")[!names(tbl) %in% c(subline_by, page_by)]
      tbl <- rtf_colheader(tbl, colheader = paste(col_name, collapse = " | "))
    }
  } else {
    tbl <- rtf_colheader(tbl, colheader = NULL)
  }

  # Define text attributes
  tbl <- obj_rtf_text(tbl,
    text_font,
    text_format,
    text_font_size,
    text_color,
    text_background_color,
    text_justification,
    text_indent_first,
    text_indent_left,
    text_indent_right,
    text_space = 1,
    text_space_before,
    text_space_after,
    text_new_page = FALSE,
    text_hyphenation = TRUE,
    text_convert = text_convert
  )
  if (attr(tbl, "use_color")) attr(tbl, "page")$use_color <- TRUE

  # Define border attributes
  tbl <- obj_rtf_border(
    tbl,
    border_left,
    border_right,
    border_top,
    border_bottom,
    border_first,
    border_last,
    border_color_left,
    border_color_right,
    border_color_top,
    border_color_bottom,
    border_color_first,
    border_color_last,
    border_width = border_width,
    cell_height = cell_height,
    cell_justification = cell_justification,
    cell_vertical_justification = cell_vertical_justification,
    cell_nrow = cell_nrow
  )
  if (attr(tbl, "use_color")) attr(tbl, "page")$use_color <- TRUE

  # Add Additional Attributions
  attr(tbl, "col_rel_width") <- col_rel_width

  attr(tbl, "rtf_groupby") <- group_by

  attr(tbl, "last_row") <- last_row

  # Sublineby Attributes
  tbl <- rtf_by_subline(tbl, subline_by = subline_by)

  # Pageby Attributes
  tbl <- rtf_pageby(tbl,
    page_by = page_by,
    new_page = new_page,
    pageby_header = pageby_header,
    pageby_row = pageby_row
  )

  tbl
}
