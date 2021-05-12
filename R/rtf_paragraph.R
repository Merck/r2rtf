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

#' Paragraph to RTF Encode
#'
#' @param text rtf text obtained using `rtf_text()` function.
#' @param justification Justification for text.
#' @param indent_first First indent.
#' @param indent_left  Left indent.
#' @param indent_right Right indent.
#' @param space Paragraph space.
#' @param space_before Line space before text.
#' @param space_after  Line space after text.
#' @param new_page A boolean value to indicate whether to start a new page.
#' @param hyphenation A boolean value to indicate whether to use hyphenation.
#' @param cell A boolean value to indicate if paragraph is in table cell.
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Validate if input paragraph justification is valid using \code{justification()}.
#'    \item Validate if input paragraph spacing is valid using \code{spacing()}.
#'    \item Validate if input indent and space arguments are numeric.
#'    \item Add left curly bracket followed by RTF syntax: two backward slashes followed by pard, to start of code.
#'    \item Add RTF syntax: two backward slashes followed by pagebb, if new_page argument is TRUE.
#'    \item Add RTF syntax: two backward slashes followed by sb, at start of line space_before argument.
#'    \item Add RTF syntax: two backward slashes followed by sa, at start of line space_after argument.
#'    \item Define paragraph space based on input argument for space and \code{spacing()}.
#'    \item Add RTF syntax: two backward slashes followed by fi, at start of line indent_first argument.
#'    \item Add RTF syntax: two backward slashes followed by li, at start of line indent_left argument.
#'    \item Add RTF syntax: two backward slashes followed by ri, at start of line indent_right argument.
#'    \item Define paragraph justification based on input argument for justification and \code{justification()}.
#'    \item Add RTF syntax: two backward slashes followed by hyphpar, if hyphenation argument is TRUE.
#'    \item Add RTF syntax: two backward slashes followed by hyphpar0, if hyphenation argument is FALSE.
#'    \item Add RTF syntax: two backward slashes followed by par, followed by right curly bracket to end of code.
#'    \item Combine all components into a single RTF code string.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
rtf_paragraph <- function(text,

                          justification = "c",

                          indent_first = 0,
                          indent_left = 0,
                          indent_right = 0,

                          space = 1,
                          space_before = 180,
                          space_after = 180,

                          new_page = FALSE,
                          hyphenation = TRUE,

                          cell = FALSE) {


  ## Define dictionary
  para_justification <- justification()
  spacing <- spacing()

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

  if(cell){
    begin <- "\\pard"
    end <- "\\cell"
  }else{
    begin <- "{\\pard"
    end <- "\\par}"
  }

  ### line space
  space_before <- paste0("\\sb", space_before)
  space_after <- paste0("\\sa", space_after)

  ### paragraph space
  space <- factor(space, levels = spacing$type)
  levels(space) <- spacing$rtf_code

  ### Start new page for this paragraph
  page_break <- ifelse(new_page, "\\pagebb", "")

  ### Indent
  indent_first <- paste0("\\fi", indent_first)
  indent_left <- paste0("\\li", indent_left)
  indent_right <- paste0("\\ri", indent_right)

  ### Alignment
  alignment <- factor(justification, levels = para_justification$type)
  levels(alignment) <- para_justification$rtf_code_text

  ### Hyphenation
  hyphenation <- ifelse(hyphenation, "\\hyphpar", "\\hyphpar0")

  ## Paragraph RTF Encode
 text_rtf <- paste0(
    begin, page_break, hyphenation,
    space, space_before, space_after, indent_first, indent_left, indent_right, alignment,
    text,
    end
  )

  # Convert back to matrix
  if(! is.null(dim(text))){
    text_rtf <- matrix(text_rtf, nrow = nrow(text), ncol = ncol(text))
  }

  text_rtf

}
