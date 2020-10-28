context("Independent testing for set_margin.R")

test_that("margin type: csr, portrait", {
  expect_equal(set_margin("csr", "portrait"), c(1.25, 1.00, 1.50, 1.00, 0.50, 0.50))
})

test_that("margin type: csr, landscape", {
  expect_equal(set_margin("csr", "landscape"), c(0.500000, 0.500000, 1.279861, 1.250000, 1.250000, 1.000000), tolerance = 0.00001)
})

test_that("margin type: wma, portrait", {
  expect_equal(set_margin("wma", "portrait"), c(1.25000, 1.00000, 1.75000, 1.25000, 1.75000, 1.00625))
})

test_that("margin type: wma, landscape", {
  expect_equal(set_margin("wma", "landscape"), c(0.50, 0.50, 2.00, 1.25, 1.25, 1.25))
})

test_that("margin type: wmm, portrait", {
  expect_equal(set_margin("wmm", "portrait"), c(1.25000, 1.00000, 1.00000, 1.00000, 1.75000, 1.00625))
})

test_that("margin type: wmm, landscape", {
  expect_equal(set_margin("wmm", "landscape"), c(0.50, 0.50, 1.25, 1.00, 1.25, 1.25))
})

test_that("margin type: narrow, portrait", {
  expect_equal(set_margin("narrow", "portrait"), c(0.5, 0.5, 0.5, 0.5, 0.5, 0.5))
})

test_that("margin type: narrow, landscape", {
  expect_equal(set_margin("narrow", "landscape"), c(0.5, 0.5, 0.5, 0.5, 0.5, 0.5))
})

test_that("doctype not in value list", {
  expect_error(set_margin("csR", "landscape"))
})

test_that("orientation not in value list", {
  expect_error(set_margin("csr", "landscapes"))
})
