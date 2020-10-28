context("Development testing for match_arg.R")

test_that("Case when choices is missing", {
  expect_error(match_arg(arg='', choices = ))
})

test_that("Case when arg is NULL", {
  expect_equal(match_arg(NULL, c("a", "b", "c")), "a")
})

test_that("Case when arg can not be characterized as choices", {
  expect_error(match_arg(1, c("a", "b", "c")))
})

test_that("Case when arg is numeric", {
  expect_equal(match_arg(1, c("1", "2", "3")), "1")
  expect_equal(match_arg(1, c(1, 2, 3)), "1")
})

test_that("Case when several.ok is FALSE", {
  # if arg is same as choices
  expect_equal(match_arg(c("a", "b"), c("a", "b"), several.ok = FALSE), "a")
  # if arg length great than 1 but not same as choices
  expect_error(match_arg(c("a", "b"), c("a", "b", "c"), several.ok = FALSE))
})

test_that("Case when arg is in choices", {
  # if arg equals to ''
  expect_equal(match_arg('', choices = c('', 'a', 'b', 'c')), '')
  # if arg NOT equals to ''
  expect_equal(match_arg('a', choices = c('', 'a', 'b', 'c')), 'a')
  # if arg has more than one match when several.ok is FALSE
  expect_error(match_arg(c("ab", "ab"), choices = c("abc", "ab"), several.ok = FALSE))
})

test_that("Case when arg is Not in choices", {
  expect_error(match_arg('d', choices = c('', 'a', 'b', 'c')))
})
