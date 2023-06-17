tbl <- iris[1, ] |>
  rtf_body() |>
  rtf_title("title")
teststr <- attr(tbl, "rtf_title")

test_that("test if title is converted to RTF correctly", {
  expect_snapshot_output(as_rtf_paragraph(teststr))
})

tbl <- iris[1, ] |>
  rtf_body() |>
  rtf_footnote("footnote")
teststr <- attr(tbl, "rtf_footnote")

test_that("test if footnote is converted to RTF correctly", {
  expect_snapshot_output(as_rtf_paragraph(teststr))
})

tbl <- iris[1, ] |>
  rtf_body() |>
  rtf_source("source")
teststr <- attr(tbl, "rtf_source")

test_that("test if source is converted to RTF correctly", {
  expect_snapshot_output(as_rtf_paragraph(teststr))
})
