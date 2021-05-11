library(dplyr)

test_that("Test case when page_by is NULL and new_page is TRUE",{

  expect_error(iris[1:2,] %>%
                 rtf_body()  %>%
                 rtf_pageby(page_by=NULL, new_page=TRUE, pageby_header = TRUE))

})

test_that("Test case when page_by is not NULL and data is sorted by the page_by variable",{

  expect_output(str(iris[1:2,] %>%
                      arrange(Petal.Length) %>%
                      rtf_body() %>%
                      rtf_pageby(page_by=c("Petal.Length"), new_page=TRUE,
                                 pageby_header = TRUE)), "2 obs")

  a <- iris[1:2,] %>%
    arrange(Sepal.Width) %>%
    rtf_body() %>%
    rtf_pageby(page_by=c("Sepal.Width"), new_page=TRUE,
               pageby_header = TRUE)
  expect_equal(attributes(a)$rtf_pageby$by_var,"Sepal.Width")
})

test_that("Test if page_by attributes are assigned correctly to tbl",{

  x <-iris[1:2,] %>%
    dplyr::arrange(Petal.Length) %>%
    rtf_body() %>%
    rtf_pageby(page_by=c("Petal.Length"), new_page=TRUE, pageby_header = TRUE)

  expect_true(attributes(x)$rtf_pageby$new_page)
  expect_equal(attributes(x)$rtf_pageby$by_var,"Petal.Length")
  expect_equal(attributes(x)$rtf_pageby$id,factor(x$Petal.Length))
  expect_true(attributes(x)$rtf_pageby$pageby_header)

  y <-iris[1:2,] %>%
    rtf_body() %>%
    rtf_pageby(page_by=NULL, new_page=FALSE, pageby_header = TRUE)

  expect_false(attributes(y)$rtf_pageby$new_page)
  expect_equal(attributes(y)$rtf_pageby$by_var,NULL)
  expect_equal(attributes(y)$rtf_pageby$id,NULL)


})


test_that("Test if there are more than one page_by variables",{

  x <-iris[1:60,] %>%
    dplyr::arrange(Petal.Width, Petal.Length) %>%
    rtf_body() %>%
    rtf_pageby(page_by=c("Petal.Width", "Petal.Length"), new_page=TRUE, pageby_header = TRUE)

  expect_true(attributes(x)$rtf_pageby$new_page)
  expect_equal(attributes(x)$rtf_pageby$by_var, c("Petal.Width", "Petal.Length"))
  expect_true(attributes(x)$rtf_pageby$pageby_header)

})

# add tests for new features
test_that("Test case when pageby_row='first_row'", {
  x <- iris[c(1:4, 51:54), 3:5] %>%
    mutate(s2 = paste0(Species, 1:2), s3 = s2) %>%
    arrange(Species, s2)%>%
    rtf_colheader("patelLength|patelWidth|s3") %>%
    rtf_body(subline_by = "Species") %>%
    rtf_pageby(page_by = 's2',
      pageby_row = 'first_row')

  expect_false(attributes(x)$rtf_pageby$new_page)
  expect_equal(attributes(x)$rtf_pageby$by_var, 's2')
  expect_true(attributes(x)$rtf_pageby$pageby_header)
  expect_equal(attributes(x)$rtf_pageby$pageby_row,'first_row')

})


test_that("Test case when subline is not NULL", {
  x <- iris[c(1:4, 51:54), 3:5] %>%
    mutate(s2 = paste0(Species, 1:2), s3 = s2) %>%
    arrange(Species, s2)%>%
    rtf_colheader("patelLength|patelWidth|s3") %>%
    rtf_body(subline_by = "Species") %>%
    rtf_pageby(page_by = 's2',
               pageby_row = 'first_row')

  expect_equal(data.frame(attributes(x)$rtf_by_subline_row), data.frame(tibble(x = unique(x$Species))))
  expect_equal(attributes(x)$rtf_by_subline$by_var,'Species')
  expect_equal(attributes(x)$rtf_by_subline$new_page,TRUE)

})
