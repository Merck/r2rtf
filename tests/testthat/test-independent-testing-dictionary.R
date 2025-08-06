test_that("text font", {
  expect_snapshot_output(font_type())
})

test_that("text font with i18n support", {
  # Test without i18n
  fonts_default <- font_type(use_i18n = FALSE)
  expect_equal(nrow(fonts_default), 10)
  expect_equal(max(fonts_default$type), 10)

  # Test with i18n
  fonts_i18n <- font_type(use_i18n = TRUE)
  expect_equal(nrow(fonts_i18n), 11)
  expect_equal(max(fonts_i18n$type), 11)

  # Check SimSun is included
  expect_true("SimSun" %in% fonts_i18n$name)
  expect_equal(fonts_i18n[fonts_i18n$name == "SimSun", "type"], 11)
  expect_equal(fonts_i18n[fonts_i18n$name == "SimSun", "rtf_code"], "\\f10")
  expect_equal(fonts_i18n[fonts_i18n$name == "SimSun", "charset"], "\\fcharset134")
  expect_equal(fonts_i18n[fonts_i18n$name == "SimSun", "style"], "\\fnil")
})

test_that("text color", {
  t_color <- data.frame(color = grDevices::colors())
  t_color$type <- 1:nrow(t_color)
  t_color <- cbind(t_color, t(grDevices::col2rgb(t_color$color)))
  t_color$rtf_code <- paste0("\\red", t_color$red, "\\green", t_color$green, "\\blue", t_color$blue, ";")

  expect_equal(color_table(), t_color)
})

test_that("text format", {
  t_format <- data.frame(
    type = c("", "b", "i", "u", "s", "^", "_"),
    name = c("normal", "bold", "italics", "underline", "strike", "superscript", "subscript"),
    rtf_code = c("", "\\b", "\\i", "\\ul", "\\strike", "\\super", "\\sub"),
    stringsAsFactors = FALSE
  )

  expect_equal(font_format(), t_format)
})

test_that("text justification", {
  t_just <- data.frame(
    type = c("l", "c", "r", "d", "j"),
    name = c("left", "center", "right", "decimal", "justified"),
    rtf_code_text = c("\\ql", "\\qc", "\\qr", "\\qj", "\\qj"),
    rtf_code_row = c("\\trql", "\\trqc", "\\trqr", "", ""),
    stringsAsFactors = FALSE
  )

  expect_equal(justification(), t_just)
})

test_that("border type", {
  expect_snapshot_output(border_type())
})


test_that("spacing", {
  spacing <- data.frame(
    type = c(1, 2, 1.5),
    name = c("single-space", "double-space", "1.5-space"),
    rtf_code = c("", "\\sl480\\slmult1", "\\sl360\\slmult1"),
    stringsAsFactors = FALSE
  )
  expect_equal(spacing(), spacing)
})
