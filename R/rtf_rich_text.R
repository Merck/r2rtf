#    Copyright (c) 2023 Merck & Co., Inc., Rahway, NJ, USA and its affiliates. All rights reserved.
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

#' Text to formatted RTF Encode
#'
#' @param text Plain text.
#' @param theme Named list defining themes for tags. See \code{rtf_text()} for
#' details on possible formatting.
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Validate if theme list items correspond to \code{font_type()} arguments.
#'    \item Create regex expressions to match `{}` and `.tag` in text.
#'    \item Extract tagged text from input text.
#'    \item Extract tags from tagged text.
#'    \item Extract text from tagged text.
#'    \item Validate that lengths of extractions are all the same.
#'    \item Validate that tags are defined in the `theme` argument.
#'    \item Execute \code{rtf_text()} with extracted text and relevant formatting.
#'    \item Reinsert encoded formatted text to original input text.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @importFrom checkmate assert_choice assert_true
#' @importFrom purrr walk map2_chr
#'
#' @export
#'
#' @examples
#' rtf_rich_text(text = "This is {.emph important}. This is {.blah relevant}.",
#' theme = list(
#` .emph = list(color = "blue", `format` = "b"),
#` .blah = list(color = "red")
#` `))
#
rtf_rich_text <- function(text,
                          theme = list(
                            .emph = list(color = "blue", `format` = "b"),
                            .blah = list(color = "red")
                          )) {
  # bulletproof theme
  theme_args <- theme
  names(theme_args) <- NULL
  unique_theme_args <- unique(names(unlist(theme_args)))
  purrr::walk(
    unique_theme_args,
    ~ checkmate::assert_choice(.x,
      choices = names(formals(rtf_text)),
      .var.name = paste0("theme: ", .x)
    )
  )

  # Regex patterns for parsing input text.
  matches_pattern <- "(?<=\\{).*?(?=\\})"
  extraction_pattern <- "(^\\.[A-Za-z]*)(\\s)(.*$)"

  extracted <- list()

  # find all paired braces in text string
  extracted$matches <- regmatches(
    x = text,
    m = gregexpr(matches_pattern,
      text = text,
      perl = TRUE
    )
  )[[1]]

  # for each paired brace: extract the theme tag (only allow one per match string)
  extracted$tags <- gsub(
    pattern = extraction_pattern,
    x = extracted$matches, replacement = "\\1"
  )
  checkmate::assert_true(length(extracted$tags) == length(extracted$matches))

  # for each paired brace: extract the text to be wrapped with rtf_text()
  extracted$text <- gsub(
    pattern = extraction_pattern,
    x = extracted$matches, replacement = "\\3"
  )
  checkmate::assert_true(length(extracted$text) == length(extracted$matches))

  # validate that tags in text are reflected in themes argument
  purrr::walk(extracted$tags,
    .f = ~ checkmate::assert_choice(.x, choices = names(theme))
  )

  # execute rtf_text() calls with theme tags.
  extracted$replacements <- purrr::map2_chr(
    .x = extracted$text,
    .y = extracted$tags,
    .f = ~ do.call(rtf_text, args = c(text = .x, theme[[.y]]))
  )

  # insert rtf_text() calls into original text.
  new_text <- text
  for (i in seq_along(extracted$matches)) {
    new_text <- gsub(
      x = new_text,
      pattern = paste0("{", extracted$matches[i], "}"),
      replacement = extracted$replacements[i],
      fixed = TRUE
    )
  }

  rtf_text(new_text)
}
