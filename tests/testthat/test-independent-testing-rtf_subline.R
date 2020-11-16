test_that("test if page attributes are assigned correctly", {

  a <- head(iris) %>% rtf_subline(text="sublinetest")

  expect_equal(attributes(a)$page$width, 8.5)
  expect_equal(attributes(a)$page$height, 11)
  expect_equal(attributes(a)$page$orientation, "portrait")
  expect_equal(attributes(a)$page$border_first, "double")
  expect_equal(attributes(a)$page$border_last, "double")
  expect_false(attributes(a)$page$use_color)

})

test_that("check justification when 'l' and 'r' ", {

  a <- head(iris) %>% rtf_subline(text="sublinetest")
  b <- head(iris) %>% rtf_subline(text="sublinetest", text_justification="l")
  c <- head(iris) %>% rtf_subline(text="sublinetest", text_justification="r")

  expect_equal(attributes(attributes(a)$rtf_subline)$text_justification, "l")
  expect_equal(attributes(attributes(b)$rtf_subline)$text_justification, "l")
  expect_equal(attributes(attributes(c)$rtf_subline)$text_justification, "r")

})


test_that("input argument checks", {

   expect_error(iris %>% rtf_subline())
   expect_error(iris %>% rtf_subline(text="sublinetest", text_font = "1" ))
   expect_error(iris %>% rtf_subline(text="sublinetest", text_format = 12 ))
   expect_error(iris %>% rtf_subline(text="sublinetest", text_font_size = "9" ))
   expect_error(iris %>% rtf_subline(text="sublinetest", text_justification = "t" ))
   expect_error(iris %>% rtf_subline(text="sublinetest", text_convert = "TRUE" ))

})


test_that("check if use_color attribute is assigned correctly", {

  a <- head(iris) %>% rtf_subline(text="sublinetest", text_color="blue")
  b <- head(iris) %>% rtf_subline(text="sublinetest", text_background_color="green")
  c <- head(iris) %>% rtf_subline(text="sublinetest")

  expect_true(attributes(a)$page$use_color)
  expect_true(attributes(b)$page$use_color)
  expect_false(attributes(c)$page$use_color)

})
