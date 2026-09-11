test_that("clinical display rounding sends exact ties away from zero", {
  expect_identical(
    format_fixed_ties_away(c(1.25, -1.25), 1),
    c("1.3", "-1.3")
  )
})

test_that("clinical display rounding tolerates binary approximations", {
  expect_identical(
    format_fixed_ties_away(c(1.005, -1.005, 2.675, -2.675), 2),
    c("1.01", "-1.01", "2.68", "-2.68")
  )
  expect_identical(
    format_fixed_ties_away(c(1.004, -1.004), 2),
    c("1.00", "-1.00")
  )
})

test_that("clinical display rounding keeps fixed width without negative zero", {
  expect_identical(
    format_fixed_ties_away(c(76, -0.004, 0), 2),
    c("76.00", "0.00", "0.00")
  )
})

test_that("clinical display rounding validates digits", {
  expect_error(
    format_fixed_ties_away(1, -1),
    "single non-negative integer",
    fixed = TRUE
  )
  expect_error(
    format_fixed_ties_away(1, c(1, 2)),
    "single non-negative integer",
    fixed = TRUE
  )
})
