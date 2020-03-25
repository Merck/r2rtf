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

#' @description
#' rtf code to initiate an rtf table
#'
#' @noRd
.as_rtf_init <- function() {

  # The number 1033 is U.S. English
  paste("{", "\\rtf1\\ansi\n\\deff0\\deflang1033", sep = "")
}


#' rtf code to initiate an rtf table
#'
#' @noRd
.as_rtf_font <- function() {
  font_type <- .font_type()
  font_rtf <- factor(c(1, 2, 3), levels = font_type$type, labels = font_type$rtf_code)
  font_style <- factor(c(1, 2, 3), levels = font_type$type, labels = font_type$style)
  font_name <- factor(c(1, 2, 3), levels = font_type$type, labels = font_type$name)

  font_table <- paste0(
    "{\\fonttbl",
    paste(paste0("{", font_rtf, font_style, "\\fcharset161\\fprq2 ", font_name, ";}\n"), collapse = ""),
    "}\n"
  )

  font_table
}


#' convert inches to twips
#' @param inch value in inches
#'
#' @noRd
.inch_to_twip <- function(inch) {
  round(inch * 1440, 0)
}


#' create rtf color table
#' @param tbl a data frame
#'
#' @noRd
.as_rtf_color <- function(tbl) {
  rtf_color <- NULL

  color_used <- .color_used(tbl)

  if (color_used == TRUE) {
    col_tb <- .color_table()
    rtf_color <- paste(c("{\\colortbl; ", col_tb$rtf_code, "}"), collapse = "\n")
  }

  rtf_color
}



#' create rtf page size
#' @param tbl a data frame
#' @noRd
.as_rtf_page <- function(tbl) {
  page_width <- attr(tbl, "page_width")
  page_height <- attr(tbl, "page_height")
  orientation <- attr(tbl, "orientation")


  .page.size <- c("\\paperw", "\\paperh")
  .page.size <- paste(paste0(.page.size, .inch_to_twip(c(page_width, page_height))), collapse = "")


  if (orientation == "landscape") {
    .page.size <- paste0(.page.size, "\\landscape\n")
  }


  if (orientation == "portrait") {
    .page.size <- paste0(.page.size, "\n")
  }


  .page.size
}




#' set up margins (6 dimension: left, right, top, bottom, header, footer) in inches
#'
#' @param doctype doctype in 'csr', 'wma', 'wmm' or 'narrow'
#' @param orientation Orientation in 'portrait' or 'landscape'.
#'
#' @noRd
.set_omi <- function(doctype, orientation) {
  if (!doctype %in% c("csr", "wma", "wmm", "narrow")) {
    stop("input doctype must be 'csr', 'wma', 'wmm' or 'narrow' ")
  }


  if (!orientation %in% c("portrait", "landscape")) {
    stop("input orientation must be 'portrait' or 'landscape' ")
  }


  .omi <- list(
    csr = list(
      portrait = c(1.25, 1, 1.5, 1, 0.5, 0.5),
      landscape = c(0.5, 0.5, 1.27986111111111, 1.25, 1.25, 1)
    ),

    wma = list(
      portrait = c(1.25, 1, 1.75, 1.25, 1.75, 1.00625),
      landscape = c(0.5, 0.5, 2, 1.25, 1.25, 1.25)
    ),

    wmm = list(
      portrait = c(1.25, 1, 1, 1, 1.75, 1.00625),
      landscape = c(0.5, 0.5, 1.25, 1, 1.25, 1.25)
    ),

    narrow = list(
      portrait  = rep(0.5, 6),
      landscape = rep(0.5, 6)
    )
  )

  .omi[[doctype]][[orientation]]
}


#' rtf code to set up margins in twips
#' @param tbl a data frame
#' @noRd
.as_rtf_margin <- function(tbl) {
  doctype <- attr(tbl, "doctype")
  orientation <- attr(tbl, "orientation")

  .omi <- .set_omi(doctype, orientation)
  .margin <- c("\\margl", "\\margr", "\\margt", "\\margb", "\\headery", "\\footery")
  .margin <- paste(paste0(.margin, .inch_to_twip(.omi)), collapse = "")
  .margin <- paste0(.margin, "\n")

  .margin
}

#' rtf code to set up margins in twips
#'
#' @noRd
.as_rtf_newpage <- function() {
  paste("\\intbl\\row\\pard\\page\\par\\pard")
}


