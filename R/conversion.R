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

#' Convert Inches to Twips
#'
#' @param inch Value in inches.
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Convert inch to twips using conversion factor 1:1440.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @noRd
inch_to_twip <- function(inch) {
  round(inch * 1440, 0)
}


#' Calculate Cell Size in Twips
#'
#' @param col_rel_width A vector of numbers separated by comma to indicate column relative width ratio.
#' @param col_total_width A numeric number to indicate total column width.
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Convert inch to twip for cell size using \code{.inch_to_twip()}.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @noRd
cell_size <- function(col_rel_width, col_total_width) {
  total_width_twip <- inch_to_twip(col_total_width)
  round(total_width_twip / sum(col_rel_width) * col_rel_width, 0)
}


#' Convert Symbol to ANSI and Unicode Encoding
#'
#' @param text A string to be converted.
#' @param load_stringi A logical value to load \code{stringi} or not
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Define commonly used symbols in RTF syntax (superscript, subscript, greater than or equal to, less than or equal to, line break).
#'    \item Define Pattern for latex code.
#'    \item Declare fixed string in the pattern (no regular expression).
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @noRd
convert <- function(text,
                    use_i18n = FALSE,
                    load_stringi = requireNamespace("stringi", quietly = TRUE)) {
  # grepl(">|<|=|_|\\^|(\\\\)|(\\n)", c(">", "<", "=", "_", "\n", "\\line", "abc"))
  index <- grepl(">|<|=|_|\\^|(\\\\)|(\\n)", text)

  # Process special characters if they exist
  if (any(index)) {
    char_rtf <- c(
      "^" = "\\super ",
      "_" = "\\sub ",
      ">=" = "\\geq ",
      "<=" = "\\leq ",
      "\n" = "\\line ",
      "\\pagenumber" = "\\chpgn ",
      "\\totalpage" = "\\totalpage",
      "\\pagefield" = "{\\field{\\*\\fldinst NUMPAGES }} ",
      "\\pagenumber_hardcoding" = "\\pgnhardcoding"
    )

    # Define Pattern for latex code
    unicode_int <- as.integer(as.hexmode(unicode_latex$unicode))
    char_latex <- ifelse(unicode_int <= 255 & unicode_int != 177, unicode_latex$chr,
      sprintf("\\uc1\\u%d*", unicode_int - ifelse(unicode_int < 32768, 0, 65536))
    )

    names(char_latex) <- unicode_latex$latex

    char_latex <- rev(c(char_latex, char_rtf))

    if (load_stringi) {
      text[index] <- stringi::stri_replace_all_fixed(text[index], names(char_latex), char_latex,
        vectorize_all = FALSE, opts_fixed = list(case_insensitive = FALSE)
      )
    } else {
      for (i in seq_along(char_latex)) {
        text[index] <- gsub(names(char_latex[i]), char_latex[i], text[index], fixed = TRUE)
      }
    }
  }

  # Apply UTF-8 to RTF conversion for non-ASCII characters when use_i18n is TRUE
  if (use_i18n) {
    # Check for non-ASCII characters
    has_non_ascii <- grepl("[^\x01-\x7F]", text)
    if (any(has_non_ascii)) {
      text[has_non_ascii] <- vapply(text[has_non_ascii],
        utf8Tortf,
        character(1),
        USE.NAMES = FALSE
      )
    }
  }

  text
}


#' Convert a UTF-8 Encoded Character String to a RTF Encoded String
#'
#' @param text A string to be converted.
#'
#' If the unicode of a character is less than 128 (including all character on a keyboard), the character is as is.
#' If the unicode of a character is larger or equal to 128, the character will be encoded.
#'
#' @references Burke, S. M. (2003). RTF Pocket Guide. " O'Reilly Media, Inc.".
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Define rules for character by setting 128 as cutoff.
#'    \item If the unicode of a character is 128 or under (including all character on a keyboard), the character is as is.
#'    \item If the unicode of a character is larger than 128, the character will be encoded.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @export
#'
utf8Tortf <- function(text) {
  stopifnot(length(text) == 1 & "character" %in% class(text))

  x_char <- unlist(strsplit(text, ""))
  x_int <- utf8ToInt(text)
  x_rtf <- ifelse(x_int < 128, x_char,
    ifelse(x_int <= 32768, paste0("\\uc1\\u", x_int, "?"),
      paste0("\\uc1\\u", x_int - 65536, "?")
    )
  )

  paste0(x_rtf, collapse = "")
}

#' Apply UTF-8 to RTF Conversion for Character Vectors
#'
#' @param text Character vector to convert
#' @param use_i18n Logical indicating whether to apply UTF-8 conversion
#'
#' @noRd
apply_utf8_conversion <- function(text, use_i18n = FALSE) {
  if (!use_i18n || is.null(text)) {
    return(text)
  }

  # Apply utf8Tortf to each element in the character vector
  if (is.character(text)) {
    vapply(text, utf8Tortf, character(1), USE.NAMES = FALSE)
  } else {
    text
  }
}
