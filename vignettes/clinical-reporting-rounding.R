## ----clinical-reporting-rounding---------------------------------------------
# Clinical-reporting examples keep values unrounded during analysis and call
# these helpers only when preparing values for display. The small tolerance
# preserves decimal ties that cannot be represented exactly as binary doubles.
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

format_fixed_ties_away <- function(x, digits = 0) {
  formatC(
    round_ties_away(x, digits),
    digits = digits,
    format = "f",
    flag = "0"
  )
}