#' set up page_num based on orientaion
#'
#' @param page_num number of rows in each page
#' @param orientation Orientation in 'portrait' or 'landscape'.
#' @noRd
.set_page_num <- function(page_num, orientation) {
  if (is.null(page_num)) {
    if (orientation == "portrait") page_num <- 42
    if (orientation == "landscape") page_num <- 26
  }

  page_num
}

#' extract the heading attribute from a \pkg{gt} object
#'
#' @param tbl A data frame
#'
#' @noRd
.get_heading <- function(tbl) {
  gt_attr <- attributes(tbl)
  rtf_heading <- gt_attr$rtf_heading

  rtf_heading
}

#' extract the heading attribute from a \pkg{gt} object
#'
#' @param tbl A data frame
#'
#' @noRd
.footnote_source_space <- function(tbl) {
  table_width <- attr(tbl, "col_total_width")
  page_width <- attr(tbl, "page_width")
  text_space_before <- attr(tbl, "text_space_before")
  border_width <- attr(tbl, "border_width")
  doctype <- attr(tbl, "doctype")
  orientation <- attr(tbl, "orientation")


  page_width <- .inch_to_twip(page_width)
  left_margin <- .inch_to_twip(.set_omi(doctype, orientation)[1])
  right_margin <- .inch_to_twip(.set_omi(doctype, orientation)[2])
  table_width <- .inch_to_twip(table_width)

  space_adjust <- round((page_width - left_margin - right_margin - table_width) / 2)


  space_adjust
}



#' check whether color is used in a data frame
#'
#' @param tbl A data frame
#'
#' @noRd
.color_used <- function(tbl) {
  color_used <- FALSE

  heading_color <- attr(tbl, "rtf_heading")$color
  heading_background_color <- attr(tbl, "rtf_heading")$background_color

  border_color_left <- attr(tbl, "border_color_left")
  border_color_right <- attr(tbl, "border_color_right")
  border_color_top <- attr(tbl, "border_color_top")
  border_color_bottom <- attr(tbl, "border_color_bottom")

  text_color <- attr(tbl, "text_color")
  text_background_color <- attr(tbl, "text_background_color")

  footnote_color <- attr(tbl, "rtf_footnote")$color
  footnote_background_color <- attr(tbl, "rtf_footnote")$background_color

  source_color <- attr(tbl, "rtf_source")$color
  source_background_color <- attr(tbl, "rtf_source")$background_color

  no_color <- is.null(heading_color) &&
    is.null(heading_background_color) &&
    is.null(border_color_left) &&
    is.null(border_color_right) &&
    is.null(border_color_top) &&
    is.null(border_color_bottom) &&
    is.null(text_color) &&
    is.null(text_background_color) &&
    is.null(footnote_color) &&
    is.null(footnote_background_color) &&
    is.null(source_color) &&
    is.null(source_background_color)

  if (no_color == FALSE) color_used <- TRUE

  color_used
}

#' create new table rtf text including page_by feature
#'
#' @param page_by column names to group by table in sections
#' @param pageby_colheader pageby column header created by `rtf_body`
#' @param pageby_condition pageby condition created by `rtf_body`
#' @param table_rtftext rtf text for the table created by `rtf_body`
#' @param new_page boolean value to indicate whether to separate grouped table into pages by sections
#'
#' @noRd
.page_by_newtable_rtf <- function(page_by,
                                  pageby_colheader,
                                  pageby_condition,
                                  table_rtftext,
                                  new_page) {
  category_index <- NULL


  if (!is.null(page_by)) {
    rtf_pageby_colheader <- lapply(pageby_colheader, function(x) {
      .as_rtf_table(rtf_body(data.frame(x),
        colheader = FALSE,
        border_bottom = "single",
        text_justification = "l"
      ))
    })

    rtf_pageby_index <- sapply(pageby_colheader, function(x) {
      length(which(pageby_condition %in% x))
    })


    new_table_rtftext <- matrix("",
      nrow = nrow(table_rtftext),
      ncol = ncol(table_rtftext) + length(pageby_colheader)
    )


    split_index <- c(0, cumsum(rtf_pageby_index)[-length(rtf_pageby_index)]) + 1
    pageby_index <- c(0, cumsum(rtf_pageby_index)[-length(rtf_pageby_index)]) + c(1:length(rtf_pageby_index))


    for (i in c(1:length(pageby_index))) {

      ## add pageby column header
      row_idx <- c(1:length(rtf_pageby_colheader[[1]]))
      col_idx <- pageby_index[i]

      new_table_rtftext[row_idx, col_idx] <- rtf_pageby_colheader[[i]]


      ## split table_rtftext based on pageby feature
      new_start <- pageby_index[i] + 1
      new_end <- new_start + rtf_pageby_index[i] - 1

      old_start <- split_index[i]
      old_end <- old_start + rtf_pageby_index[i] - 1

      new_table_rtftext[, new_start:new_end] <- table_rtftext[, old_start:old_end]
    }

    table_rtftext <- new_table_rtftext

    if (new_page == TRUE) {
      category_index <- pageby_index[-1] - 1
    }
  }

  newtable_list <- list(
    table_rtftext = table_rtftext,
    category_index = category_index
  )
}

