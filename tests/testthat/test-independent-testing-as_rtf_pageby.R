library(dplyr)

test_that("Test for case when output has title, footnote and source", {
  x <- iris[1:2, ] |>
    rtf_title("Title") |>
    rtf_footnote("Footnote") |>
    rtf_source("DataSource") |>
    rtf_body() |>
    rtf_pageby(page_by = "Species", new_page = TRUE, pageby_header = TRUE) |>
    as_rtf_pageby()

  expect_snapshot_output(x)
})

test_that("Test the pageby rows are the last rows of a page", {
  x <- iris |>
    rtf_title("Title") |>
    rtf_footnote("Footnote") |>
    rtf_source("DataSource") |>
    rtf_body() |>
    rtf_pageby(page_by = "Species", new_page = TRUE, pageby_header = FALSE)

  y <- as.data.frame(attributes(as_rtf_pageby(x))) |>
    group_by(info.id) |>
    summarise_all(last) |>
    mutate(row = substr(as.character(info.page), 1, 1))

  z <- as.data.frame(table(x$Species)) |>
    mutate(cu = cumsum(Freq))
  z <- z |> mutate(cum = cu + as.numeric(rownames(z)))

  expect_equal(y$row, rownames(y))
  expect_equal(y$info.index, z$cum)
  expect_false(all(y$info.pageby))
})

test_that("Test if border type/color for first/last row are assigned correctly", {
  x <- iris |>
    rtf_body(
      border_first = c("single", "dash", "dot", "triple", ""),
      border_last = c("single", "dash", "dot", "triple", ""),
      border_color_top = c("black", "gold", "ivory", "blue", "white"),
      border_color_bottom = c("black", "gold", "ivory", "blue", "white"),
      border_color_first = c("azure", "gold", "ivory", "bisque", "white"),
      border_color_last = c("red", "gold", "ivory", "bisque", "white")
    ) |>
    rtf_pageby(page_by = "Species", new_page = TRUE, pageby_header = TRUE) |>
    as_rtf_pageby()

  attr(x, "info") <- NULL

  expect_snapshot_output(x[1])
})

test_that("Test if page_dict attribute is created for tbl", {
  x <- iris |>
    rtf_body() |>
    rtf_pageby(page_by = "Species", new_page = TRUE, pageby_header = FALSE)

  y <- as_rtf_pageby(x)

  expect_equal(names(attributes(y)), "info")
  if (interactive()) expect_snapshot_output(y)
})


test_that("Test for more than one page_by var", {
  x <- iris |>
    mutate(cat = rep(1:5, 30)) |>
    arrange(Species, cat) |>
    rtf_page(nrow = 5) |>
    rtf_body() |>
    rtf_pageby(page_by = c("Species", "cat"), new_page = TRUE, pageby_header = TRUE)

  y <- as_rtf_pageby(x)
  expect_equal(names(attributes(y)), c("names", "info"))
  if (interactive()) expect_snapshot_output(y)
})


test_that("Test if new_page is FALSE and group_by is NOT NULL", {
  iris1 <- iris
  iris1$cat <- iris1$Species
  x <- iris1 |>
    rtf_body(group_by = "cat") |>
    rtf_pageby(page_by = "Species", new_page = FALSE, pageby_header = FALSE)
  y <- as_rtf_pageby(x)

  expect_equal(names(attributes(y)), "info")

  if (interactive()) expect_snapshot_output(y)
})

test_that("Test whether lines with '-----' were removed correctly", {
  x <- distinct(iris |> subset(Species != "virginica"), Species, .keep_all = T) |>
    mutate(Species = ifelse(Species == "setosa", "-----", Species)) |>
    rtf_colheader("Sepal.Length | Sepal.Width | Petal.Length | Petal.Width",
      col_rel_width = rep(1, 4)
    ) |>
    rtf_body(
      page_by = "Species",
      text_justification = c(rep("c", 4), "l"),
      border_top = c(rep("", 4), "single"),
      border_bottom = c(rep("", 4), "single")
    ) |>
    rtf_encode()

  expect_snapshot_output(x$body)
})


test_that("Test when using subline_by and page_by together in rtf_body", {
  tbl1 <- iris[c(1:4, 51:54), 3:5] |>
    mutate(s2 = paste0(Species, 1:2), s3 = s2) |>
    arrange(Species, s2) |>
    rtf_body(
      subline_by = "s2",
      page_by = "Species"
    ) |>
    rtf_encode()

  expect_snapshot_output(tbl1$body)
})


test_that("Test when using subline_by and page_by with pageby_row = 'first_row' in rtf_body", {
  tbl2 <- iris[c(1:4, 51:54), 3:5] |>
    mutate(s2 = paste0(Species, 1:2), s3 = s2) |>
    arrange(Species, s2) |>
    rtf_body(
      subline_by = "s2",
      page_by = "Species",
      pageby_row = "first_row"
    ) |>
    rtf_encode()

  expect_snapshot_output(tbl2$body)
})
