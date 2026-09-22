#  Copyright (c) 2026 Merck & Co., Inc., Rahway, NJ, USA and its affiliates.
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

#' Round numeric values ties-away-from-zero
#'
#' Clinical-reporting examples keep values unrounded during analysis and call
#' these helpers only when preparing values for display. The small tolerance
#' preserves decimal ties that cannot be represented exactly as binary doubles.
#'
#' @noRd
round_ties_away <- function(x, digits = 0) {
  if (
    length(digits) != 1L ||
      !is.numeric(digits) ||
      !is.finite(digits) ||
      digits < 0 ||
      digits != trunc(digits)
  ) {
    stop("`digits` must be a single non-negative integer.", call. = FALSE)
  }

  scale <- 10^digits
  if (!is.finite(scale)) {
    stop("`digits` is too large to format.", call. = FALSE)
  }

  rounded <- trunc(abs(x) * scale + 0.5 + sqrt(.Machine$double.eps)) /
    scale * sign(x)
  is_zero <- !is.na(rounded) & rounded == 0
  rounded[is_zero] <- 0
  rounded
}

#' Format numeric values with fixed decimal places
#'
#' Applies [round_ties_away()] and then retains the requested number of
#' decimal places with fixed-point formatting.
#'
#' @noRd
format_fixed_ties_away <- function(x, digits = 0) {
  formatC(
    round_ties_away(x, digits),
    digits = digits,
    format = "f",
    flag = "0"
  )
}