#' calculate index to insert new page rtf code
#' @param new_page boolean value to indicate whether to separate grouped table into pages by sections
#' @param category_index pageby category index created by
#' @param n_row number of rows of rtf text for table body created by `rtf_body`
#' @param page_num number of rows in each page
#'
#' @noRd
.table_rtftext_index <- function(new_page,
                                 category_index,
                                 page_num,
                                 n_row) {
  if (page_num <= n_row) {
    if (new_page == TRUE) {
      pages <- c(0, category_index, n_row)


      pages_cut <- lapply(2:length(pages), function(x) {
        (0:floor((pages[x] - pages[x - 1]) / page_num)) * page_num + pages[x - 1]
      })

      pages <- unique(sort(c(pages, unlist(pages_cut))))
    } else {
      ## if new_page == FALSE
      pages <- c(0, c(1:floor(n_row / page_num)) * page_num)
    }
  } else {
    ## if (page_num > n_row)

    pages <- c(0, category_index)
  }


  if (pages[length(pages)] == n_row) pages <- pages[-length(pages)]

  pages
}




#' calculate index_newpage and index_endpage for pageby_db
#' @param pageby_db page by data frame created by `rtf_body`
#' @param pageby_colheader pageby column header created by `rtf_body`
#' @param pageby_condition pageby condition created by `rtf_body`
#' @param page_num number of rows in each page
#' @param page_by column names to group by table in sections
#' @param new_page boolean value to indicate whether to separate grouped table into pages by sections
#'
#' @noRd
.pageby_db_index <- function(pageby_db,
                             pageby_colheader,
                             pageby_condition,
                             page_num,
                             page_by,
                             new_page) {
  index_newpage <- 1
  index_endpage <- NULL

  n_row <- nrow(pageby_db) + length(pageby_colheader)

  if ((!is.null(page_num)) && (n_row != 1)) {
    if (page_num < n_row) {
      index_newpage <- c(1:floor(n_row / page_num)) * page_num
      if (index_newpage[length(index_newpage)] > n_row) index_newpage <- index_newpage[-length(index_newpage)]

      index_newpage <- c(0, index_newpage) + 1
    }


    ## if page_by feature is turned on
    if ((!is.null(page_by))) {
      rtf_pageby_index <- sapply(pageby_colheader, function(x) {
        length(which(pageby_condition %in% x))
      })


      if (new_page == TRUE) {
        ## if new_page == TRUE, break by new_page


        index_newpage <- c(0, cumsum(rtf_pageby_index)[-length(rtf_pageby_index)]) + 1

        first_interval <- page_num - 1

        index_newpage_cut <- lapply(2:length(index_newpage), function(x) {
          item_1 <- index_newpage[x - 1] + first_interval

          if (index_newpage[x] > item_1) {
            item_2 <- (0:floor((index_newpage[x] - item_1) / page_num)) * page_num + item_1

            cut <- c(item_1, item_2)
          } else {
            cut <- NULL
          }

          cut
        })


        index_newpage <- unique(sort(c(index_newpage, unlist(index_newpage_cut))))
      } else {
        ## if new_page == FALSE, only break by page_num

        split_index <- c(0, cumsum(rtf_pageby_index)[-length(rtf_pageby_index)]) + 1
        pageby_index <- c(0, cumsum(rtf_pageby_index)[-length(rtf_pageby_index)]) + c(1:length(rtf_pageby_index))

        temp_idx <- sapply(index_newpage, function(x) {
          min(which(pageby_index >= x)) - 1
        })

        index_newpage <- c(1, split_index[temp_idx] + (index_newpage - pageby_index[temp_idx]))
      }
    }
  }

  if (length(index_newpage) > 1) index_endpage <- index_newpage[-1] - 1

  index_list <- list(
    index_newpage = index_newpage,
    index_endpage = index_endpage
  )


  index_list
}




#' check whether title exist in the heading
#'
#' @param heading Heading attribute from a data frame
#'
#' @noRd
.is_title <- function(heading) {
  length(heading) > 0 && !is.null(heading$title)
}


