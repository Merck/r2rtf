# tests using as_rtf_source
test_that("case when source equals to NULL", {
  x <- iris %>% rtf_body() %>% rtf_source()
  expect_equal(as_rtf_source(x), "{\\pard\\hyphpar\n\\sb15\\sa15\\fi0\\li0\\ri0\\qc\n{\\f0\\fs18 }\n\\par}")
})

test_that("source justification right and identation first 1, left 2", {
  x <- iris %>% rtf_body() %>% rtf_source(source="testing", text_indent_first=1, text_indent_left=2, text_justification = "r")
  expect_equal(as_rtf_source(x),"{\\pard\\hyphpar\n\\sb15\\sa15\\fi1\\li2\\ri0\\qr\n{\\f0\\fs18 testing}\n\\par}")
})

test_that("source justification left and identation first 1, right 2", {
  x <- iris %>% rtf_body() %>% rtf_source(source="testing",text_indent_first=1, text_indent_right =2,text_justification = "l")
  expect_equal(as_rtf_source(x),"{\\pard\\hyphpar\n\\sb15\\sa15\\fi1\\li0\\ri2\\ql\n{\\f0\\fs18 testing}\n\\par}")
})

test_that("source justification left and identation left 2", {
  x <- iris %>% rtf_body() %>% rtf_source(source="testing", text_indent_left =2,text_justification = "l")
  expect_equal(as_rtf_source(x),"{\\pard\\hyphpar\n\\sb15\\sa15\\fi0\\li2\\ri0\\ql\n{\\f0\\fs18 testing}\n\\par}")
})

test_that("source font=2, formats=bold", {
  x <- iris %>% rtf_body() %>% rtf_source(source="testing", text_font=2, text_format="b")
  expect_equal(as_rtf_source(x), "{\\pard\\hyphpar\n\\sb15\\sa15\\fi0\\li0\\ri0\\qc\n{\\f1\\fs18\\b testing}\n\\par}")
})


# tests not using as_rtf_source
test_that("test case on source equals to NULL", {
  x <- iris %>% rtf_body() %>% rtf_source()
  expect_equal(attr(x, "rtf_source")[1], "")
})

test_that("test case on source justification right and identation first 1, left 2", {
  x <- iris %>% rtf_body() %>% rtf_source(source="testing", text_indent_first=1, text_indent_left=2, text_justification = "r")
  expect_equal(attr(attr(x, "rtf_source"), 'text_indent_first'), 1)
  expect_equal(attr(attr(x, "rtf_source"), 'text_indent_left'), 2)
  expect_equal(attr(attr(x, "rtf_source"), 'text_justification'), "r")
})

test_that("test case on source justification left and identation first 1, right 2", {
  x <- iris %>% rtf_body() %>% rtf_source(source="testing",text_indent_first=1, text_indent_right =2,text_justification = "l")
  expect_equal(attr(attr(x, "rtf_source"), 'text_indent_first'), 1)
  expect_equal(attr(attr(x, "rtf_source"), 'text_indent_right'), 2)
  expect_equal(attr(attr(x, "rtf_source"), 'text_justification'), "l")
})

test_that("test case on source justification left and identation left 2", {
  x <- iris %>% rtf_body() %>% rtf_source(source="testing", text_indent_left =2,text_justification = "l")
  expect_equal(attr(attr(x, "rtf_source"), 'text_indent_left'), 2)
  expect_equal(attr(attr(x, "rtf_source"), 'text_justification'), "l")
})


test_that("test case on source font=2, formats=bold ", {
  x <- iris %>% rtf_body() %>% rtf_source(source="testing", text_font = 2, text_format = "b")
  expect_equal(attr(attr(x, "rtf_source"), 'text_font'), 2)
  expect_equal(attr(attr(x, "rtf_source"), 'text_format'), "b")

})




