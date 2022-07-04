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

#' Argument Verification Using Partial Matching
#'
#' Similar to `match.arg()`, match_arg matches `arg` against a table of candidate values as specified by `choices`.
#'
#' @details This function resolves errors from `match.arg()` with '' as arg input.
#' @inheritParams base::match.arg
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Convert arg and choices inputs from numeric to characters.
#'    \item Input choices imputation if it is missing.
#'    \item Input arg imputation if it is NULL.
#'    \item Input several.ok check for arg length.
#'    \item Compare arg with choices values and report error message if it does not match.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @return The matched elements of arg or in case of match failure a detailed error message
#'
#' @examples
#' \dontrun{
#' match_arg(arg = c(2, 1), choices = c(4, 3, 1, 2), several.ok = TRUE)
#' match_arg(arg = c("c", "b"), choices = c("a", "b", "c", "d"), several.ok = TRUE)
#' }
#'
match_arg <- function(arg, choices, several.ok = FALSE) {
  # following code are from match.arg with minor updates

  # update to enable arg and choices to accept numeric and character vectors
  if ("numeric" %in% class(arg)) {
    arg <- as.character(arg)
  }

  if (class(choices) == c("numeric")) {
    choices <- as.character(choices)
  }

  if (missing(choices)) {
    formal.args <- formals(sys.function(sysP <- sys.parent()))
    choices <- eval(formal.args[[as.character(substitute(arg))]],
      envir = sys.frame(sysP)
    )
  }
  if (is.null(arg) | length(arg) == 0L) {
    return(choices[1L])
  }

  if (!several.ok) {
    if (identical(arg, choices)) {
      return(arg[1L])
    }
    if (length(arg) > 1L) {
      stop("'arg' must be of length 1")
    }
  }

  # i <- pmatch(arg, choices, nomatch = 0L, duplicates.ok = TRUE) # replaced by new code to debug
  i <- charmatch(arg, choices, nomatch = 0L)
  if (any(i == 0L)) {
    stop(gettextf("all 'arg' should be one of %s", paste(dQuote(choices),
      collapse = ", "
    )), domain = NA)
  }
  i <- i[i > 0L]
  if (!several.ok && length(i) > 1) {
    stop("there is more than one match in 'match_arg'")
  }
  choices[i]
}
