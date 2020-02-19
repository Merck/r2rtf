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



#' @title Add title attributes to the table
#'
#' @description
#' add title, subtitle, and other attributes to the object
#' @param gt_tbl a data frame
#' @param title title string
#' @param subtitle subtitle string
#' @param font text font type
#' @param font_size text font size
#' @param format  text format
#' @param color text color
#' @param background_color text background color
#' @param justification justification for text
#' @param indent_first first indent
#' @param indent_left  left indent
#' @param indent_right right indent
#' @param space paragraph space
#' @param space_before line space before text
#' @param space_after  line space after text
#' @param new_page boolean value to indicate whether to start a new page
#' @param hyphenation boolean value to indicate whether to use hyphenation
#'
#' @export
rtf_title <- function(gt_tbl,

                      title = NULL,
                      subtitle = NULL,

                      font = 1,
                      format = NULL,
                      font_size = 12,
                      color = NULL,
                      background_color = NULL,
                      justification = "c",

                      indent_first = 0,
                      indent_left  = 0,
                      indent_right = 0,

                      space = 1,
                      space_before = 180,
                      space_after = 180,

                      new_page = FALSE,
                      hyphenation = TRUE){


  if ("rtf_heading" %in% names(attributes(gt_tbl))) {

    attr(gt_tbl, "rtf_heading")$title <- c(attr(gt_tbl, "rtf_heading")$title, title)
    attr(gt_tbl, "rtf_heading")$subtitle <- c(attr(gt_tbl, "rtf_heading")$subtitle, subtitle)


  } else {

    attr(gt_tbl, "rtf_heading") <- list(title = title, subtitle = subtitle)

  }


  attr(gt_tbl, "rtf_heading")$font               <- font
  attr(gt_tbl, "rtf_heading")$format             <- format
  attr(gt_tbl, "rtf_heading")$font_size          <- font_size
  attr(gt_tbl, "rtf_heading")$color              <- color
  attr(gt_tbl, "rtf_heading")$background_color   <- background_color
  attr(gt_tbl, "rtf_heading")$justification      <- justification
  attr(gt_tbl, "rtf_heading")$indent_first       <- indent_first
  attr(gt_tbl, "rtf_heading")$indent_left        <- indent_left
  attr(gt_tbl, "rtf_heading")$indent_right       <- indent_right
  attr(gt_tbl, "rtf_heading")$space              <- space
  attr(gt_tbl, "rtf_heading")$space_before       <- space_before
  attr(gt_tbl, "rtf_heading")$space_after        <- space_after
  attr(gt_tbl, "rtf_heading")$new_page           <- new_page
  attr(gt_tbl, "rtf_heading")$hyphenation        <- hyphenation



  gt_tbl

}




#' @title Add footnote attributes to the table
#'
#' @param gt_tbl a data frame
#' @param footnote footnote text
#' @param font text font type
#' @param font_size text font size
#' @param format  text format
#' @param color text color
#' @param background_color text background color
#' @param justification justification for text
#' @param indent_first first indent
#' @param indent_left  left indent
#' @param indent_right right indent
#' @param space paragraph space
#' @param space_before line space before text
#' @param space_after  line space after text
#' @param new_page boolean value to indicate whether to start a new page
#' @param hyphenation boolean value to indicate whether to use hyphenation
#'
#' @export
rtf_footnote <- function(gt_tbl,

                         footnote = NULL,

                         font = 1,
                         format = NULL,
                         font_size = 9,
                         color = NULL,
                         background_color = NULL,
                         justification = "c",

                         indent_first = 0,
                         indent_left  = 0,
                         indent_right = 0,

                         space = 1,
                         space_before = 0,
                         space_after = 0,

                         new_page = FALSE,
                         hyphenation = TRUE){


  if ("rtf_footnote" %in% names(attributes(gt_tbl))) {

    attr(gt_tbl, "rtf_footnote")$footnote <- c(attr(gt_tbl, "rtf_footnote")$footnote, footnote)

  } else {

    attr(gt_tbl, "rtf_footnote") <- list(footnote = footnote)
  }


  if (justification == "l") {
    indent_left <- .footnote_source_space(gt_tbl)
  } else if (justification == "r") {
    indent_right  <- .footnote_source_space(gt_tbl)
  }



  attr(gt_tbl, "rtf_footnote")$font               <- font
  attr(gt_tbl, "rtf_footnote")$format             <- format
  attr(gt_tbl, "rtf_footnote")$font_size          <- font_size
  attr(gt_tbl, "rtf_footnote")$color              <- color
  attr(gt_tbl, "rtf_footnote")$background_color   <- background_color
  attr(gt_tbl, "rtf_footnote")$justification      <- justification
  attr(gt_tbl, "rtf_footnote")$indent_first       <- indent_first
  attr(gt_tbl, "rtf_footnote")$indent_left        <- indent_left
  attr(gt_tbl, "rtf_footnote")$indent_right       <- indent_right
  attr(gt_tbl, "rtf_footnote")$space              <- space
  attr(gt_tbl, "rtf_footnote")$space_before       <- space_before
  attr(gt_tbl, "rtf_footnote")$space_after        <- space_after
  attr(gt_tbl, "rtf_footnote")$new_page           <- new_page
  attr(gt_tbl, "rtf_footnote")$hyphenation        <- hyphenation


  gt_tbl
}