#' check whether subtitle exist in the heading
#'
#' @param heading Heading attribute from a data frame
#'
#' @noRd
.is_subtitle <- function(heading) {
  length(heading) > 0 && !is.null(heading$subtitle) && heading$subtitle != ""
}


#' extract the footnote_df attribute from a data frame
#'
#' @param tbl A data frame
#'
#' @noRd
.get_footnote <- function(tbl) {
  gt_attr <- attributes(tbl)
  footnote <- gt_attr$rtf_footnote

  footnote
}


#' check whether footnote text exists in the footnote_df
#'
#' @param footnote footnote attribute from a data frame
#'
#' @noRd
.is_footnote <- function(footnote) {
  length(footnote) > 0 && !is.null(footnote$footnote) && footnote$footnote != ""
}


#' extract the data source attribute from a \pkg{gt} object
#'
#' @param tbl A data frame
#'
#' @noRd
.get_source <- function(tbl) {
  gt_attr <- attributes(tbl)
  source <- gt_attr$rtf_source

  source
}

#' extract the column header attribute from a data frame
#'
#' @param tbl A data frame
#'
#' @noRd
.get_colheader <- function(tbl) {
  attr(tbl, "rtf_colheader")
}



#' check whether footnote text exists in the footnote_df
#'
#' @param source source attribute from a data frame
#'
#' @noRd
.is_source <- function(source) {
  length(source) > 0 && !is.null(source$source) && source$source != ""
}



#' convert symbol to ANSI and Unicode encoding
#'
#' @param x Object to be converted.
#'
#' @noRd
.convert <- function(x) {
  char_rtf <- c(
    "^" = "\\super ",
    "_" = "\\sub ",
    ">=" = "\\geq ",
    "<=" = "\\leq ",
    "\n" = "\\line "
  )

  # Define Pattern for latex code

  unicode_latex$int <- as.integer(as.hexmode(unicode_latex$unicode))
  char_latex <- ifelse(unicode_latex$int <= 255, unicode_latex$chr,
    ifelse(unicode_latex$int > 255 & unicode_latex$int < 32768,
      paste0("\\uc1\\u", unicode_latex$int, "*"),
      paste0("\\uc1\\u-", unicode_latex$int, "*")
    )
  )

  names(char_latex) <- unicode_latex$latex

  # Declare fixed string in the pattern (no regular expression)
  char_rtf <- stringr::fixed(char_rtf)
  char_latex <- stringr::fixed(char_latex)

  x <- stringr::str_replace_all(x, char_rtf)
  x <- stringr::str_replace_all(x, char_latex)

  x
}




#' Convert a UTF-8 encoded Character String to a RTF properly encoded String
#'
#' @param x object to be converted
#'
#' If the unicode of a character is 255 or under (including all character on a keyboard), the character is as is.
#' If the unicode of a character is larger than 255, the character will be encoded.
#'
#' @references Burke, S. M. (2003). RTF Pocket Guide. " O'Reilly Media, Inc.".
#' @noRd
utf8Tortf <- function(x) {
  stopifnot(length(x) == 1 & "character" %in% class(x))

  x_char <- unlist(strsplit(x, ""))
  x_int <- utf8ToInt(x)
  x_rtf <- ifelse(x_int <= 255, x_char,
    ifelse(x_int <= 32768, paste0("\\uc1\\u", x_int, "?"),
      paste0("\\uc1\\u-", x_int - 65536, "?")
    )
  )

  paste0(x_rtf, collapse = "")
}


