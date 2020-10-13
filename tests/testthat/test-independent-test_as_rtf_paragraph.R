context("Independent testing for as_rtf_paragraph.R")

tbl <- iris[1,] %>% rtf_body() %>% rtf_title("title")
teststr <- attr(tbl, "rtf_title")

test_that("test if title is converted to RTF correctly", {
  expect_equal(as_rtf_paragraph(teststr),"{\\pard\\hyphpar\n\\sb180\\sa180\\fi0\\li0\\ri0\\qc\n{\\f0\\fs24 title}\n\\par}")
})

tbl <- iris[1,] %>% rtf_body() %>% rtf_footnote("footnote")
teststr <- attr(tbl, "rtf_footnote")

test_that("test if footnote is converted to RTF correctly", {
  expect_equal(as_rtf_paragraph(teststr),"{\\pard\\hyphpar\n\\sb15\\sa15\\fi0\\li0\\ri0\\ql\n{\\f0\\fs18 footnote}\n\\par}")
})

tbl <- iris[1,] %>% rtf_body() %>% rtf_source("source")
teststr <- attr(tbl, "rtf_source")

test_that("test if source is converted to RTF correctly", {
  expect_equal(as_rtf_paragraph(teststr),"{\\pard\\hyphpar\n\\sb15\\sa15\\fi0\\li0\\ri0\\qc\n{\\f0\\fs18 source}\n\\par}")
})

