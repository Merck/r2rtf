context("Independent testing for rtf_pageby.R")

library(dplyr)

test_that("Test case when page_by is NULL and new_page is TRUE",{

  expect_error(iris[1:2,] %>%
                 rtf_body()  %>%
                 rtf_pageby(page_by=NULL, new_page=TRUE, pageby_header = TRUE))

})

test_that("Test case when page_by is not NULL but data is not sorted by the page_by variable",{


  expect_error(iris %>%
                 rtf_body() %>%
                 rtf_pageby(page_by=c("Petal.Length"), new_page=TRUE, pageby_header = TRUE))
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
