context("Independent testing for check_args.R")

test_that("Case when arg input is NULL", {

  # Check when arg input is NULL
  expect_identical(check_args(NULL), NULL)

})

test_that("Case when type input is not NULL", {

  # Check when arg is character vector
  expect_identical(check_args(c("a","b","c"), type = c("character")), NULL)

  # Check when arg is numeric vector
  expect_identical(check_args(c(1,2,3), type = c("numeric")), NULL)

  # Check when arg is integer vector
  expect_identical(check_args(c(1L,2L,3L), type = c("integer")), NULL)

   # Check when arg is character matrix
  expect_identical(check_args(matrix(c("a","b","c","d"), nrow = 2, ncol = 2),
                              type = c("character")),
                   NULL)

  # Check when arg is integer matrix
  expect_identical(check_args(matrix(1:9, nrow = 3, ncol = 3),
                              type = c("integer")),
                   NULL)

  # Check when arg is data frame
  expect_identical(check_args(iris[1:10,],
                              type = c("data.frame")),
                   NULL)

})

test_that("Case when length input is not NULL", {

  # Check when arg is character vector
  expect_identical(check_args(c("a","b","c"),
                              type = c("character"),
                              length = 3),
                   NULL)

  # Check when arg is numeric vector
  expect_identical(check_args(c(1,2,3,4,5),
                              type = c("numeric"),
                              length = 5),
                   NULL)

  # Check when arg is integer vector
  expect_identical(check_args(c(1L,2L),
                              type = c("integer"),
                              length = 2),
                   NULL)

  # Check when arg is character matrix
  expect_identical(check_args(matrix(c("a","b","c","d"), nrow = 2, ncol = 2),
                              type = c("character"),
                              length = 4),
                   NULL)

  # Check when arg is integer matrix
  expect_identical(check_args(matrix(1:9, nrow = 3, ncol = 3),
                              type = c("integer"),
                              length = 9),
                   NULL)

  # Check when arg is data frame
  expect_identical(check_args(iris[1:10,1:2],
                              type = c("data.frame"),
                              length = 2),
                   NULL)

})

test_that("Case when dim input is not NULL", {

  # Check when arg is data frame
  expect_identical(check_args(iris[1:10,1:2],
                              type = c("data.frame"),
                              dim = c(10,2)),
                   NULL)

})

test_that("Test if correct message note is provided for differenct cases", {

  # Check when no input is given
  expect_error(check_args(),
               'argument "arg" is missing, with no default')

  # Check when arg and type do not match
  expect_error(check_args(c(1,2,3), type = c("character")),
               'The argument type did not match: character')

  # Check when arg length and length input do not match
  expect_error(check_args(c(1,2,3),
                          type = c("numeric"),
                          length = 2),
               'The argument length is not 2')

  # Check when arg dimensions and dim input do not match
  expect_error(check_args(iris[1:10,1:2],
                          type = c("data.frame"),
                          dim = c(1,2)),
               'The argument dimension is not 1,2')

})