#' @title Add data source attributes to the table
#'
#' @param gt_tbl A data frame
#' @param source data source text
#' @param font text font type
#' @param font_size text font size
#' @param format  text format
#' @param color text color
#' @param background_color text background color
#' @param justification justification for text
#' @param indent_first first indent
#' @param indent_left  left indent
#' @param indent_right right indent
#' @param space paragraph space
#' @param space_before line space before text
#' @param space_after  line space after text
#' @param new_page boolean value to indicate whether to start a new page
#' @param hyphenation boolean value to indicate whether to use hyphenation
#'
#' @export
rtf_source <- function(gt_tbl,

                       source = NULL,

                       font = 1,
                       format = NULL,
                       font_size = 9,
                       color = NULL,
                       background_color = NULL,
                       justification = "c",

                       indent_first = 0,
                       indent_left  = 0,
                       indent_right = 0,

                       space = 1,
                       space_before = 0,
                       space_after = 0,

                       new_page = FALSE,
                       hyphenation = TRUE){


  if ("rtf_source" %in% names(attributes(gt_tbl))) {

    attr(gt_tbl, "rtf_source")$source <- c(attr(gt_tbl, "rtf_source")$source, source)

  } else {

    attr(gt_tbl, "rtf_source") <- list(source = source)
  }

  if (justification == "l") {
    indent_left <- .footnote_source_space(gt_tbl)
  } else if (justification == "r") {
    indent_right  <- .footnote_source_space(gt_tbl)
  }

  attr(gt_tbl, "rtf_source")$font               <- font
  attr(gt_tbl, "rtf_source")$format             <- format
  attr(gt_tbl, "rtf_source")$font_size          <- font_size
  attr(gt_tbl, "rtf_source")$color              <- color
  attr(gt_tbl, "rtf_source")$background_color   <- background_color
  attr(gt_tbl, "rtf_source")$justification      <- justification
  attr(gt_tbl, "rtf_source")$indent_first       <- indent_first
  attr(gt_tbl, "rtf_source")$indent_left        <- indent_left
  attr(gt_tbl, "rtf_source")$indent_right       <- indent_right
  attr(gt_tbl, "rtf_source")$space              <- space
  attr(gt_tbl, "rtf_source")$space_before       <- space_before
  attr(gt_tbl, "rtf_source")$space_after        <- space_after
  attr(gt_tbl, "rtf_source")$new_page           <- new_page
  attr(gt_tbl, "rtf_source")$hyphenation        <- hyphenation


  gt_tbl

}


#' Add page attributes to the table
#'
#' @param gt_tbl A data frame
#' @param page_width A numeric number to indicate page width.
#' @param page_height A numeric number to indicate page height.
#' @param orientation Orientation in 'portrait' or 'landscape'.
#'
#' @noRd
.rtf_page_size <- function(gt_tbl,
                           page_width,
                           page_height,
                           orientation) {

  if (!is.numeric(page_width)) {
    stop("input page_width must be a numeric number")
  }

  if (!is.numeric(page_height)) {
    stop("input page_height must be a numeric number")
  }


  if (!orientation %in% c("portrait","landscape")){
    stop("input orientation must be 'portrait' or 'landscape' ")
  }

  attr(gt_tbl, "page_width")  <- page_width
  attr(gt_tbl, "page_height") <- page_height
  attr(gt_tbl, "orientation") <- orientation

  gt_tbl
}



