test_that("test update_border_first when attr(tbl, 'rtf_colheader') is not NULL", {
  tbl <- iris[1:2, ] %>%
    rtf_page(border_color_first = "red") %>%
    rtf_body() %>%
    update_border_first()

  expect_equal(attributes(attr(tbl, "rtf_colheader")[[1]])$border_top, matrix("double", nrow = 1, ncol = 5))
  expect_equal(attributes(attr(tbl, "rtf_colheader")[[1]])$border_color_top, matrix("red", nrow = 1, ncol = 5))
})


test_that("test update_border_first when attr(tbl, 'rtf_colheader') is NULL", {
  tbl <- iris[c(1:2, 51:52), ] %>%
    rtf_page(border_color_first = "red") %>%
    rtf_body(
      page_by = "Species",
      new_page = TRUE
    )
  attr(tbl, "rtf_colheader") <- NULL
  tbl <- update_border_first(tbl)

  expect_equal(attributes(tbl)$border_first[1, ], c(rep("double", 5)))
  expect_equal(attributes(tbl)$border_color_first[1, ], rep("red", 5))
  expect_equal(attributes(attr(tbl, "rtf_pageby_table"))$border_first[1, ], c(rep("double", 4)))
  expect_equal(attributes(attr(tbl, "rtf_pageby_table"))$border_color_first[1, ], rep("red", 4))
})


test_that("test update_border_last when 'footnote' as_table", {
  tbl <- iris[1:2, ] %>%
    rtf_page(
      border_color_first = "red",
      border_color_last = "red"
    ) %>%
    rtf_body() %>%
    rtf_footnote("footnote",
      as_table = TRUE
    )

  tbl <- update_border_last(tbl)

  expect_equal(attributes(attr(tbl, "rtf_footnote"))$border_bottom, "double")
  expect_equal(attributes(attr(tbl, "rtf_footnote"))$border_color_bottom, "red")
})


test_that("test update_border_last when 'source' as_table", {
  tbl <- iris[1:2, ] %>%
    rtf_page(
      border_color_first = "red",
      border_color_last = "red"
    ) %>%
    rtf_body() %>%
    rtf_source("source",
      as_table = TRUE
    )

  tbl <- update_border_last(tbl)

  expect_equal(attributes(attr(tbl, "rtf_source"))$border_bottom, "double")
  expect_equal(attributes(attr(tbl, "rtf_source"))$border_color_bottom, "red")
})


test_that("test update_border_last when body as last", {
  tbl <- iris[c(1:2, 51:52), ] %>%
    rtf_page(
      border_color_first = "red",
      border_color_last = "red"
    ) %>%
    rtf_body(
      page_by = "Species",
      new_page = TRUE
    )

  tbl <- update_border_last(tbl)

  expect_equal(attributes(tbl)$border_last[nrow(tbl), ], c(rep("double", 5)))
  expect_equal(attributes(tbl)$border_color_last[nrow(tbl), ], rep("red", 5))
  expect_equal(attributes(attr(tbl, "rtf_pageby_table"))$border_last[nrow(attr(tbl, "rtf_pageby_table")), ], c(rep("double", 4)))
  expect_equal(attributes(attr(tbl, "rtf_pageby_table"))$border_color_last[nrow(attr(tbl, "rtf_pageby_table")), ], rep("red", 4))
})
