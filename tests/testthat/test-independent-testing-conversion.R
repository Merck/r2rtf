test_that("cell size inch to twip conversion", {
  expect_equal(inch_to_twip(1), 1440)
  expect_equal(inch_to_twip(1.72), round(1.72 * 1440))

  a <- c(20, 50, 40)
  expect_equal(cell_size(a, 20), round(inch_to_twip(20) / sum(a) * a))
})

test_that("UTF-8 to RTF encode conversion", {
  expect_error(utf8Tortf(8))
  expect_equal(utf8Tortf("老人Z"), "\\uc1\\u--32767?\\uc1\\u20154?Z")
})
