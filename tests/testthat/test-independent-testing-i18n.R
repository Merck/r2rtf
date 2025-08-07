test_that("Font table generation with i18n support", {
  # Create test data
  df <- data.frame(x = "test", y = "data")

  # Test without i18n
  df_no_i18n <- rtf_page(df, use_i18n = FALSE)
  font_table_no_i18n <- as_rtf_font(df_no_i18n)

  # Should not contain SimSun
  expect_false(grepl("SimSun", font_table_no_i18n))
  expect_false(grepl("\\\\f10", font_table_no_i18n))
  expect_false(grepl("\\\\fcharset134", font_table_no_i18n))

  # Test with i18n
  df_i18n <- rtf_page(df, use_i18n = TRUE)
  font_table_i18n <- as_rtf_font(df_i18n)

  # Should contain SimSun
  expect_true(grepl("SimSun", font_table_i18n))
  expect_true(grepl("\\\\f10", font_table_i18n))
  expect_true(grepl("\\\\fcharset134", font_table_i18n))
})

test_that("RTF encoding preserves i18n flag", {
  # Create test data
  df <- data.frame(
    col1 = c("A", "B"),
    col2 = c("1", "2")
  )

  # Add RTF attributes with i18n enabled
  df_i18n <- df |>
    rtf_page(use_i18n = TRUE) |>
    rtf_title(title = "Test Table") |>
    rtf_colheader(colheader = "Column 1 | Column 2") |>
    rtf_body()

  # Generate RTF code
  rtf_code <- rtf_encode(df_i18n)

  # Check that SimSun font is included
  expect_true(any(grepl("SimSun", rtf_code)))
  expect_true(any(grepl("\\\\f10\\\\fnil\\\\fcharset134", rtf_code)))
})

test_that("Font type 11 can be used with i18n enabled", {
  # Create test data
  df <- data.frame(x = "test")

  # Should accept font type 11 when i18n is enabled
  df_i18n <- df |>
    rtf_page(use_i18n = TRUE) |>
    rtf_body(text_font = 11)

  # Font 11 should be valid - stored in text_font attribute as a matrix
  expect_equal(as.numeric(attr(df_i18n, "text_font")), 11)
})
