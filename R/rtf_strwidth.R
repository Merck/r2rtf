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

#' @title Calculate String Width in Inches
#'
#' @description
#' Calculate string width in inches based on font (Times New Roman, Arial, etc.), font size, font style (bold, italic, bold-italic etc.), and text indent.
#'
#' @param tbl A data frame
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item \code{tbl} is a data frame.
#'    \item Return an object with string width corresponding to each cell in the data frame \code{tbl}.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @return an object with string width corresponding to each cell in the data frame \code{tbl}
#'
#' @examples
#' library(dplyr)
#' tbl <- data.frame(x = rep("This is a long sentence", 5),
#'                   y = "short")
#' tbl %>%
#'   rtf_body(text_font = c(1, 3)) %>%
#'   r2rtf:::rtf_strwidth()
#'
rtf_strwidth <- function(tbl){

  # Text matrix
  if(! is.null(dim(tbl))){
    text <- apply(tbl, 2, as.character)
  }else{
    text <- as.character(tbl)
  }

  # Font size
  text_cex <- attr(tbl, "text_font_size") / graphics::par("ps")

  # Font format
  # text format 1 (plain/normal), 2 (bold), 3 (italic), 4 (bold-italic)
  if(! is.null(attr(tbl, "text_format"))){
    text_format <- unlist(lapply(strsplit(attr(tbl, "text_format"), ""), function(x){
      type_check <- c("b", "i") %in% x
      sum(type_check * 1:2) + 1
    } ))
  }else{
    text_format <- 1
  }

  # Font family
  font_num <- as.numeric(attr(tbl, "text_font"))

  # Group font with same style
  font_num <- factor(font_num, levels = 1:10, labels = c(1,1,4,4,4,1,9,4,9,9))
  font_num <- as.numeric(as.character(font_num))

  text_family <- font_type()[font_num, "family"]

  text_indent <- (attr(tbl, "text_indent_first")) / 1440 # to inch


  db <- data.frame(cex    = as.numeric(text_cex),
                   font   = as.numeric(text_format),
                   family = as.character(text_family),
                   stringsAsFactors = FALSE)

  db$text <- as.character(text)
  db$id <- 1:nrow(db)

  db_dict <- unique(db[, c("cex", "font", "family")])
  db_dict$index <- 1:nrow(db_dict)
  db <- merge(db, db_dict, all = TRUE)


  db_list <- split(db, db$index)
  db_list <- lapply(db_list, function(x){

                # Mapping Windows Font
                if(.Platform$OS.type == "windows"){
                  grDevices::windowsFonts("Arial"     = grDevices::windowsFont("Arial"))
                  grDevices::windowsFonts("Times"     = grDevices::windowsFont("Times New Roman"))
                  grDevices::windowsFonts("ArialMT"   = grDevices::windowsFont("Arial"))
                  grDevices::windowsFonts("Helvetica" = grDevices::windowsFont("Helvetica"))
                  grDevices::windowsFonts("Calibri"   = grDevices::windowsFont("Calibri"))
                  grDevices::windowsFonts("Georgia"   = grDevices::windowsFont("Georgia"))
                  grDevices::windowsFonts("Cambria"   = grDevices::windowsFont("Cambria"))
                  grDevices::windowsFonts("Courier"   = grDevices::windowsFont("Courier New"))
                }

                x$width <- graphics::strwidth(x$text, units = "inches", cex = x$cex[1], font = x$font[1], family = x$family[1])
                x
  })
  db <- do.call(rbind, db_list)
  width <- db$width[order(db$id)]

  # Recalculate font size for "Georgia" ,"Courier New", and "Symbol".
  width <- ifelse(font_num %in% 9, nchar(text) *  attr(tbl, "text_font_size") * 0.52 / 72, width)

  # Add indent space
  width <- width + text_indent

  if(!is.null(dim(tbl))){
    width <- matrix(width, nrow = nrow(tbl), ncol = ncol(tbl))
  }

  width

}



