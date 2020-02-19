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
#' @param gt_tbl a data frame for table or a list of binary string for figure
#' @param type the type of input, default is table.
#'


#' @rdname rtf_encode
#' @export
rtf_encode <- function(gt_tbl, type = "table"){

  match.arg(type, c("table", "figure"))

  if(type == "table"){
    return(.rtf_encode_table(gt_tbl))
  }

  if(type == "figure"){
    return(.rtf_encode_figure(gt_tbl))
  }

}

#' @rdname rtf_encode
#' @export
as_rtf <- function(gt_tbl, type = "table"){

  message("`as_rtf()` is deprecated, use `rtf_encode`.")

  rtf_encode(gt_tbl, type)
}

#' Render Table to RTF encoding
#'
#' @noRd
.rtf_encode_figure <- function(gt_tbl){

  ## get rtf code for page, margin, header, footnote, source, newpage
  page_rtftext      <-  .as_rtf_page(gt_tbl)
  margin_rtftext    <-  .as_rtf_margin(gt_tbl)
  header_rtftext    <-  .as_rtf_header(gt_tbl)
  footnote_rtftext  <-  .as_rtf_footnote(gt_tbl)
  source_rtftext    <-  .as_rtf_source(gt_tbl)
  newpage_rtftext   <-  .as_rtf_newpage()

  ## get rtf code for figure width and height
  fig_width       <-  attr(gt_tbl, "fig_width")
  fig_height      <-  attr(gt_tbl, "fig_height")


  rtf_fig <- paste0("{\\pict\\pngblip\\picwgoal",
                   round(fig_width*1440),"\\pichgoal",
                   round(fig_height*1440)," ", lapply(gt_tbl, paste, collapse = ""),"}")

  start_rtf <- paste(
    .as_rtf_init(),
    .as_rtf_font(),
    sep="\n"
  )

  rtf_feature <- paste(
    page_rtftext,
    margin_rtftext,
    paste("{\\pard \\par}", header_rtftext, sep = "\n"),
    rtf_fig,
    .rtf_paragraph(""), # new line after figure
    footnote_rtftext,
    source_rtftext,
    c(rep(newpage_rtftext, length(rtf_fig) -1), ""),
    sep = "\n"
  )
  rtf_feature <- paste(rtf_feature, collapse = "\n")


  end_rtf <- .end_rtf()

  paste(start_rtf, rtf_feature, end_rtf, end_rtf, sep="\n")

}

#' Render Table to RTF encoding
#'
#' @noRd
.rtf_encode_table <- function(gt_tbl){
  start_rtf <- paste(

    .as_rtf_init(),
    .as_rtf_font(),
    .as_rtf_color(gt_tbl),
    sep="\n"
  )

  if ( "data.frame" %in% class(gt_tbl) ) {

    ## get rtf code for page, margin, header, footnote, source, newpage
    page_rtftext      <-  .as_rtf_page(gt_tbl)
    margin_rtftext    <-  .as_rtf_margin(gt_tbl)
    header_rtftext    <-  .as_rtf_header(gt_tbl)
    footnote_rtftext  <-  .as_rtf_footnote(gt_tbl)
    source_rtftext    <-  .as_rtf_source(gt_tbl)
    newpage_rtftext   <-  .as_rtf_newpage()

    ## get rtf code for colheader and table
    colheader_rtftext <-  .as_rtf_colheader(gt_tbl)
    table_rtftext     <-  .as_rtf_table(gt_tbl)


    ## combine table_rtftext with pageby_colheader
    page_by          <- attr(gt_tbl, "page_by")
    pageby_db        <- attr(gt_tbl, "pageby_db")
    pageby_condition <- attr(gt_tbl, "pageby_condition")
    pageby_colheader <- attr(gt_tbl, "pageby_colheader")
    new_page         <- attr(gt_tbl, "new_page")
    page_num         <- attr(gt_tbl, "page_num")


    newtable_list  <- .page_by_newtable_rtf(page_by,
                                            pageby_colheader,
                                            pageby_condition,
                                            table_rtftext,
                                            new_page)

    table_rtftext  <- newtable_list$table_rtftext
    category_index <- newtable_list$category_index


    n_row <- ncol(table_rtftext)

    pages  <- .table_rtftext_index(new_page, category_index, page_num, n_row)

    if (length(pages) > 1){

    #if (!is.null(page_num) && !is.null(category_index)) {

        #pages  <- .table_rtftext_index(new_page, category_index, page_num, n_row)

        rtf_feature <- lapply( 1:(length(pages)-1), function(x){

          paste(

            page_rtftext,

            margin_rtftext,

            paste("{\\pard \\par}", header_rtftext, sep = "\n"),

            paste(unlist(colheader_rtftext), collapse = "\n"),

            paste(table_rtftext[, c( (pages[x] + 1) : pages[x+1])],
                  collapse = "\n"),

            footnote_rtftext,

            source_rtftext,

            newpage_rtftext,

            sep="\n"

          )

        })

        if (pages[length(pages)] < n_row) {

          rtf_feature <- c(rtf_feature,

                           paste(

                             page_rtftext,

                             margin_rtftext,

                             paste("{\\pard \\par}", header_rtftext, sep = "\n"),

                             paste(unlist(colheader_rtftext), collapse = "\n"),

                             paste(table_rtftext[, c( (pages[length(pages)] + 1) : n_row )],
                                   collapse = "\n"),

                             footnote_rtftext,

                             source_rtftext,

                             sep="\n")

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

        sep="\n"
      )

    }



  }else if (class(gt_tbl) == "list") {


    rtf_feature <- paste(

      .as_rtf_page(gt_tbl[[1]]),

      .as_rtf_margin(gt_tbl[[1]]),

      paste("{\\pard \\par}", unlist(lapply(gt_tbl, function (x) .as_rtf_header(x))), sep = "\n"),

      paste(unlist(lapply(gt_tbl, function(x) {
                      paste(
                        paste(unlist(.as_rtf_colheader(x)), collapse = "\n"),
                        paste(.as_rtf_table(x), collapse = "\n"),
                        sep = "\n"
                        )
                      })),
            collapse = "\n"),


      paste(unlist(lapply(gt_tbl, function (x) .as_rtf_footnote(x))), sep = ""),

      paste(unlist(lapply(gt_tbl, function (x) .as_rtf_source(x))), sep = ""),

      sep="\n"
    )

  } else {

    stop("Input must be a data frame or a list of data frame to render an rtf table")

  }


  rtf <- paste(start_rtf, rtf_feature, .end_rtf(), sep="\n")


  rtf

}



#' @title Write an RTF table to .rtf file
#'
#' @description
#' The write_rtf function writes rtf encoding string to an .rtf file
#'
#' @param rtf rtf encoing string rendered by `as_rtf()`
#' @param file File name to write the output RTF table.
#'
#' @export
write_rtf <- function(rtf, file){

  write(rtf, file)

}




