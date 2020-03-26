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
#' @name rtf_encode
#' @param tbl a data frame for table or a list of binary string for figure
#' @param type the type of input, default is table.
#'
#' @examples
#' \dontrun{
#' library(dplyr)  # required to run examples
#'
#' # Example 1
#'   head(iris) %>%
#'     rtf_body() %>%
#'     rtf_encode() %>%
#'     write_rtf(file = file.path(tempdir(), "table1.rtf"))
#'
#' # Example 2
#'   library(dplyr) # required to run examples
#'   file <- file.path(tempdir(), "figure1.png")
#'   png(file)
#'   plot(1:10)
#'   dev.off()
#'
#'   # Read in PNG file in binary format
#'   rtf_read_png(file) %>% rtf_figure() %>%
#'     rtf_encode(type = "figure") %>%
#'     write_rtf(file = file.path(tempdir(), "figure1.rtf"))
#'
#' # Example 3
#'
#' ## convert tbl_1 to the table body. Add title, subtitle, two table
#' ## headers, and footnotes to the table body.
#'   data(tbl_1)
#'   data(tbl_2)
#'   data(tbl_3)
#'   t1 <- tbl_1 %>%
#'     rtf_title(title = "ANCOVA of Change from Baseline at Week 8",
#'               subtitle = c("Missing Data Approach",
#'                            "Analysis Population")) %>%
#'     rtf_colheader(colheader = " | Baseline | Week 20 | Change from Baseline",
#'                   col_rel_width = c(3, 4, 4, 9),
#'                   first_row = TRUE) %>%
#'     rtf_colheader(colheader = "Treatment | N | Mean (SD) | N | Mean (SD) | N |
#'                     Mean (SD) | LS Mean (95% CI)\\dagger") %>%
#'     rtf_body(col_rel_width = c(3,1,3,1,3,1,3,5),
#'              text_justification = c("l",rep("c",7)),
#'              last_row = FALSE) %>%
#'     rtf_footnote(footnote = "\\dagger Based on an ANCOVA model.
#'                  justification = "l");
#'   ## convert tbl_2 to the table body. Add a table column header to table body.
#'   t2 <- tbl_2 %>%
#'     rtf_colheader(colheader = "Pairwise Comparison |
#'                    Difference in LS Mean(95% CI)\\dagger | p-Value",
#'                   text_justification = c("l","c","c")) %>%
#'     rtf_body(col_rel_width = c(8,7,5),
#'              text_justification = c("l","c","c"),
#'              last_row = FALSE);
#'   ## convert tbl_3 to the table body. Add data source to the table body.
#'   t3 <- tbl_3 %>%
#'     rtf_body(colheader = FALSE,
#'              text_justification = "l") %>%
#'     rtf_source(source = "Source: [study999:adam-adeff]",
#'                justification = "l")
#'   # add t1, t2, and t3 into a list in order
#'   tbl <- list(t1, t2, t3)
#'   # concatenate a list of table and save to an RTF file
#'   tbl %>% rtf_encode() %>% write_rtf(file.path(tempdir(), "table2.rtf"))
#' }
#'


#' @rdname rtf_encode
#' @export
rtf_encode <- function(tbl, type = "table") {
  match.arg(type, c("table", "figure"))

  if (type == "table") {
    return(.rtf_encode_table(tbl))
  }

  if (type == "figure") {
    return(.rtf_encode_figure(tbl))
  }
}

#' @rdname rtf_encode
#' @export
as_rtf <- function(tbl, type = "table") {
  message("`as_rtf()` is deprecated, use `rtf_encode`.")

  rtf_encode(tbl, type)
}

#' Render Table to RTF encoding
#'
#' @noRd
.rtf_encode_figure <- function(tbl) {

  ## get rtf code for page, margin, header, footnote, source, newpage
  page_rtftext <- .as_rtf_page(tbl)
  margin_rtftext <- .as_rtf_margin(tbl)
  header_rtftext <- .as_rtf_header(tbl)
  footnote_rtftext <- .as_rtf_footnote(tbl)
  source_rtftext <- .as_rtf_source(tbl)
  newpage_rtftext <- .as_rtf_newpage()

  ## get rtf code for figure width and height
  fig_width <- attr(tbl, "fig_width")
  fig_height <- attr(tbl, "fig_height")


  rtf_fig <- paste0(
    "{\\pict\\pngblip\\picwgoal",
    round(fig_width * 1440), "\\pichgoal",
    round(fig_height * 1440), " ", lapply(tbl, paste, collapse = ""), "}"
  )

  start_rtf <- paste(
    .as_rtf_init(),
    .as_rtf_font(),
    sep = "\n"
  )

  rtf_feature <- paste(
    page_rtftext,
    margin_rtftext,
    paste("{\\pard \\par}", header_rtftext, sep = "\n"),
    rtf_fig,
    .rtf_paragraph(""), # new line after figure
    footnote_rtftext,
    source_rtftext,
    c(rep(newpage_rtftext, length(rtf_fig) - 1), ""),
    sep = "\n"
  )
  rtf_feature <- paste(rtf_feature, collapse = "\n")


  end_rtf <- .end_rtf()

  paste(start_rtf, rtf_feature, end_rtf, end_rtf, sep = "\n")
}

