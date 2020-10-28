context("Independent testing for rtf_footnote.R")

test_that("case when rtf_page is NULL and footnote equals to NULL", {
  x <- iris %>% rtf_body() %>% rtf_footnote(footnote=)
  expect_equal(as_rtf_footnote(x), "\\trowd\\trgaph108\\trleft0\\trqc\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrw15\\clbrdrr\\brdrs\\brdrw15\\clbrdrb\\brdrs\\brdrw15\\cellx9000\n\\pard\\intbl\\sb15\\sa15\\ql{\\f0\\fs18 }\\cell\n\\intbl\\row\\pard")
})

test_that("case when footnote equals to NULL", {
  x <- iris %>% rtf_page() %>% rtf_body() %>% rtf_footnote(footnote=)
  expect_equal(as_rtf_footnote(x), "\\trowd\\trgaph108\\trleft0\\trqc\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrw15\\clbrdrr\\brdrs\\brdrw15\\clbrdrb\\brdrs\\brdrw15\\cellx9000\n\\pard\\intbl\\sb15\\sa15\\ql{\\f0\\fs18 }\\cell\n\\intbl\\row\\pard")
})

test_that("footnote justification left and identation first 1, left 2", {
  x <- iris %>% rtf_page() %>% rtf_body() %>% rtf_footnote(footnote="testing", text_indent_first=1, text_indent_left=2, text_justification  = "l")
  expect_equal(as_rtf_footnote(x), "\\trowd\\trgaph108\\trleft0\\trqc\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrw15\\clbrdrr\\brdrs\\brdrw15\\clbrdrb\\brdrs\\brdrw15\\cellx9000\n\\pard\\intbl\\sb15\\sa15\\ql{\\f0\\fs18 testing}\\cell\n\\intbl\\row\\pard")
})

test_that("footnote justification right and identation first 1, right 2", {
  x <- iris %>% rtf_page() %>% rtf_body() %>% rtf_footnote(footnote="testing", text_indent_first=1, text_indent_right=2, text_justification  = "r")
  expect_equal(as_rtf_footnote(x), "\\trowd\\trgaph108\\trleft0\\trqc\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrw15\\clbrdrr\\brdrs\\brdrw15\\clbrdrb\\brdrs\\brdrw15\\cellx9000\n\\pard\\intbl\\sb15\\sa15\\qr{\\f0\\fs18 testing}\\cell\n\\intbl\\row\\pard")
})

test_that("footnote justification left and identation left 2", {
  x <- iris %>% rtf_page() %>% rtf_body() %>% rtf_footnote(footnote="testing", text_indent_left=2, text_indent_right=3, text_justification  = "l")
  expect_equal(as_rtf_footnote(x), "\\trowd\\trgaph108\\trleft0\\trqc\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrw15\\clbrdrr\\brdrs\\brdrw15\\clbrdrb\\brdrs\\brdrw15\\cellx9000\n\\pard\\intbl\\sb15\\sa15\\ql{\\f0\\fs18 testing}\\cell\n\\intbl\\row\\pard")
})


test_that("footnote font=2, formats=bold", {
  x <- iris %>% rtf_page() %>% rtf_body() %>% rtf_footnote(footnote="testing", text_font=2, text_format="b")
  expect_equal(as_rtf_footnote(x), "\\trowd\\trgaph108\\trleft0\\trqc\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrw15\\clbrdrr\\brdrs\\brdrw15\\clbrdrb\\brdrs\\brdrw15\\cellx9000\n\\pard\\intbl\\sb15\\sa15\\ql{\\f166\\fs18\\b testing}\\cell\n\\intbl\\row\\pard")

})

test_that("page null", {
  x <- iris
  y <- rtf_page(x)
  expect_equal(y, rtf_page(x))

})


test_that("footnote text color red", {
  x <- iris %>% rtf_page() %>% rtf_body() %>% rtf_footnote(footnote="testing", text_color="red")
  expect_equal(as_rtf_footnote(x), "\\trowd\\trgaph108\\trleft0\\trqc\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrw15\\clbrdrr\\brdrs\\brdrw15\\clbrdrb\\brdrs\\brdrw15\\cellx9000\n\\pard\\intbl\\sb15\\sa15\\ql{\\f0\\fs18\\cf553 testing}\\cell\n\\intbl\\row\\pard")
})


# tests not using as_rtf_source


test_that("case when rtf_page is NULL and footnote equals to NULL", {
  x <- iris %>% rtf_body() %>% rtf_footnote(footnote=)
  expect_equal(attr(x, "rtf_footnote")[1], "")})

test_that("case when footnote equals to NULL", {
  x <- iris %>% rtf_page() %>% rtf_body() %>% rtf_footnote(footnote=)
  expect_equal(attr(x, "rtf_footnote")[1], "")})


test_that("footnote justification left and identation first 1, left 2", {
  x <- iris %>% rtf_page() %>% rtf_body() %>% rtf_footnote(footnote="testing", text_indent_first=1, text_indent_left=2, text_justification  = "r")
  expect_equal(attr(attr(x, "rtf_footnote"), 'text_indent_first'), 1)
  expect_equal(attr(attr(x, "rtf_footnote"), 'text_indent_left'), 2)
  expect_equal(attr(attr(x, "rtf_footnote"), 'text_justification'), "r")
})

test_that("footnote justification left and identation left 2", {
  x <- iris %>% rtf_page() %>% rtf_body() %>% rtf_footnote(footnote="testing", text_indent_left=2, text_indent_right=3, text_justification  = "l")
  expect_equal(attr(attr(x, "rtf_footnote"), 'text_indent_left'), 2)
  expect_equal(attr(attr(x, "rtf_footnote"), 'text_indent_right'), 3)
  expect_equal(attr(attr(x, "rtf_footnote"), 'text_justification'), "l")
})


test_that("footnote font=2, formats=bold", {
  x <- iris %>% rtf_page() %>% rtf_body() %>% rtf_footnote(footnote="testing", text_font=2, text_format="b")
  expect_equal(attr(attr(x, "rtf_footnote"), 'text_font'), 2)
  expect_equal(attr(attr(x, "rtf_footnote"), 'text_format'), "b")

})

test_that("footnote text color red", {
  x <- iris %>% rtf_page() %>% rtf_body() %>% rtf_footnote(footnote="testing", text_color="red")
  expect_equal(attr(attr(x, "rtf_footnote"), 'text_color'), "red")
})