#' rtf code to set up column header for the rtf table
#'
#' @param tbl A data frame
#'
#' @noRd
.as_rtf_colheader <- function(tbl) {
  rtf_colheader <- .get_colheader(tbl)

  colheader_tbl_list <- NULL

  if (!is.null(rtf_colheader$colheader)) {
    colheader_tbl_list <- lapply(c(1:length(rtf_colheader$colheader)), function(i) {
      colheader_db <- rtf_colheader$colheader[[i]]

      border_left <- rtf_colheader$border_left[[i]]
      border_right <- rtf_colheader$border_right[[i]]
      border_top <- rtf_colheader$border_top[[i]]
      border_bottom <- rtf_colheader$border_bottom[[i]]

      border_color_left <- rtf_colheader$border_color_left[[i]]
      border_color_right <- rtf_colheader$border_color_right[[i]]
      border_color_top <- rtf_colheader$border_color_top[[i]]
      border_color_bottom <- rtf_colheader$border_color_bottom[[i]]

      border_width <- rtf_colheader$border_width[[i]]
      page_width <- rtf_colheader$page_width[[i]]
      col_rel_width <- rtf_colheader$col_rel_width[[i]]

      ## if column header relative width under "rtf_colheader" attribute is NA,
      ## use the global column relative width
      if (all(is.na(col_rel_width))) {
        col_rel_width <- attr(tbl, "col_rel_width")
      }

      col_total_width <- rtf_colheader$col_total_width[[i]]
      cell_height <- rtf_colheader$cell_height[[i]]
      cell_justification <- rtf_colheader$cell_justification[[i]]

      text_font <- rtf_colheader$text_font[[i]]
      text_format <- rtf_colheader$text_format[[i]]
      text_color <- rtf_colheader$text_color[[i]]
      text_background_color <- rtf_colheader$text_background_color[[i]]
      text_justification <- rtf_colheader$text_justification[[i]]
      text_font_size <- rtf_colheader$text_font_size[[i]]
      text_space_before <- rtf_colheader$text_space_before[[i]]
      text_space_after <- rtf_colheader$text_space_after[[i]]




      colheader_table <- .rtf_table_content(
        colheader_db,
        border_left            = border_left,
        border_right           = border_right,
        border_top             = border_top,
        border_bottom          = border_bottom,

        border_color_left      = border_color_left,
        border_color_right     = border_color_right,
        border_color_top       = border_color_top,
        border_color_bottom    = border_color_bottom,

        border_width           = border_width,
        page_width             = page_width,
        col_rel_width          = col_rel_width,
        col_total_width        = col_total_width,
        cell_height            = cell_height,
        cell_justification     = cell_justification,

        text_font              = text_font,
        text_format            =  text_format,
        text_color             = text_color,
        text_background_color  = text_background_color,
        text_justification     = text_justification,
        text_font_size         = text_font_size,
        text_space_before      = text_space_before,
        text_space_after       = text_space_after,

        page_num               = NULL,

        last_row               = FALSE
      )

      colheader_table
    })
  }

  colheader_tbl_list
}


#' rtf code to set up header for the rtf table
#'
#' @param tbl A data frame
#'
#' @noRd
.as_rtf_header <- function(tbl) {
  header <- list()

  heading <- .get_heading(tbl)

  if (.is_title(heading)) {
    text_title <- paste(heading$title, collapse = " \n ")

    header[[1]] <- .rtf_text(.convert(text_title),
      font = heading$font,
      font_size = heading$font_size,
      format = heading$format,
      color = heading$color,
      background_color = heading$background_color
    )

    if (.is_subtitle(heading)) {
      text_subtitle <- paste0("\n ", paste(heading$subtitle, collapse = " \n "))

      header[[2]] <- .rtf_text(.convert(text_subtitle),
        font = heading$font,
        font_size = heading$font_size,
        format = heading$format,
        color = heading$color,
        background_color = heading$background_color
      )
    }
  }

  ## if there is no title and subtitle, set header to NULL, no need to print anything
  if (length(header) == 0) {
    header <- NULL
  } else {
    header <- paste(unlist(header), collapse = "\n")
  }


  if (!is.null(header)) {
    paragraph <- .rtf_paragraph(header,
      justification = heading$justification,

      indent_first = heading$indent_first,
      indent_left = heading$indent_left,
      indent_right = heading$indent_right,

      space = heading$space,
      space_before = heading$space_before,
      space_after = heading$space_after,

      new_page = heading$new_page,
      hyphenation = heading$hyphenation
    )
  } else {
    paragraph <- NULL
  }

  paragraph
}

#' rtf code to set up footnote for the rtf table
#' @param tbl a data frame
#' @noRd
.as_rtf_footnote <- function(tbl) {
  footnote_df <- .get_footnote(tbl)

  if (.is_footnote(footnote_df)) {
    text_footnote <- paste(footnote_df$footnote, collapse = " \n ")

    text_footnote <- .rtf_text(.convert(text_footnote),
      font = footnote_df$font,
      font_size = footnote_df$font_size,
      format = footnote_df$format,
      color = footnote_df$color,
      background_color = footnote_df$background_color
    )
  } else {
    text_footnote <- NULL
  }


  if (!is.null(text_footnote)) {
    paragraph <- .rtf_paragraph(text_footnote,
      justification = footnote_df$justification,

      indent_first = footnote_df$indent_first,
      indent_left = footnote_df$indent_left,
      indent_right = footnote_df$indent_right,

      space = footnote_df$space,
      space_before = footnote_df$space_before,
      space_after = footnote_df$space_after,

      new_page = footnote_df$new_page,
      hyphenation = footnote_df$hyphenation
    )
  } else {
    paragraph <- NULL
  }

  paragraph
}


