test_that("case when colheader equals to NULL", {
  x <- tbl_1 %>% rtf_colheader(colheader = NULL)
  expect_true( "data.frame" %in% class(x))

  y <- rtf_colheader(tbl_1, colheader = NULL)
  expect_equal(attributes(y)$colheader, NULL)

  z <- tbl_1 %>% rtf_colheader(colheader =NULL, border_color_left   = "green")
  expect_equal(attributes(z)$colheader, NULL)
  expect_equal(attributes(z)$border_color_left, NULL)

  u <- tbl_1 %>% rtf_colheader(colheader =" | | ")
  expect_equal(data.frame(attributes(u)$rtf_colheader[[1]]), data.frame(data.frame(X1 = "", X2 = "", X3 ="")))
})

test_that("multiple colheaders separated by |", {
  x <- rtf_colheader(tbl_1, "a | b | c")
  expect_equal(data.frame(attributes(x)$rtf_colheader[[1]]), data.frame(X1="a", X2="b", X3="c"))
})

test_that("border color", {
  x <- tbl_1 %>% rtf_body() %>% rtf_colheader(colheader =" a | b | c ", border_color_left   = "green")
  xx <- tbl_1 %>% rtf_body() %>% rtf_colheader(colheader =" a | b | c ", border_color_left  = c("red", "green", "blue"))
  y <- tbl_1 %>% rtf_body() %>% rtf_colheader(colheader = "  | b |   ", border_color_right  = c("red", "green", "blue"))
  z <- tbl_1 %>% rtf_body() %>% rtf_colheader(colheader =" a |   |c  ", border_color_top    = c("blue", "green", "blue"))
  u <- tbl_1 %>% rtf_body() %>% rtf_colheader(colheader =" a | b | c ", border_color_bottom = "yellow")

  expect_equal(attr(attr(x, "rtf_colheader")[[2]], 'border_color_left')[1,], c("green", "green", "green"))
  expect_equal(attr(attr(xx, "rtf_colheader")[[2]], 'border_color_left')[1,], c("red", "green", "blue"))
  expect_equal(attr(attr(y, "rtf_colheader")[[2]], 'border_color_right')[1,], c("red", "green", "blue"))
  expect_equal(attr(attr(z, "rtf_colheader")[[2]], 'border_color_top')[1,], c("blue", "green", "blue"))
  expect_equal(attr(attr(u, "rtf_colheader")[[2]], 'border_color_bottom')[1,], c("yellow", "yellow", "yellow"))

})

test_that("border type", {
  x <- tbl_1 %>% rtf_body() %>% rtf_colheader(colheader =" a | b | c ", border_left   = c("double", "wavy", "engrave"))
  y <- tbl_1 %>% rtf_body() %>% rtf_colheader(colheader =" a | b | c ", border_right  = "hairline")
  z <- tbl_1 %>% rtf_body() %>% rtf_colheader(colheader =" a | b | c ", border_top    = "dot dot")
  u <- tbl_1 %>% rtf_body() %>% rtf_colheader(colheader =" a | b | c ", border_bottom = "thin thick medium")

  expect_equal(attr(attr(x, "rtf_colheader")[[2]], 'border_left')[1,], c("double", "wavy", "engrave"))
  expect_equal(attr(attr(y, "rtf_colheader")[[2]], 'border_right')[1,], c("hairline", "hairline", "hairline") )
  expect_equal(attr(attr(z, "rtf_colheader")[[2]], 'border_top')[1,], c("dot dot", "dot dot", "dot dot") )
  expect_equal(attr(attr(u, "rtf_colheader")[[2]], 'border_bottom')[1,], c("thin thick medium", "thin thick medium", "thin thick medium") )
})


test_that("cell text formats", {
  x <- tbl_1 %>% rtf_body() %>% rtf_colheader(colheader =" a | b | c ", text_format   = c("u", "i", "s"))

  expect_error(rtf_colheader(tbl_1, colheader =" a | b | c ", text_format   = c("$20.", "$5.", "$20.")))
  expect_error(rtf_colheader(tbl_1, colheader =" a | b | c ", text_format   = "%m/%d/%Y"))
  expect_error(rtf_colheader(tbl_1, colheader =" a | b | c ", text_format   = c("a", "b", "c")))
  expect_warning(rtf_colheader(tbl_1, colheader =" a | b | c ", text_format   = c("b", "b", "b", "b")))
  expect_equal(attr(attr(x, "rtf_colheader")[[2]], 'text_format')[1,], c("u", "i", "s"))

})