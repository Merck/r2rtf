test_that("input argument checks", {
  expect_error(rtf_title(r2rtf_tbl1, title = 1))
  expect_error(rtf_title(r2rtf_tbl1, subtitle = NA))
  expect_error(rtf_title(r2rtf_tbl1, text_font = "a"))
  expect_error(rtf_title(r2rtf_tbl1, text_font_size = "b"))
  expect_error(rtf_title(r2rtf_tbl1, text_format = "z"))
})

test_that("title format", {
  ## expect NULL if title is NULL
  x <- r2rtf_tbl1 |> rtf_title(title = NULL, subtitle = "Sub-Title", text_format = "b")
  expect_equal(attr(attr(x, "rtf_title"), "title"), NULL)
  expect_equal(attr(x, "rtf_title")[[1]], "Sub-Title")
  expect_equal(attr(attr(x, "rtf_title"), "text_format")[1], "b")

  x <- r2rtf_tbl1 |> rtf_title(title = "Title", subtitle = "Sub-Title", text_format = "b")
  expect_equal(attributes(x)$rtf_title[[1]], "Title")
  expect_equal(attributes(x)$rtf_title[[2]], "Sub-Title")
})

test_that("title font color and background color", {
  x <- r2rtf_tbl1 |> rtf_title(title = "Title", text_color = "green", text_background_color = "blue")
  expect_equal(attr(attr(x, "rtf_title"), "text_color")[1], "green")
  expect_equal(attr(attr(x, "rtf_title"), "text_background_color")[1], "blue")
})

test_that("title justification, spacing and indentation", {
  x <- r2rtf_tbl1 |> rtf_title(
    title = "Title",
    text_justification = "l",
    text_space = 60,
    text_space_before = 6,
    text_space_after = 10,
    text_indent_first = 20,
    text_indent_left = 2,
    text_indent_right = 3
  )
  expect_equal(attr(attr(x, "rtf_title"), "text_justification")[1], "l")
  expect_equal(attr(attr(x, "rtf_title"), "text_space")[1], 60)
  expect_equal(attr(attr(x, "rtf_title"), "text_space_before")[1], 6)
  expect_equal(attr(attr(x, "rtf_title"), "text_space_after")[1], 10)
  expect_equal(attr(attr(x, "rtf_title"), "text_indent_first")[1], 20)
  expect_equal(attr(attr(x, "rtf_title"), "text_indent_left")[1], 2)
  expect_equal(attr(attr(x, "rtf_title"), "text_indent_right")[1], 3)

  expect_error(r2rtf_tbl1 |> rtf_title(justification = "xxx"))
  expect_error(r2rtf_tbl1 |> rtf_title(space = "xxx"))
  expect_error(r2rtf_tbl1 |> rtf_title(indent_first = "xxx"))
})

test_that("multiple subtitles", {
  x <- r2rtf_tbl1 |> rtf_title(title = "Title 1", subtitle = c("Sub-Title 1", "Sub-Title 2", "Sub-Title 3"))
  expect_equal(attributes(x)$rtf_title[[1]], "Title 1")
  expect_equal(attributes(x)$rtf_title[[2]], "Sub-Title 1")
  expect_equal(attributes(x)$rtf_title[[3]], "Sub-Title 2")
  expect_equal(attributes(x)$rtf_title[[4]], "Sub-Title 3")

  x <- r2rtf_tbl1 |> rtf_title(subtitle = c("Sub-Title 1", "Sub-Title 2", "Sub-Title 3"))
  expect_equal(attributes(x)$rtf_title[[1]], "Sub-Title 1")
  expect_equal(attributes(x)$rtf_title[[2]], "Sub-Title 2")
  expect_equal(attributes(x)$rtf_title[[3]], "Sub-Title 3")
})

test_that("text hyphenation parameter", {
  # Test default value (TRUE)
  x <- r2rtf_tbl1 |> rtf_title(title = "Title with Hyphenation")
  expect_equal(attr(attr(x, "rtf_title"), "text_hyphenation"), TRUE)
  
  # Test explicitly setting to FALSE
  x <- r2rtf_tbl1 |> rtf_title(title = "Title without Hyphenation", text_hyphenation = FALSE)
  expect_equal(attr(attr(x, "rtf_title"), "text_hyphenation"), FALSE)
  
  # Test explicitly setting to TRUE
  x <- r2rtf_tbl1 |> rtf_title(title = "Title with Hyphenation", text_hyphenation = TRUE)
  expect_equal(attr(attr(x, "rtf_title"), "text_hyphenation"), TRUE)
  
  # Test with rtf_subline
  x <- r2rtf_tbl1 |> rtf_subline(text = "Subline with default hyphenation")
  expect_equal(attr(attr(x, "rtf_subline"), "text_hyphenation"), TRUE)
  
  x <- r2rtf_tbl1 |> rtf_subline(text = "Subline without hyphenation", text_hyphenation = FALSE)
  expect_equal(attr(attr(x, "rtf_subline"), "text_hyphenation"), FALSE)
})
