#Build Temporary dataset for use in testing
testdat <- iris[1:100,]

test_that("Check argument type, test if error message will show correctly", {
  expect_error(obj_rtf_border(tbl = testdat,border_left = 1),
               "The argument type did not match: character")
  expect_error(obj_rtf_border(tbl = testdat,border_right = 1),
               "The argument type did not match: character")
  expect_error(obj_rtf_border(tbl = testdat,border_top = 1),
               "The argument type did not match: character")
  expect_error(obj_rtf_border(tbl = testdat,border_bottom = 1),
               "The argument type did not match: character")
  expect_error(obj_rtf_border(tbl = testdat,border_color_left = 1),
               "The argument type did not match: character")
  expect_error(obj_rtf_border(tbl = testdat,border_color_right = 1),
               "The argument type did not match: character")
  expect_error(obj_rtf_border(tbl = testdat,border_color_top = 1),
               "The argument type did not match: character")
  expect_error(obj_rtf_border(tbl = testdat,border_color_bottom = 1),
               "The argument type did not match: character")
  expect_error(obj_rtf_border(tbl = testdat,cell_justification = 1),
               "The argument type did not match: character")
  expect_error(obj_rtf_border(tbl = testdat,border_width = "1"),
               "The argument type did not match: integer/numeric")
  expect_error(obj_rtf_border(tbl = testdat,cell_height = "1"),
               "The argument type did not match: integer/numeric")
  expect_error(obj_rtf_border(tbl = testdat,cell_nrow = "1"),
               "The argument type did not match: integer/numeric")
})

test_that("Check argument values, test if error message will show correctly", {
  expect_error(obj_rtf_border(tbl = testdat,border_left = "testing"))
  expect_error(obj_rtf_border(tbl = testdat,border_right = "testing"))
  expect_error(obj_rtf_border(tbl = testdat,border_top = "testing"))
  expect_error(obj_rtf_border(tbl = testdat,border_bottom = "testing"))
  expect_error(obj_rtf_border(tbl = testdat,border_color_left = "redd"))
  expect_error(obj_rtf_border(tbl = testdat,border_color_right = 'redd'))
  expect_error(obj_rtf_border(tbl = testdat,border_color_top = 'redd'))
  expect_error(obj_rtf_border(tbl = testdat,border_color_bottom = "redd"))
  expect_error(obj_rtf_border(tbl = testdat,cell_justification = "leftt"))
  expect_error(obj_rtf_border(tbl = testdat,border_width = -1))
  expect_error(obj_rtf_border(tbl = testdat,border_color_top = NULL,
                              border_color_first = 'red' ))
  expect_error(obj_rtf_border(tbl = testdat,border_color_bottom = NULL,
                              border_color_last = 'red' ))
})

test_that("Test if attributes are assigned correctly", {
  a <- obj_rtf_border(tbl = testdat,border_left = "single"
                      ,border_right = "single"
                      ,border_top = "single"
                      ,border_bottom = "single"
                      ,border_color_left = "red"
                      ,border_color_right = "red"
                      ,border_color_top = "red"
                      ,border_color_bottom = "red"
                      ,border_color_first = "red"
                      ,border_color_last = "red"
                      ,cell_justification = "l"
                      ,border_width = 5
                      ,cell_height = 5
                      ,cell_nrow = 5
  )
  expect_equal(attr(a,"border_left")[1], "single")
  expect_equal(attr(a,"border_right")[1], "single")
  expect_equal(attr(a,"border_top")[1], "single")
  expect_equal(attr(a,"border_bottom")[1], "single")
  expect_equal(attr(a,"border_color_left")[1], "red")
  expect_equal(attr(a,"border_color_right")[1], "red")
  expect_equal(attr(a,"border_color_top")[1], "red")
  expect_equal(attr(a,"border_color_bottom")[1], "red")
  expect_equal(attr(a,"border_color_first")[1], "red")
  expect_equal(attr(a,"border_color_last")[1], "red")
  expect_equal(attr(a,"cell_justification")[1], "l")
  expect_equal(attr(a,"border_width")[1], 5)
  expect_equal(attr(a,"border_width")[1], 5)
  expect_equal(attr(a,"border_width")[1], 5)

})

test_that("Test if color_used is derived correctly", {
  a <- obj_rtf_border(tbl = testdat,border_left = "single"
                      ,border_right = "single"
                      ,border_top = "single"
                      ,border_bottom = "single"
                      ,border_color_left = "red"
                      ,border_color_right = "red"
                      ,border_color_top = "red"
                      ,border_color_bottom = "red"
                      ,border_color_first = "red"
                      ,border_color_last = "red"
                      ,cell_justification = "l"
                      ,border_width = 5
                      ,cell_height = 5
                      ,cell_nrow = 5
  )
  expect_equal(attr(a,"use_color")[1], TRUE)

  a <- obj_rtf_border(tbl = testdat,border_left = "single"
                      ,border_right = "single"
                      ,border_top = "single"
                      ,border_bottom = "single"
                      ,border_color_left = "black"
                      ,border_color_right = "black"
                      ,border_color_top = "black"
                      ,border_color_bottom = "black"
                      ,border_color_first = "black"
                      ,border_color_last = "black"
                      ,cell_justification = "l"
                      ,border_width = 5
                      ,cell_height = 5
                      ,cell_nrow = 5
  )
  expect_equal(attr(a,"use_color")[1], FALSE)
})

test_that("Check transfer vector to matrix by row", {
  expect_error(obj_rtf_border(tbl =  ,border_left = "testing")
  )
})
