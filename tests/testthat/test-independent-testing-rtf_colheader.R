test_that("case when colheader equals to NULL", {
  x <- r2rtf_tbl1 %>% rtf_colheader(colheader = NULL)
  expect_true("data.frame" %in% class(x))

  y <- rtf_colheader(r2rtf_tbl1, colheader = NULL)
  expect_equal(attributes(y)$colheader, NULL)

  z <- r2rtf_tbl1 %>% rtf_colheader(colheader = NULL, border_color_left = "green")
  expect_equal(attributes(z)$colheader, NULL)
  expect_equal(attributes(z)$border_color_left, NULL)

  u <- r2rtf_tbl1 %>% rtf_colheader(colheader = " | | ")
  expect_equal(data.frame(attributes(u)$rtf_colheader[[1]]), data.frame(data.frame(X1 = "", X2 = "", X3 = "")))
})

test_that("multiple colheaders separated by |", {
  x <- rtf_colheader(r2rtf_tbl1, "a | b | c")
  expect_equal(data.frame(attributes(x)$rtf_colheader[[1]]), data.frame(X1 = "a", X2 = "b", X3 = "c"))
})

test_that("border color", {
  x <- r2rtf_tbl1 %>%
    rtf_body() %>%
    rtf_colheader(colheader = " a | b | c ", border_color_left = "green")
  xx <- r2rtf_tbl1 %>%
    rtf_body() %>%
    rtf_colheader(colheader = " a | b | c ", border_color_left = c("red", "green", "blue"))
  y <- r2rtf_tbl1 %>%
    rtf_body() %>%
    rtf_colheader(colheader = "  | b |   ", border_color_right = c("red", "green", "blue"))
  z <- r2rtf_tbl1 %>%
    rtf_body() %>%
    rtf_colheader(colheader = " a |   |c  ", border_color_top = c("blue", "green", "blue"))
  u <- r2rtf_tbl1 %>%
    rtf_body() %>%
    rtf_colheader(colheader = " a | b | c ", border_color_bottom = "yellow")

  expect_equal(attr(attr(x, "rtf_colheader")[[2]], "border_color_left")[1, ], c("green", "green", "green"))
  expect_equal(attr(attr(xx, "rtf_colheader")[[2]], "border_color_left")[1, ], c("red", "green", "blue"))
  expect_equal(attr(attr(y, "rtf_colheader")[[2]], "border_color_right")[1, ], c("red", "green", "blue"))
  expect_equal(attr(attr(z, "rtf_colheader")[[2]], "border_color_top")[1, ], c("blue", "green", "blue"))
  expect_equal(attr(attr(u, "rtf_colheader")[[2]], "border_color_bottom")[1, ], c("yellow", "yellow", "yellow"))
})

test_that("border type", {
  x <- r2rtf_tbl1 %>%
    rtf_body() %>%
    rtf_colheader(colheader = " a | b | c ", border_left = c("double", "single", "dot dot"))
  expect_equal(attr(attr(x, "rtf_colheader")[[2]], "border_left")[1, ], c("double", "single", "dot dot"))
})


test_that("cell text formats", {
  x <- r2rtf_tbl1 %>%
    rtf_body() %>%
    rtf_colheader(colheader = " a | b | c ", text_format = c("u", "i", "s"))

  expect_error(rtf_colheader(r2rtf_tbl1, colheader = " a | b | c ", text_format = c("$20.", "$5.", "$20.")))
  expect_error(rtf_colheader(r2rtf_tbl1, colheader = " a | b | c ", text_format = "%m/%d/%Y"))
  expect_error(rtf_colheader(r2rtf_tbl1, colheader = " a | b | c ", text_format = c("a", "b", "c")))
  expect_equal(attr(attr(x, "rtf_colheader")[[2]], "text_format")[1, ], c("u", "i", "s"))
})
