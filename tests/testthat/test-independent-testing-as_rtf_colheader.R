test_that("Case when colheader equals to NULL", {
  x <- iris %>% rtf_colheader(colheader = "")
  expect_null(as_rtf_colheader(x))

  x <- iris %>% rtf_colheader(colheader = "", border_color_left = "red")
  expect_null(as_rtf_colheader(x))
})

test_that("Case when colheader is not NULL and border color is specified", {
  x <- iris %>% rtf_colheader(colheader = "a | b| c", border_color_left = "green")
  expect_snapshot_output(as_rtf_colheader(x))

  x <- iris %>% rtf_colheader(colheader = "a | b| c", border_color_left = "red", border_color_right = "red")
  expect_snapshot_output(as_rtf_colheader(x))
})

test_that("case when colheader is not NULL and border type is specified", {
  x <- iris %>% rtf_colheader(colheader = "a | b| c", border_right = "double")
  expect_snapshot_output(as_rtf_colheader(x))

  x <- iris %>% rtf_colheader(colheader = "a | b| c", border_top = "dot dash")
  expect_snapshot_output(as_rtf_colheader(x))
})

test_that("case when colheader is not NULL and cell text formats is specified", {
  x <- iris %>% rtf_colheader(colheader = "a | b| c", text_format = "i")
  expect_snapshot_output(as_rtf_colheader(x))

  x <- iris %>% rtf_colheader(colheader = "a | b| c", text_format = "b")
  expect_snapshot_output(as_rtf_colheader(x))
})