#' Add margin attributes to the table
#'
#' @param gt_tbl A data frame
#' @param doctype doctype in 'csr', 'wma', 'wmm' or 'narrow'
#' @param orientation Orientation in 'portrait' or 'landscape'.
#'
#' @noRd
.rtf_page_margin <- function(gt_tbl,
                             doctype,
                             orientation) {

  if (!doctype %in% c("csr", "wma", "wmm", "narrow")){
    stop("input doctype must be 'csr', 'wma', 'wmm' or 'narrow' ")
  }


  if (!orientation %in% c("portrait","landscape")){
    stop("input orientation must be 'portrait' or 'landscape' ")
  }


  attr(gt_tbl, "doctype")  <- doctype

  gt_tbl
}





#' @title Add column header to the table
#'
#' @param gt_tbl A data frame
#' @param colheader A string that uses " | " to separate column names.
#' @param border_left left border type
#' @param border_right right border type
#' @param border_top top border type
#' @param border_bottom bottom border type
#' @param border_color_left left border color
#' @param border_color_right right border color
#' @param border_color_top top border color
#' @param border_color_bottom bottom border color
#' @param border_width worder width in twips
#' @param cell_justification justification for cell
#' @param col_rel_width column relative width in a vector eg. c(2,1,1) refers to 2:1;1
#' @param page_width page width in inches
#' @param col_total_width column total width for the table
#' @param cell_height height for cell in twips
#' @param text_justification justification for text
#' @param text_font text font type
#' @param text_font_size text font size
#' @param text_format  text format
#' @param text_color text color
#' @param text_background_color text background color
#' @param text_space_before line space before text
#' @param text_space_after  line space after text
#' @param first_row boolean value to indicate whether column header is the first row of the table
#'
#' @export
rtf_colheader <- function(gt_tbl,

                          colheader             = NULL,

                          border_left           = "single",
                          border_right          = "single",
                          border_top            = NULL,
                          border_bottom         = "",

                          border_color_left     = NULL,
                          border_color_right    = NULL,
                          border_color_top      = NULL,
                          border_color_bottom   = NULL,

                          border_width          = 15,
                          cell_justification    = "c",

                          col_rel_width         = NULL,
                          page_width            = 8.5,
                          col_total_width       = page_width/1.4,
                          cell_height           = 0.15,

                          text_justification    = "c",
                          text_font             = 1,
                          text_format           =  NULL,
                          text_color            = NULL,
                          text_background_color = NULL,
                          text_font_size        = 9,
                          text_space_before     = 15,
                          text_space_after      = 15,

                          first_row             = FALSE


) {

  if (colheader == "") {

    attr(gt_tbl, "rtf_colheader")$colheader  <- NULL
    attr(gt_tbl, "rtf_colheader")$first_row  <- first_row

  } else if (!is.null(colheader)){

    colheader <- data.frame( t(trimws(unlist(strsplit(colheader, "|", fixed = TRUE)))))

    n_row = nrow(colheader)
    n_col = ncol(colheader)

    # Set default value for column width
    if (is.null(col_rel_width)){
      col_rel_width <- NA
    }

    ## Border top post processing for new page
    if(is.null(border_top)){
      border_top = ""
      border_post = TRUE
    }else{
      border_post = FALSE
    }

    # Set default value for text color if background color presented
    if(is.null(text_color) & ! is.null(text_background_color)){
      text_color <- "black"
    }

    # Transer vector to matrix by row
    foo <- function(x){
      if( (is.null(dim(x))) & (! is.null(x) ) ){
        x <- matrix(x, nrow = n_row, ncol = n_col, byrow = TRUE)
      }
      x
    }


    border_top            <- foo(border_top)
    border_left           <- foo(border_left)
    border_right          <- foo(border_right)
    border_bottom         <- foo(border_bottom)

    border_color_left     <- foo(border_color_left)
    border_color_right    <- foo(border_color_right)
    border_color_top      <- foo(border_color_top)
    border_color_bottom   <- foo(border_color_bottom)

    text_font             <- foo(text_font)
    text_format           <- foo(text_format)
    text_color            <- foo(text_color)
    text_background_color <- foo(text_background_color)
    text_justification    <- foo(text_justification)
    text_font_size        <- foo(text_font_size)


    # Update to matrix format
    if (border_post) {

      if (length(.get_colheader(gt_tbl)) == 0 && first_row == TRUE) {
        border_top[1,] <-  rep("double", n_col)
      } else {
        border_top[1,] <-  rep("single", n_col)
      }

    }

    attr(gt_tbl, "rtf_colheader")$col_rel_width         <- c(attr(gt_tbl, "rtf_colheader")$col_rel_width, list(col_rel_width))
    attr(gt_tbl, "rtf_colheader")$colheader             <- c(attr(gt_tbl, "rtf_colheader")$colheader, list(colheader))
    attr(gt_tbl, "rtf_colheader")$border_left           <- c(attr(gt_tbl, "rtf_colheader")$border_left, list(border_left))
    attr(gt_tbl, "rtf_colheader")$border_right          <- c(attr(gt_tbl, "rtf_colheader")$border_right, list(border_right))
    attr(gt_tbl, "rtf_colheader")$border_top            <- c(attr(gt_tbl, "rtf_colheader")$border_top, list(border_top))
    attr(gt_tbl, "rtf_colheader")$border_bottom         <- c(attr(gt_tbl, "rtf_colheader")$border_bottom, list(border_bottom))
    attr(gt_tbl, "rtf_colheader")$border_color_left     <- c(attr(gt_tbl, "rtf_colheader")$border_color_left, list(border_color_left))
    attr(gt_tbl, "rtf_colheader")$border_color_right    <- c(attr(gt_tbl, "rtf_colheader")$border_color_right, list(border_color_right))
    attr(gt_tbl, "rtf_colheader")$border_color_bottom   <- c(attr(gt_tbl, "rtf_colheader")$border_color_bottom, list(border_color_bottom))
    attr(gt_tbl, "rtf_colheader")$border_width          <- c(attr(gt_tbl, "rtf_colheader")$border_width, list(border_width))
    attr(gt_tbl, "rtf_colheader")$cell_justification    <- c(attr(gt_tbl, "rtf_colheader")$cell_justification, list(cell_justification))
    attr(gt_tbl, "rtf_colheader")$page_width            <- c(attr(gt_tbl, "rtf_colheader")$page_width, list(page_width))
    attr(gt_tbl, "rtf_colheader")$col_total_width       <- c(attr(gt_tbl, "rtf_colheader")$col_total_width, list(col_total_width))
    attr(gt_tbl, "rtf_colheader")$cell_height           <- c(attr(gt_tbl, "rtf_colheader")$cell_height, list(cell_height))
    attr(gt_tbl, "rtf_colheader")$text_justification    <- c(attr(gt_tbl, "rtf_colheader")$text_justification, list(text_justification))
    attr(gt_tbl, "rtf_colheader")$text_font             <- c(attr(gt_tbl, "rtf_colheader")$text_font, list(text_font))
    attr(gt_tbl, "rtf_colheader")$text_format           <- c(attr(gt_tbl, "rtf_colheader")$text_format, list(text_format))
    attr(gt_tbl, "rtf_colheader")$text_color            <- c(attr(gt_tbl, "rtf_colheader")$text_color, list(text_color))
    attr(gt_tbl, "rtf_colheader")$text_background_color <- c(attr(gt_tbl, "rtf_colheader")$text_background_color, list(text_background_color))
    attr(gt_tbl, "rtf_colheader")$text_font_size        <- c(attr(gt_tbl, "rtf_colheader")$text_font_size, list(text_font_size))
    attr(gt_tbl, "rtf_colheader")$text_space_before     <- c(attr(gt_tbl, "rtf_colheader")$text_space_before, list(text_space_before))
    attr(gt_tbl, "rtf_colheader")$text_space_after      <- c(attr(gt_tbl, "rtf_colheader")$text_space_after, list(text_space_after))
    attr(gt_tbl, "rtf_colheader")$first_row             <- c(attr(gt_tbl, "rtf_colheader")$first_row, list(first_row))



  }else{
    attr(gt_tbl, "rtf_colheader")$colheader  <- NULL
  }

  gt_tbl
}