#' rtf code to set up footnote for the rtf table
#' @param tbl a data frame
#'
#' @noRd
.as_rtf_source <- function(tbl) {
  source <- .get_source(tbl)

  if (.is_source(source)) {
    text_source <- paste(source$source, collapse = " \n ")

    text_source <- .rtf_text(.convert(text_source),
      font = source$font,
      font_size = source$font_size,
      format = source$format,
      color = source$color,
      background_color = source$background_color
    )
  } else {
    text_source <- NULL
  }


  if (!is.null(text_source)) {
    paragraph <- .rtf_paragraph(text_source,
      justification = source$justification,

      indent_first = source$indent_first,
      indent_left = source$indent_left,
      indent_right = source$indent_right,

      space = source$space,
      space_before = source$space_before,
      space_after = source$space_after,

      new_page = source$new_page,
      hyphenation = source$hyphenation
    )
  } else {
    paragraph <- NULL
  }


  paragraph
}


#' calculate cell size in twips
#'
#' @param col_rel_width col_rel_width A vector of numbers separated by comma
#' to indicate column relative width ratio.
#' @param col_total_width A numeric number to indicate total column width.
#'
#' @noRd
.cell_size <- function(col_rel_width, col_total_width) {
  total.width.twip <- .inch_to_twip(col_total_width)
  round(total.width.twip / sum(col_rel_width) * col_rel_width, 0)
}




#' get attributes and write rtf table row by row
#' @param tbl a data frame
#'
#'
#' @noRd
.as_rtf_table <- function(tbl) {


  ## get attributes from tbl
  border_left <- attributes(tbl)$border_left
  border_right <- attributes(tbl)$border_right
  border_top <- attributes(tbl)$border_top
  border_bottom <- attributes(tbl)$border_bottom

  border_color_left <- attributes(tbl)$border_color_left
  border_color_right <- attributes(tbl)$border_color_right
  border_color_top <- attributes(tbl)$border_color_top
  border_color_bottom <- attributes(tbl)$border_color_bottom

  border_width <- attributes(tbl)$border_width
  page_width <- attributes(tbl)$page_width
  col_rel_width <- attributes(tbl)$col_rel_width
  col_total_width <- attributes(tbl)$col_total_width
  cell_height <- attributes(tbl)$cell_height
  cell_justification <- attributes(tbl)$cell_justification

  text_font <- attributes(tbl)$text_font
  text_format <- attributes(tbl)$text_format
  text_color <- attributes(tbl)$text_color
  text_background_color <- attributes(tbl)$text_background_color
  text_justification <- attributes(tbl)$text_justification
  text_font_size <- attributes(tbl)$text_font_size
  text_space_before <- attributes(tbl)$text_space_before
  text_space_after <- attributes(tbl)$text_space_after

  page_num <- attributes(tbl)$page_num
  new_page <- attributes(tbl)$new_page
  pageby_db <- attributes(tbl)$pageby_db
  pageby_endpage_index <- attributes(tbl)$pageby_endpage_index


  last_row <- attributes(tbl)$last_row


  table <- .rtf_table_content(pageby_db,
    border_left = border_left,
    border_right = border_right,
    border_top = border_top,
    border_bottom = border_bottom,

    border_color_left = border_color_left,
    border_color_right = border_color_right,
    border_color_top = border_color_top,
    border_color_bottom = border_color_bottom,

    border_width = border_width,
    page_width = page_width,
    col_rel_width = col_rel_width,
    col_total_width = col_total_width,
    cell_height = cell_height,
    cell_justification = cell_justification,

    text_font = text_font,
    text_format = text_format,
    text_color = text_color,
    text_background_color = text_background_color,
    text_justification = text_justification,
    text_font_size = text_font_size,
    text_space_before = text_space_before,
    text_space_after = text_space_after,

    page_num = page_num,
    pageby_endpage_index = pageby_endpage_index,
    new_page = new_page,

    last_row = last_row
  )

  table
}



