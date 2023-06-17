# tests using as_rtf_source
test_that("case when source equals to NULL", {
  x <- iris |>
    rtf_body() |>
    rtf_source()
  expect_snapshot_output(as_rtf_source(x))
})

test_that("source justification right and identation first 1, left 2", {
  x <- iris |>
    rtf_body() |>
    rtf_source(source = "testing", text_indent_first = 1, text_indent_left = 2, text_justification = "r")
  expect_snapshot_output(as_rtf_source(x))
})

test_that("source justification left and identation first 1, right 2", {
  x <- iris |>
    rtf_body() |>
    rtf_source(source = "testing", text_indent_first = 1, text_indent_right = 2, text_justification = "l")
  expect_snapshot_output(as_rtf_source(x))
})

test_that("source justification left and identation left 2", {
  x <- iris |>
    rtf_body() |>
    rtf_source(source = "testing", text_indent_left = 2, text_justification = "l")
  expect_snapshot_output(as_rtf_source(x))
})

test_that("source font=2, formats=bold", {
  x <- iris |>
    rtf_body() |>
    rtf_source(source = "testing", text_font = 2, text_format = "b")
  expect_snapshot_output(as_rtf_source(x))
})


# tests not using as_rtf_source
test_that("test case on source equals to NULL", {
  x <- iris |>
    rtf_body() |>
    rtf_source()
  expect_equal(attr(x, "rtf_source")[1], "")
})

test_that("test case on source justification right and identation first 1, left 2", {
  x <- iris |>
    rtf_body() |>
    rtf_source(source = "testing", text_indent_first = 1, text_indent_left = 2, text_justification = "r")
  expect_equal(attr(attr(x, "rtf_source"), "text_indent_first"), 1)
  expect_equal(attr(attr(x, "rtf_source"), "text_indent_left"), 2)
  expect_equal(attr(attr(x, "rtf_source"), "text_justification"), "r")
})

test_that("test case on source justification left and identation first 1, right 2", {
  x <- iris |>
    rtf_body() |>
    rtf_source(source = "testing", text_indent_first = 1, text_indent_right = 2, text_justification = "l")
  expect_equal(attr(attr(x, "rtf_source"), "text_indent_first"), 1)
  expect_equal(attr(attr(x, "rtf_source"), "text_indent_right"), 2)
  expect_equal(attr(attr(x, "rtf_source"), "text_justification"), "l")
})

test_that("test case on source justification left and identation left 2", {
  x <- iris |>
    rtf_body() |>
    rtf_source(source = "testing", text_indent_left = 2, text_justification = "l")
  expect_equal(attr(attr(x, "rtf_source"), "text_indent_left"), 2)
  expect_equal(attr(attr(x, "rtf_source"), "text_justification"), "l")
})


test_that("test case on source font=2, formats=bold ", {
  x <- iris |>
    rtf_body() |>
    rtf_source(source = "testing", text_font = 2, text_format = "b")
  expect_equal(attr(attr(x, "rtf_source"), "text_font"), 2)
  expect_equal(attr(attr(x, "rtf_source"), "text_format"), "b")
})

test_that("source justification right and identation right 2, and text_indent_reference is table/page_margin", {
  x <- iris |>
    rtf_page(width = 5.5, col_width = 3) |>
    rtf_body()
  x_table <- x |> rtf_source(
    source = "testing", text_indent_right = 2, text_justification = "r",
    text_indent_reference = "table"
  )
  expect_equal(attr(attr(x_table, "rtf_source"), "text_indent_right"), 2 + 180)

  x_page <- x |> rtf_source(
    source = "testing", text_indent_right = 2, text_justification = "r",
    text_indent_reference = "page_margin"
  )
  expect_equal(attr(attr(x_page, "rtf_source"), "text_indent_right"), 2 + 0)
})
