test_that("case when page footer equals to default", {
  x <- iris %>%
    rtf_page() %>%
    rtf_body() %>%
    rtf_page_header()
  expect_equal(attr(x, "rtf_page_header")[1], "Page \\pagenumber of \\pagefield")
})

test_that("case when page footer equals to NULL", {
  x <- iris %>%
    rtf_page() %>%
    rtf_body() %>%
    rtf_page_header(text = "")
  expect_equal(attr(x, "rtf_page_header")[1], "")
})

test_that("page header justification right and identation first 1, left 2", {
  x <- iris %>%
    rtf_page() %>%
    rtf_body() %>%
    rtf_page_header(text = "testing", text_indent_first = 1, text_indent_left = 2, text_justification = "r")
  expect_equal(attr(attr(x, "rtf_page_header"), "text_indent_first"), 1)
  expect_equal(attr(attr(x, "rtf_page_header"), "text_indent_left"), 2)
  expect_equal(attr(attr(x, "rtf_page_header"), "text_justification"), "r")
})

test_that("page header justification left and identation left 2, right 3", {
  x <- iris %>%
    rtf_page() %>%
    rtf_body() %>%
    rtf_page_header(text = "testing", text_indent_left = 2, text_indent_right = 3, text_justification = "l")
  expect_equal(attr(attr(x, "rtf_page_header"), "text_indent_left"), 2)
  expect_equal(attr(attr(x, "rtf_page_header"), "text_indent_right"), 3)
  expect_equal(attr(attr(x, "rtf_page_header"), "text_justification"), "l")
})


test_that("page header font=2, formats=bold", {
  x <- iris %>%
    rtf_page() %>%
    rtf_body() %>%
    rtf_page_header(text = "testing", text_font = 2, text_format = "b")
  expect_equal(attr(attr(x, "rtf_page_header"), "text_font"), 2)
  expect_equal(attr(attr(x, "rtf_page_header"), "text_format"), "b")
})

test_that("footnote text color red", {
  x <- iris %>%
    rtf_page() %>%
    rtf_body() %>%
    rtf_page_header(text = "testing", text_color = "red")
  expect_equal(attr(attr(x, "rtf_page_header"), "text_color"), "red")
})
