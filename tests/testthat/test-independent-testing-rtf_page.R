df <- data.frame(x = 1)
test_that("Test if argument types are checked correctly", {
  expect_error(rtf_page(df, width = c("11")))
  expect_error(rtf_page(df, width = c(11, 8)))
  expect_error(rtf_page(df, height = c("11")))
  expect_error(rtf_page(df, height = c(11, 8)))

  expect_error(rtf_page(df, orientation = 11))
  expect_error(rtf_page(df, orientation = c("a", "b")))

  expect_error(rtf_page(df, margin = c("11")))
  expect_error(rtf_page(df, margin = 1))

  expect_error(rtf_page(df, nrow = c("11")))
  expect_error(rtf_page(df, nrow = c(1, 2)))

  expect_error(rtf_page(df, col_width = c("11")))
  expect_error(rtf_page(df, col_width = c(1, 2)))

  expect_error(rtf_page(df, use_i18n = "TRUE"))
  expect_error(rtf_page(df, use_i18n = c(TRUE, FALSE)))
})

test_that("Test if function will stop when providing invalid argument values", {
  expect_error(rtf_page(df, width = 0))
  expect_error(rtf_page(df, height = 0))
  expect_error(rtf_page(df, margin = rep(0, 6)))
  expect_error(rtf_page(df, orientation = "ori"))
  expect_error(rtf_page(df, nrow = 0))
  expect_error(rtf_page(df, col_width = 0))
})

test_that("Test if attributes are assigned correctly", {
  df <- rtf_page(df)
  att_df <- attributes(df)

  expect_equal(att_df$page$width, 8.5)
  expect_equal(att_df$page$height, 11)
  expect_equal(att_df$page$margin, set_margin("wma", "portrait"))
  expect_equal(att_df$page$nrow, 40)
  expect_equal(att_df$page$border_first, "double")
  expect_equal(att_df$page$border_last, "double")
  expect_equal(att_df$page$use_color, FALSE)
  expect_equal(att_df$page$col_width, 8.5 - 2.25)

  df <- rtf_page(df, border_color_first = "red")
  att_df <- attributes(df)

  expect_equal(att_df$page$use_color, TRUE)
  expect_equal(att_df$page$border_color_first, "red")
})

test_that("Test if use_i18n flag is assigned correctly", {
  # Test default value
  df_default <- rtf_page(df)
  expect_equal(attr(df_default, "page")$use_i18n, FALSE)

  # Test when set to TRUE
  df_i18n <- rtf_page(df, use_i18n = TRUE)
  expect_equal(attr(df_i18n, "page")$use_i18n, TRUE)

  # Test when set to FALSE explicitly
  df_no_i18n <- rtf_page(df, use_i18n = FALSE)
  expect_equal(attr(df_no_i18n, "page")$use_i18n, FALSE)
})

test_that("Test if attributes are assigned correctly for orientation not portrait", {
  dfl <- rtf_page(df, orientation = "landscape")
  att_dfl <- attributes(dfl)

  expect_equal(att_dfl$page$width, 11)
  expect_equal(att_dfl$page$height, 8.5)
  expect_equal(att_dfl$page$margin, set_margin("wma", "landscape"))
  expect_equal(att_dfl$page$nrow, 24)
  expect_equal(att_dfl$page$border_first, "double")
  expect_equal(att_dfl$page$border_last, "double")
  expect_equal(att_dfl$page$col_width, 11 - 2.5)
})


test_that("Test when color is used", {
  df <- rtf_page(df, border_color_first = "red")
  att_df <- attr(df, "page")
  expect_true(att_df$use_color)
})
