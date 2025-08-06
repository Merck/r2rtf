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
  df_i18n <- df %>%
    rtf_page(use_i18n = TRUE) %>%
    rtf_title(title = "Test Table") %>%
    rtf_colheader(colheader = "Column 1 | Column 2") %>%
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
  df_i18n <- df %>%
    rtf_page(use_i18n = TRUE) %>%
    rtf_body(text_font = 11)

  # Font 11 should be valid - stored in text_font attribute as a matrix
  expect_equal(as.numeric(attr(df_i18n, "text_font")), 11)
})

test_that("UTF-8 conversion is applied when i18n is enabled", {
  # Create test data with non-ASCII characters using Unicode escape sequences
  test_char <- "\u6d4b\u8bd5"
  data_char <- "\u6570\u636e"
  title_char <- "\u6807\u9898"

  df <- data.frame(
    col1 = c(test_char, data_char),
    col2 = c("Test", "Data")
  )

  # Test with i18n enabled
  df_i18n <- df %>%
    rtf_page(use_i18n = TRUE) %>%
    rtf_title(title_char) %>%
    rtf_body()

  # Generate RTF code
  rtf_code <- rtf_encode(df_i18n)

  # Check that Unicode escape sequences are present
  all_text <- paste(unlist(rtf_code), collapse = " ")
  expect_true(grepl("\\\\u[0-9]+", all_text))

  # Test without i18n - non-ASCII characters should not be converted
  df_no_i18n <- df %>%
    rtf_page(use_i18n = FALSE) %>%
    rtf_body()

  rtf_code_no_i18n <- rtf_encode(df_no_i18n)
  all_text_no_i18n <- paste(unlist(rtf_code_no_i18n), collapse = " ")

  # Without i18n, the raw UTF-8 characters should remain
  # (they may not display correctly in RTF, but won't have \\u escapes)
  expect_true(grepl(test_char, all_text_no_i18n) || !grepl("\\\\u27979\\\\u35797", all_text_no_i18n))
})
