#  Copyright (c) 2024 Merck & Co., Inc., Rahway, NJ, USA and its affiliates.
#  All rights reserved.
#
#  This file is part of the r2rtf program.
#
#  r2rtf is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.

#' Update unicode_latex data frame
#'
#' Updates the `unicode_latex` mapping table by downloading and
#' processing the `unimathsymbols.txt` file from the specified URL.
#'
#' The original `unimathsymbols.txt` file is licensed under the
#' LaTeX Project Public License (LPPL), version 1.3 or later.
#'
#' @noRd
update_unicode_latex <- function() {
  url <- "https://milde.users.sourceforge.net/LUCR/Math/data/unimathsymbols.txt"

  # FIXME: If we use `quote = ""`, there will be 2757 rows instead of 1740 rows
  tbl <- utils::read.table(
    url,
    header = FALSE,
    sep = "^",
    comment.char = "#",
    stringsAsFactors = FALSE,
    fill = TRUE
  )

  tbl <- tbl[, c(1, 3)]
  tbl <- cbind(tbl, NA)
  names(tbl) <- c("unicode", "latex", "int")

  # FIXME: Apply a few completely ad hoc filters to get
  # data frame identical to the version saved in .rda
  tbl <- tbl[tbl$latex != "", , drop = FALSE]
  tbl <- tbl[grepl("^\\\\", tbl$latex), , drop = FALSE]
  tbl$int <- strtoi(tbl$unicode, base = 16)
  tbl <- tbl[tbl$int >= 177L, , drop = FALSE]
  tbl <- tbl[!(tbl$latex %in% c(
    "\\Micro", "\\times", "\\eth", "\\div", "\\bullet",
    "\\vec", "\\eqcolon", "\\square", "\\blacksquare"
  )), , drop = FALSE]

  rows <- sprintf(
    '"%s", "%s", %d',
    tbl$unicode,
    gsub("\\", "\\\\", tbl$latex, fixed = TRUE),
    tbl$int
  )

  writeLines(c(
    "# Generated by R/utils.R: do not edit by hand",
    "# Please run update_unicode_latex() to regenerate this file",
    "",
    "unicode_latex <- matrix(c(",
    paste0("  ", rows, collapse = ",\n"),
    "), ncol = 3, byrow = TRUE)",
    "",
    "unicode_latex <- as.data.frame(unicode_latex)",
    'names(unicode_latex) <- c("unicode", "latex", "int")',
    "unicode_latex$int <- as.integer(unicode_latex$int)"
  ), con = "R/unicode_latex.R")
}
