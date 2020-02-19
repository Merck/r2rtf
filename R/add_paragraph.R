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

#' rtf code to add text
#'
#' @param text plain text
#' @param font text font type
#' @param font_size text font size
#' @param format  text format
#' @param color text color
#' @param background_color text background color
#'
#' @noRd
.rtf_text <- function(
                      text,
                      font = 1,
                      font_size = 12,
                      format = NULL,
                      color = NULL,
                      background_color = NULL){

  ## Set defalut value
  if( (! is.null(background_color)) & is.null(color)){color <- "black"}

  ## Define dictionary
  font_type <- .font_type()
  font_format <- .font_format()
  col_tb <- .color_table()


  if(! is.null(format)){
    format_check <- unlist(strsplit(format, ""))
  }else{
    format_check <- NULL
  }

  ## check whether input arguments are valid
  stopifnot(

    font %in% font_type$type,

    as.vector(format_check) %in% font_format$type,

    is.numeric(font_size),

    color %in% col_tb$color,

    background_color %in% col_tb$color


  )


  begin <- "{"



  ### Font
  font <- factor(font, levels = font_type$type, labels = font_type$rtf_code)
  font_size <- paste0("\\fs", round(font_size * 2, 0) )


  ## The combination of text format should be valid.
  ## e.g. type = "bi" or "ib" should be bold and italics.
  if(! is.null(format)){
    format <- lapply(strsplit(format, ""), function(x){
      paste0(factor(x, levels = font_format$type, labels = font_format$rtf_code),
             collapse = "")} )
    format  <- unlist(format)
  }else{format <- NULL}

  ### Color
  text_color <- NULL
  if(! is.null(color)){
    fg_color <- factor(color, levels = col_tb$color, labels = col_tb$type)
    text_color <- paste0("\\cf", fg_color)
  }

  if(! is.null(background_color)){
    bg_color <- factor(background_color, levels = col_tb$color, labels = col_tb$type)
    text_color <- paste0(text_color, "\\chshdng0", "\\chcbpat", bg_color, "\\cb", bg_color)
  }

  ### Convert Latex Character
  # To be added, any latex character like $\\beta$ should be convert to unicode and display in RTF file correctly.

  text <- .convert(text)


  end <- "}"


  paste0(begin,
         font, font_size,
         format,
         text_color, " ",
         text,
         end)

}

#' rtf code to add text to paragraph
#'
#' @param text rtf text obtained using `.rtf_text(text,...)` function
#' @param justification justification for text
#' @param indent_first first indent
#' @param indent_left  left indent
#' @param indent_right right indent
#' @param space paragraph space
#' @param space_before line space before text
#' @param space_after  line space after text
#' @param begin rtf code to begin a paragraph
#' @param end   rtf code to end a paragraph
#' @param new_page boolean value to indicate whether to start a new page
#' @param hyphenation boolean value to indicate whether to use hyphenation
#'
#' @noRd
.rtf_paragraph <- function(
                            text,

                            justification = "c",

                            indent_first = 0,
                            indent_left  = 0,
                            indent_right = 0,

                            space = 1,
                            space_before = 180,
                            space_after = 180,

                            new_page = FALSE,
                            hyphenation = TRUE){

  ## Define dictionary
  para_justification <- .justification()
  spacing <- .spacing()

  ## check whether input arguments are valid
  stopifnot(

    as.vector(justification) %in% para_justification$type,

    is.numeric(indent_first),

    is.numeric(indent_left),

    is.numeric(indent_right),

    space %in% spacing$type,

    is.numeric(space_before),

    is.numeric(space_after)



  )

  begin <- "{\\pard"

  ### line space
  space_before <- paste0("\\sb", space_before)
  space_after  <- paste0("\\sa", space_after)

  ### paragraph space
  space <- factor(space, levels = spacing$type, labels = spacing$rtf_code)

  ### Start new page for this paragraph
  page_break <- ifelse(new_page, "\\pagebb", "")

  ### Indent
  indent_first <- paste0("\\fi", indent_first)
  indent_left  <- paste0("\\li", indent_left)
  indent_right <- paste0("\\ri", indent_right)

  ### Alignment
  alignment <- factor(justification, levels = para_justification$type, labels = para_justification$rtf_code_text)

  ### Hyphenation
  hyphenation <- ifelse(hyphenation, "\\hyphpar", "hyphpar0")

  end <- "\\par}"


  ## Paragraph RTF Encode
  paste0(begin, page_break, hyphenation, "\n",
        space, space_before, space_after, indent_first, indent_left, indent_right, alignment,  "\n",
        text, "\n",
        end)

}

#' rtf code to add picture
#'
#' @param path path for rtf figure
#'
#' @noRd
.rtf_figure <- function(path){
  # ToDo
  # refer rtf:::.add.png and rtf::addPng.RTF

  paste0( "{\\field\\fldedit{\\*\\fldinst { INCLUDEPICTURE  \\\\d",
    path,
    "\\\\* MERGEFORMATINET }}{\\fldrslt {  }}}"
  )
}


#' rtf code to write paragraph to .rtf file
#'
#' @param rtf_body rtf code for text paragraph, obtained using `.rtf_paragraph(text,...)` function
#' @param file file name to save rtf text paragraph, eg. filename.rtf
#'
#' @noRd
write_rtf_para <- function(rtf_body, file){

  col_tb    <- .color_table()
  rtf_color <- paste(c( "{\\colortbl; ", col_tb$rtf_code, "}"), collapse = "\n")

  start_rtf <- paste(

    .as_rtf_init(),
    .as_rtf_font(),
    rtf_color,
    sep="\n"
  )
  rtf <- paste(start_rtf, "{\\pard \\par}", paste(rtf_body, collapse = ""), .end_rtf(), sep="\n")
  write(rtf, file)
}
