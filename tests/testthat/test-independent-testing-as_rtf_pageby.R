library(dplyr)

test_that("Test for case when output has title, footnote and source", {

   x <- iris[1:2, ] %>%
        rtf_title("Title") %>%
        rtf_footnote("Footnote") %>%
        rtf_source("DataSource") %>%
        rtf_body() %>%
        rtf_pageby(page_by="Species", new_page = TRUE, pageby_header = TRUE ) %>%
        as_rtf_pageby()

   expect_snapshot_output(x)

})

test_that("Test the pageby rows are the last rows of a page", {

  x <- iris %>%
    rtf_title("Title") %>%
    rtf_footnote("Footnote") %>%
    rtf_source("DataSource") %>%
    rtf_body() %>%
    rtf_pageby(page_by="Species", new_page = TRUE, pageby_header = FALSE )

  y <- as.data.frame(attributes(as_rtf_pageby(x))) %>%
       group_by(info.id) %>%
       summarise_all(last) %>%
       mutate(row = substr(as.character(info.page),1,1))

  z <- as.data.frame(table(x$Species)) %>%
       mutate(cu = cumsum(Freq))
  z <- z %>%mutate(cum = cu + as.numeric(rownames(z)))

  expect_equal(y$row, rownames(y))
  expect_equal(y$info.index, z$cum)
  expect_false(all(y$info.pageby))

})

test_that("Test if border type/color for first/last row are assigned correctly", {

   x <- iris %>%
        rtf_body(border_first = c("single","dash", "dot","triple", ""),
                 border_last  = c("single","dash", "dot","triple", ""),

                 border_color_top = c("black","gold", "ivory", "blue", "white"),
                 border_color_bottom = c("black","gold", "ivory", "blue", "white"),

                 border_color_first = c("azure","gold", "ivory", "bisque", "white"),
                 border_color_last  = c("red","gold", "ivory", "bisque", "white")) %>%
        rtf_pageby(page_by="Species", new_page = TRUE, pageby_header = TRUE ) %>%
        as_rtf_pageby()

   attr(x, "info") <- NULL

   expect_snapshot_output(x[1])
})

test_that("Test if page_dict attribute is created for tbl", {

  x <- iris %>%
       rtf_body() %>%
       rtf_pageby(page_by="Species", new_page = TRUE, pageby_header = FALSE )

  y <- as_rtf_pageby(x)

  expect_equal(names(attributes(y)), "info")

  expect_output(str(y), "id    : Factor")
  expect_output(str(y), "pageby: logi")
  expect_output(str(y), "nrow  : num")
  expect_output(str(y), "total : num")
  expect_output(str(y), "page  : num")
  expect_output(str(y), "index : int")

})


test_that("Test for more than one page_by var", {
  x <- iris %>%
    mutate(cat = rep(1:5, 30)) %>%
    arrange(Species, cat) %>%
    rtf_page(nrow = 5) %>%
    rtf_body() %>%
    rtf_pageby(page_by=c("Species","cat"), new_page = TRUE, pageby_header = TRUE )

  y <- as_rtf_pageby(x)
  expect_equal(names(attributes(y)), c("names","info"))
  expect_equal(attr(y, "info")[1,2], TRUE)
  expect_equal(attr(y, "info")[1,6], 1)

  expect_output(str(y), "id    : Factor")
  expect_output(str(y), "pageby: logi")
  expect_output(str(y), "nrow  : num")
  expect_output(str(y), "total : num")
  expect_output(str(y), "page  : num")
  expect_output(str(y), "index : int")
})


test_that("Test if new_page is FALSE and group_by is NOT NULL", {
  iris1 <- iris
  iris1$cat <- iris1$Species
  x <- iris1 %>%
    rtf_body(group_by = "cat") %>%
    rtf_pageby(page_by="Species", new_page = FALSE, pageby_header = FALSE )
  y <- as_rtf_pageby(x)

  expect_equal(names(attributes(y)), "info")

  expect_output(str(y), "id    : Factor")
  expect_output(str(y), "pageby: logi")
  expect_output(str(y), "nrow  : num")
  expect_output(str(y), "total : num")
  expect_output(str(y), "page  : num")
  expect_output(str(y), "index : int")

})

test_that("Test whether lines with '-----' were removed correctly", {
  x <- distinct(iris %>% subset(Species != "virginica"), Species, .keep_all = T) %>%
       mutate(Species = ifelse(Species == "setosa", "-----", Species)) %>%

    rtf_colheader("Sepal.Length | Sepal.Width | Petal.Length | Petal.Width",
                  col_rel_width = rep(1, 4)) %>%

    rtf_body(page_by = "Species",
             text_justification = c(rep("c", 4), "l"),
             border_top = c(rep("", 4), "single"),
             border_bottom = c(rep("", 4), "single")) %>%

    rtf_encode()

  expect_snapshot_output(x$body)
})