#' Render Table to RTF encoding
#'
#' @noRd
.rtf_encode_table <- function(tbl) {
  start_rtf <- paste(

    .as_rtf_init(),
    .as_rtf_font(),
    .as_rtf_color(tbl),
    sep = "\n"
  )

  if ("data.frame" %in% class(tbl)) {

    ## get rtf code for page, margin, header, footnote, source, newpage
    page_rtftext <- .as_rtf_page(tbl)
    margin_rtftext <- .as_rtf_margin(tbl)
    header_rtftext <- .as_rtf_header(tbl)
    footnote_rtftext <- .as_rtf_footnote(tbl)
    source_rtftext <- .as_rtf_source(tbl)
    newpage_rtftext <- .as_rtf_newpage()

    ## get rtf code for colheader and table
    colheader_rtftext <- .as_rtf_colheader(tbl)
    table_rtftext <- .as_rtf_table(tbl)


    ## combine table_rtftext with pageby_colheader
    page_by <- attr(tbl, "page_by")
    pageby_db <- attr(tbl, "pageby_db")
    pageby_condition <- attr(tbl, "pageby_condition")
    pageby_colheader <- attr(tbl, "pageby_colheader")
    new_page <- attr(tbl, "new_page")
    page_num <- attr(tbl, "page_num")


    newtable_list <- .page_by_newtable_rtf(
      page_by,
      pageby_colheader,
      pageby_condition,
      table_rtftext,
      new_page
    )

    table_rtftext <- newtable_list$table_rtftext
    category_index <- newtable_list$category_index


    n_row <- ncol(table_rtftext)

    pages <- .table_rtftext_index(new_page, category_index, page_num, n_row)

    if (length(pages) > 1) {

      # if (!is.null(page_num) && !is.null(category_index)) {

      # pages  <- .table_rtftext_index(new_page, category_index, page_num, n_row)

      rtf_feature <- lapply(1:(length(pages) - 1), function(x) {
        paste(

          page_rtftext,

          margin_rtftext,

          paste("{\\pard \\par}", header_rtftext, sep = "\n"),

          paste(unlist(colheader_rtftext), collapse = "\n"),

          paste(table_rtftext[, c((pages[x] + 1):pages[x + 1])],
            collapse = "\n"
          ),

          footnote_rtftext,

          source_rtftext,

          newpage_rtftext,
          sep = "\n"
        )
      })

      if (pages[length(pages)] < n_row) {
        rtf_feature <- c(
          rtf_feature,

          paste(

            page_rtftext,

            margin_rtftext,

            paste("{\\pard \\par}", header_rtftext, sep = "\n"),

            paste(unlist(colheader_rtftext), collapse = "\n"),

            paste(table_rtftext[, c((pages[length(pages)] + 1):n_row)],
              collapse = "\n"
            ),

            footnote_rtftext,

            source_rtftext,
            sep = "\n"
          )
        )
      }

      rtf_feature <- paste(unlist(rtf_feature), collapse = "\n")
    } else {
      rtf_feature <- paste(

        page_rtftext,

        margin_rtftext,

        paste("{\\pard \\par}", header_rtftext, sep = "\n"),

        paste(unlist(colheader_rtftext), collapse = "\n"),

        paste(table_rtftext, collapse = "\n"),

        footnote_rtftext,

        source_rtftext,
        sep = "\n"
      )
    }
  } else if (class(tbl) == "list") {
    rtf_feature <- paste(

      .as_rtf_page(tbl[[1]]),

      .as_rtf_margin(tbl[[1]]),

      paste("{\\pard \\par}", unlist(lapply(tbl, function(x) .as_rtf_header(x))), sep = "\n"),

      paste(unlist(lapply(tbl, function(x) {
        paste(
          paste(unlist(.as_rtf_colheader(x)), collapse = "\n"),
          paste(.as_rtf_table(x), collapse = "\n"),
          sep = "\n"
        )
      })),
      collapse = "\n"
      ),


      paste(unlist(lapply(tbl, function(x) .as_rtf_footnote(x))), sep = ""),

      paste(unlist(lapply(tbl, function(x) .as_rtf_source(x))), sep = ""),
      sep = "\n"
    )
  } else {
    stop("Input must be a data frame or a list of data frame to render an rtf table")
  }


  rtf <- paste(start_rtf, rtf_feature, .end_rtf(), sep = "\n")


  rtf
}



#' @title Write an RTF table to .rtf file
#'
#' @description
#' The write_rtf function writes rtf encoding string to an .rtf file
#'
#' @param rtf rtf encoding string rendered by `as_rtf()`
#' @param file File name to write the output RTF table.
#'
#' @export
write_rtf <- function(rtf, file) {
  write(rtf, file)
}