#' @title add table body attributes to the table
#'
#' @param gt_tbl A data frame
#' @param colheader A boolean value to indicate whether to add default column header to the table
#' @param page_width page width in inches
#' @param page_height page height in inches
#' @param doctype doctype in 'csr', 'wma', or 'wmm'
#' @param orientation Orientation in 'portrait' or 'landscape'
#' @param border_left left border type
#' @param border_right right border type
#' @param border_top top border type
#' @param border_bottom bottom border type
#' @param border_color_left left border color
#' @param border_color_right right border color
#' @param border_color_top top border color
#' @param border_color_bottom bottom border color
#' @param border_width worder width in twips
#' @param cell_justification justification for cell
#' @param col_rel_width column relative width in a vector eg. c(2,1,1) refers to 2:1;1
#' @param col_total_width column total width for the table
#' @param cell_height height for cell in twips
#' @param text_justification justification for text
#' @param text_font text font type
#' @param text_font_size text font size
#' @param text_format  text format
#' @param text_color text color
#' @param text_background_color text background color
#' @param text_space_before line space before text
#' @param text_space_after  line space after text
#' @param page_num number of rows in each page
#' @param page_by column names to group by table in sections
#' @param new_page a boolean value to indicate whether to separate grouped table into pages by sections
#' @param last_row a boolean value to indicate whether the table contains the last row of the final table
#'
#' @export
rtf_body <- function(gt_tbl,

                     colheader             = TRUE,

                     page_width            = 8.5,
                     page_height           = 11,
                     orientation           = "portrait",
                     doctype               = "wma",

                     border_left           = "single",
                     border_right          = "single",
                     border_top            = NULL,
                     border_bottom         = "double",

                     border_color_left     = NULL,
                     border_color_right    = NULL,
                     border_color_top      = NULL,
                     border_color_bottom   = NULL,

                     border_width          = 15,
                     col_rel_width         = NULL,
                     col_total_width       = page_width/1.4,
                     cell_height           = 0.15,
                     cell_justification    = "c",

                     text_font             = 1,
                     text_format           =  NULL,
                     text_color            = NULL,
                     text_background_color = NULL,
                     text_justification    = "c",
                     text_font_size        = 9,
                     text_space_before     = 15,
                     text_space_after      = 15,

                     page_num              = NULL,

                     page_by               = NULL,
                     new_page              = FALSE,

                     last_row              = TRUE){


  gt_tbl <- .rtf_page_size(gt_tbl,
                           page_width   = page_width,
                           page_height  = page_height,
                           orientation  = orientation
  )

  gt_tbl <- .rtf_page_margin(gt_tbl,
                             doctype = doctype,
                             orientation = orientation
  )

  ## check whether to add column header or not
  if (colheader == TRUE){

    if ( is.null(.get_colheader(gt_tbl)$colheader)){
      gt_tbl <- rtf_colheader(gt_tbl,
                              colheader = paste(attr(gt_tbl, "names"), collapse = " | " ))

    }

  }else{

    attr(gt_tbl, "rtf_colheader")$colheader <- NULL
    attr(gt_tbl, "rtf_colheader")$first_row <- FALSE
  }

  ## Border top post processing for new page
  if(is.null(border_top)){
    border_top = ""
    border_post = TRUE
  }else{
    border_post = FALSE
  }

  if ( !is.null(page_by)) {

    if (all(page_by %in% attr(gt_tbl, "names"))) {

      id  <- which(attr(gt_tbl, "names") %in% page_by)

      page_by_vars <- gt_tbl[,id]

      if (is.null(ncol(page_by_vars))){

        pageby_condition = page_by_vars

      }else{

        pageby_condition <- do.call(paste, c(page_by_vars, sep = "-"))
      }

      temp <- lapply(unique(pageby_condition), function(x){

        gt_tbl[which(pageby_condition %in% x), -id]

        })

      pageby_db <- do.call(rbind, temp)

      pageby_colheader <- unique(pageby_condition)


    } else {

      stop(paste0("page_by must be one of the following: ", paste(attr(gt_tbl, "names"), collapse = ", ")))
    }

  } else {
    pageby_db        <- data.frame(gt_tbl)
    pageby_condition <- NULL
    pageby_colheader <- NULL
  }



  n_row = nrow(pageby_db)
  n_col = ncol(pageby_db)

  # Set default value for column width
  if(is.null(col_rel_width)){
    col_rel_width <- rep(1, n_col)
  }

  # Set default value for text color if background color presented
  if(is.null(text_color) & ! is.null(text_background_color)){
    text_color <- "black"
  }

  # Transer vector to matrix by row
  foo <- function(x){
    if( (is.null(dim(x))) & (! is.null(x) ) ){
      x <- matrix(x, nrow = n_row, ncol = n_col, byrow = TRUE)
    }
    x
  }

  border_top            <- foo(border_top)
  border_left           <- foo(border_left)
  border_right          <- foo(border_right)
  border_bottom         <- foo(border_bottom)

  border_color_left     <- foo(border_color_left)
  border_color_right    <- foo(border_color_right)
  border_color_top      <- foo(border_color_top)
  border_color_bottom   <- foo(border_color_bottom)

  text_font             <- foo(text_font)
  text_format           <- foo(text_format)
  text_color            <- foo(text_color)
  text_background_color <- foo(text_background_color)
  text_justification    <- foo(text_justification)
  text_font_size        <- foo(text_font_size)

  page_num      <- .set_page_num(page_num, orientation)

  index_list    <- .pageby_db_index(pageby_db,
                                    pageby_colheader,
                                    pageby_condition,
                                    page_num,
                                    page_by,
                                    new_page)

  index_newpage <- index_list$index_newpage
  index_endpage <- index_list$index_endpage


  for (x in index_newpage){

    if (border_post) {

      if (is.null(.get_colheader(gt_tbl)$colheader) && .get_colheader(gt_tbl)$first_row == TRUE) {
        border_top[x,] <-  rep("double", n_col)
      } else {
        border_top[x,] <-  rep("single", n_col)
      }
    }
  }




  attr(gt_tbl, "border_top")              <- border_top
  attr(gt_tbl, "border_left")             <- border_left
  attr(gt_tbl, "border_right")            <- border_right
  attr(gt_tbl, "border_bottom")           <- border_bottom

  attr(gt_tbl, "border_color_left")       <- border_color_left
  attr(gt_tbl, "border_color_right")      <- border_color_right
  attr(gt_tbl, "border_color_top")        <- border_color_top
  attr(gt_tbl, "border_color_bottom")     <- border_color_bottom


  attr(gt_tbl, "border_width")            <- border_width
  attr(gt_tbl, "page_width")              <- page_width
  attr(gt_tbl, "col_total_width")         <- col_total_width
  attr(gt_tbl, "cell_height")             <- cell_height
  attr(gt_tbl, "cell_justification")      <- cell_justification
  attr(gt_tbl, "col_rel_width")           <- col_rel_width

  attr(gt_tbl, "text_font")               <- text_font
  attr(gt_tbl, "text_format")             <- text_format
  attr(gt_tbl, "text_font_size")          <- text_font_size
  attr(gt_tbl, "text_color")              <- text_color
  attr(gt_tbl, "text_background_color")   <- text_background_color
  attr(gt_tbl, "text_justification")      <- text_justification

  attr(gt_tbl, "text_space_before")       <- text_space_before
  attr(gt_tbl, "text_space_after")        <- text_space_after

  attr(gt_tbl, "page_num")                <- page_num
  attr(gt_tbl, "page_by")                 <- page_by
  attr(gt_tbl, "new_page")                <- new_page
  attr(gt_tbl, "pageby_db")               <- pageby_db
  attr(gt_tbl, "pageby_condition")        <- pageby_condition
  attr(gt_tbl, "pageby_colheader")        <- pageby_colheader
  attr(gt_tbl, "pageby_newpage_index")    <- index_newpage
  attr(gt_tbl, "pageby_endpage_index")    <- index_endpage


  attr(gt_tbl, "last_row")                <- last_row


  gt_tbl
}


