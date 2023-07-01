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
#' @export
#'
#' @examples
#' rtf_rich_text(
#'   text = paste(
#'     "This is {.emph important}.",
#'     "This is {.strong relevant}.", "This is {.zebra ZEBRA}."
#'   ),
#'   theme = list(
#'     .emph = list(format = "i"),
#'     .strong = list(format = "b"),
#'     .zebra = list(color = "white", background_color = "black")
#'   )
#' )
#'
rtf_rich_text <- function(text,
                          theme = list(
                            .emph = list(format = "i"),
                            .strong = list(format = "b")
                          )) {
  # Bulletproof the styles requested within the theme argument.
  theme_arg <- theme
  names(theme_arg) <- NULL
  unique_styles <- unique(names(unlist(theme_arg)))
  bad_style <- unique_styles[!(unique_styles %in% names(formals(rtf_text)))]
  if (length(bad_style) > 0) {
    stop(
      "Theme lists have styles which are not supported (",
      paste0(bad_style, collapse = ", "), ")."
    )
  }

  # Find all paired braces in text string.
  extracted <- list()
  extracted$matches <- gsub(
    pattern = "^\\{", replacement = "",
    gsub(
      pattern = "\\}$", replacement = "",
      x = extract_tagged_text(text)
    )
  )

  # For each paired brace: extract the theme tag (only allow one per match string).
  # Regex patterns for parsing input text.
  extraction_pattern <- "(^\\.[A-Za-z]*)(\\s)(.*$)"

  extracted$tags <- gsub(
    pattern = extraction_pattern,
    x = extracted$matches, replacement = "\\1"
  )
  if (length(extracted$tags) != length(extracted$matches)) {
    stop("Length missmatch of tags found and matches found")
  }

  # For each paired brace: extract the text to be wrapped with rtf_text()
  extracted$text <- gsub(
    pattern = extraction_pattern,
    x = extracted$matches, replacement = "\\3"
  )
  if (length(extracted$text) != length(extracted$matches)) {
    stop("Length missmatch of extracted text found and matches found")
  }

  # Validate that tags in text are reflected in themes argument
  missing_themes <- extracted$tags[!(extracted$tags %in% names(theme))]
  if (length(missing_themes) != 0) {
    stop(
      "Input text has tags which are not available in the theme (",
      paste0(missing_themes, collapse = ", "), ")."
    )
  }

  # Execute rtf_text() calls with theme tags.
  extracted$replacements <- vapply(
    X = seq_along(extracted$tags),
    FUN = function(x) {
      do.call(rtf_text,
        args = c(text = extracted$text[x], theme[[extracted$tags[x]]])
      )
    },
    FUN.VALUE = "character"
  )

  # Insert rtf_text() calls into original text.
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

#' Extract tagged text
#'
#' Identify the text that is in brackets and correctly resolve the ordering of
#' the brackets such that everything is correctly tagged with the needed style.
#'
#' @param input Plain text containing matched curly braces with tags.
#'
#' @keywords internal
extract_tagged_text <- function(input) {
  opening <- gregexec("\\{", text = input, perl = TRUE)[[1]]
  closing <- gregexec("\\}", text = input, perl = TRUE)[[1]]
  styles <- gregexec("\\{\\.[A-Za-z]*", text = input, perl = TRUE)

  # Check for equal number of opening and closing braces.
  check_braces(input)

  # Identify matching brace pairs.
  brace_matches <- match_braces(opening, closing)

  # Identify which matched braces are associated with a style tag.
  styles_matches <- brace_matches[which(brace_matches$opening %in% styles[[1]]), ]

  # Extract tagged brackets.
  unname(apply(styles_matches,
    MARGIN = 1,
    FUN = function(X) {
      substr(input, start = X[["opening"]], stop = X[["closing"]])
    }
  ))
}

#' Identify opening and closing brace pairs
#'
#' Identify which opening and closing braces in a string belong together. Follows
#' a first-in-last-out matching.
#'
#' @param openings Vector of indices indicating location of opening braces.
#' @param closings Vector of indices indicating location of closing braces.
#'
#' @keywords internal
match_braces <- function(openings, closings) {
  # Verify that equal numbers of opening and closing braces exist
  stopifnot(length(openings) == length(closings))

  # Create data frame to hold opening / closing pairs
  holder <- data.frame(
    opening = numeric(length(openings)),
    closing = numeric(length(closings))
  )

  for (i in seq_along(closings)) {
    # Find the matching opening brace.
    # The matching opening brace is the one most recently preceding a closing brace.
    match_opening <- max(openings[openings < closings[i]])
    # Record the opening brace index to be removed.
    match_opening_index <- which(openings == match_opening)
    # Add the pair of opening and closing braces to the holder data frame.
    holder[i, ] <- c(match_opening, closings[i])
    # Remove the matching opening brace from the vector of opening braces.
    openings <- openings[-match_opening_index]
  }

  holder
}

#' Check that braces are correctly matched
#'
#' Braces must be matched appropriately. First brace should be an opening brace.
#' Every brace should be closed appropriate.
#'
#' @param input Plain text containing matched curly braces with tags.
#'
#' @keywords internal
check_braces <- function(input) {
  input_parse <- gsub(x = input, pattern = "[^{}]", replacement = "")
  input_split <- unlist(strsplit(input_parse, ""))
  checker <- ifelse(input_split == "{", 1, -1)
  if (grepl(x = input, pattern = "(\\\\{)|(\\\\})", perl = TRUE)) {
    warning(c(
      "It seems that you have some escaped brackets in your input,",
      " this might not work as expected."
    ))
  }
  if (sum(checker) != 0) stop("Number of opening { and closing } must match.")
  if (any(cumsum(checker) < 0)) stop("Input has at least one unpaired '{'.")
}