#' rtf code to write rtf table row by row
#' @param db a data frame
#' @param border_left left border type
#' @param border_right right border type
#' @param border_top top border type
#' @param border_bottom bottom border type
#' @param border_color_left left border color
#' @param border_color_right right border color
#' @param border_color_top top border color
#' @param border_color_bottom bottom border color
#' @param border_width worder width in twips
#' @param page_width page width in inches
#' @param cell_justification justification for cell
#' @param col_rel_width column relative width in a vector eg. c(2,1,1) refers to 2:1;1
#' @param col_total_width column total width for the table
#' @param cell_height height for cell in twips
#' @param text_font text font type
#' @param text_font_size text font size
#' @param text_format  text format
#' @param text_color text color
#' @param text_background_color text background color
#' @param text_justification justification for text
#' @param text_space_before line space before text
#' @param text_space_after  line space after text
#' @param page_num number of rows in each page
#' @param page_by column names to group by table in sections
#' @param new_page a boolean value to indicate whether to separate grouped table into pages by sections
#' @param pageby_endpage_index end page index for pageby data frame
#' @param last_row a boolean value to indicate whether the table contains the last row of the final table
#'
#' @noRd
.rtf_table_content <- function(db,

                               border_left,
                               border_right,
                               border_top,
                               border_bottom,

                               border_color_left,
                               border_color_right,
                               border_color_top,
                               border_color_bottom,

                               border_width,
                               page_width,
                               col_rel_width,
                               col_total_width,
                               cell_height,
                               cell_justification,

                               text_font,
                               text_format,
                               text_color,
                               text_background_color,
                               text_justification,
                               text_font_size,
                               text_space_before,
                               text_space_after,

                               page_num,
                               pageby_endpage_index,
                               new_page,

                               last_row) {


  ## get dimension of db
  n_row <- nrow(db)
  n_col <- ncol(db)



  ## Transer vector to matrix by row
  foo <- function(x) {
    if ((is.null(dim(x))) & (!is.null(x))) {
      x <- matrix(x, nrow = n_row, ncol = n_col, byrow = TRUE)
    }
    x
  }


  ## cell justification
  justification <- .justification()
  cell_justification_rtf <- factor(cell_justification, levels = justification$type, labels = justification$rtf_code_row)
  cell_height <- round(.inch_to_twip(cell_height) / 2, 0)

  ## rtf code for table begin and end
  row_begin <- paste0("\\trowd\\trgaph", cell_height, "\\trleft0", cell_justification_rtf)
  row_end <- "\\intbl\\row\\pard"

  # Encoding RTF Cell Border
  border_lrtb <- c("\\clbrdrl", "\\clbrdrr", "\\clbrdrt", "\\clbrdrb")
  names(border_lrtb) <- c("left", "right", "top", "bottom")
  border_wid <- paste0("\\brdrw", border_width)

  ## cell border
  border_type <- .border_type()
  border_left_rtf <- factor(border_left, levels = border_type$name, labels = border_type$rtf_code)
  border_right_rtf <- factor(border_right, levels = border_type$name, labels = border_type$rtf_code)
  border_top_rtf <- factor(border_top, levels = border_type$name, labels = border_type$rtf_code)
  border_bottom_rtf <- factor(border_bottom, levels = border_type$name, labels = border_type$rtf_code)

  border_left_rtf <- paste0(border_lrtb["left"], border_left_rtf, border_wid)
  border_right_rtf <- paste0(border_lrtb["right"], border_right_rtf, border_wid)
  border_top_rtf <- paste0(border_lrtb["top"], border_top_rtf, border_wid)
  border_bottom_rtf <- paste0(border_lrtb["bottom"], border_bottom_rtf, border_wid)


  ## border color
  col_tb <- .color_table()

  if (!is.null(border_color_left)) {
    border_color_left_rtf <- factor(border_color_left, levels = col_tb$color, labels = col_tb$type)
    border_color_left_rtf <- paste0("\\brdrcf", border_color_left_rtf)
    border_left_rtf <- paste0(border_left_rtf, border_color_left_rtf)
  }

  if (!is.null(border_color_right)) {
    border_color_right_rtf <- factor(border_color_right, levels = col_tb$color, labels = col_tb$type)
    border_color_right_rtf <- paste0("\\brdrcf", border_color_right_rtf)
    border_right_rtf <- paste0(border_right_rtf, border_color_right_rtf)
  }

  if (!is.null(border_color_top)) {
    border_color_top_rtf <- factor(border_color_top, levels = col_tb$color, labels = col_tb$type)
    border_color_top_rtf <- paste0("\\brdrcf", border_color_top_rtf)
    border_top_rtf <- paste0(border_top_rtf, border_color_top_rtf)
  }

  if (!is.null(border_color_bottom)) {
    border_color_bottom_rtf <- factor(border_color_bottom, levels = col_tb$color)
    levels(border_color_bottom_rtf) <- col_tb$type
    border_color_bottom_rtf <- paste0("\\brdrcf", border_color_bottom_rtf)
    border_bottom_rtf <- paste0(border_bottom_rtf, border_color_bottom_rtf)
  }


  ## Cell Background Color
  if (!is.null(text_background_color)) {
    text_background_color_rtf <- factor(text_background_color, levels = col_tb$color)
    levels(text_background_color_rtf) <- col_tb$type
    text_background_color_rtf <- paste0("\\clcbpat", text_background_color_rtf)
  } else {
    text_background_color_rtf <- NULL
  }


  # Cell Size
  cell_width <- .cell_size(col_rel_width, col_total_width)
  cell_size <- cumsum(cell_width)
  cell_size <- foo(cell_size)

  # Cell Border
  border_top_left <- matrix(paste0(border_left_rtf, border_top_rtf, text_background_color_rtf, "\\cellx", cell_size), nrow = n_row, ncol = n_col)
  border_top_left_right <- matrix(paste0(border_left_rtf, border_top_rtf, border_right_rtf, text_background_color_rtf, "\\cellx", cell_size), nrow = n_row, ncol = n_col)
  border_top_left_bottom <- matrix(paste0(border_left_rtf, border_top_rtf, border_bottom_rtf, text_background_color_rtf, "\\cellx", cell_size), nrow = n_row, ncol = n_col)
  border_all <- matrix(paste0(border_left_rtf, border_top_rtf, border_right_rtf, border_bottom_rtf, text_background_color_rtf, "\\cellx", cell_size), nrow = n_row, ncol = n_col)

  border_rtf <- border_top_left
  border_rtf[, n_col] <- border_top_left_right[, n_col]


  ## check page_num
  if (!is.null(page_num) && !is.null(pageby_endpage_index)) {
    # if (!is.null(page_num) && (new_page == TRUE)) {
    # if (!is.null(page_num) && page_num <= n_row){

    border_rtf[pageby_endpage_index, ] <- border_top_left_bottom[pageby_endpage_index, ]
    border_rtf[pageby_endpage_index, n_col] <- border_all[pageby_endpage_index, n_col]
  }


  ## check last_row
  if (last_row) {
    border_rtf[n_row, ] <- border_top_left_bottom[n_row, ]
    border_rtf[n_row, n_col] <- border_all[n_row, n_col]
  }

  border_rtf <- t(border_rtf)



  # Encoding RTF Cell Content
  cell <- paste0("\\pard\\intbl\\sb", text_space_before, "\\sa", text_space_after)

  ## text justificaton
  text_justification_rtf <- factor(text_justification, levels = justification$type, labels = justification$rtf_code_text)

  # if align in decimal always justified at center.
  text_justification_rtf <- ifelse(text_justification == "d", paste0(text_justification_rtf, "\\tqdec\\tx", round(foo(cell_width) / 2, 0)), as.character(text_justification_rtf))

  ## text font and font size
  font_type <- .font_type()
  text_font_rtf <- factor(text_font, levels = font_type$type, labels = font_type$rtf_code)
  text_font_size_rtf <- paste0("\\fs", round(text_font_size * 2, 0))

  ## text format
  ## The combination of type should is valid.
  ## e.g. type = "bi" or "ib" should be bold and italics.
  font_format <- .font_format()

  if (!is.null(text_format)) {
    text_format_rtf <- lapply(strsplit(text_format, ""), function(x) {
      paste0(factor(x, levels = font_format$type, labels = font_format$rtf_code),
        collapse = ""
      )
    })
    text_format_rtf <- unlist(text_format_rtf)
  } else {
    text_format_rtf <- NULL
  }

  ## cell text color
  if (!is.null(text_color)) {
    text_color_rtf <- factor(text_color, levels = col_tb$color, labels = col_tb$type)
    text_color_rtf <- paste0("\\cf", text_color_rtf)
  } else {
    text_color_rtf <- NULL
  }

  content_matrix <- as.matrix(sapply(db, function(x) .convert(x)))

  cell_rtf <- paste0(
    cell, text_justification_rtf,
    "{", text_font_rtf, text_font_size_rtf, text_color_rtf, text_format_rtf,
    " ", content_matrix, "}", "\\cell"
  )
  cell_rtf <- t(matrix(cell_rtf, nrow = n_row, ncol = n_col))


  db_rtf_text <- rbind(row_begin, border_rtf, cell_rtf, row_end)


  db_rtf_text
}


#' end rtf table
#'
#' @noRd
.end_rtf <- function() {
  paste("}", sep = "")
}
