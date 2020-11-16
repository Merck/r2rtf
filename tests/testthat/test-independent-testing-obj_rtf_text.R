test_that("Check argument type, test if error message will show correctly", {
  expect_error(obj_rtf_text(text = 1),
               "The argument type did not match: character")
  expect_error(obj_rtf_text(text="testing",text_font = "1"),
               "The argument type did not match: integer/numeric")
  expect_error(obj_rtf_text(text="testing",text_format = 1),
               "The argument type did not match: character")
  expect_error(obj_rtf_text(text="testing",text_font_size = "1"),
               "The argument type did not match: integer/numeric")
  expect_error(obj_rtf_text(text="testing",text_color = 1),
               "The argument type did not match: character")
  expect_error(obj_rtf_text(text="testing",text_background_color = 1),
               "The argument type did not match: character")
  expect_error(obj_rtf_text(text="testing",text_justification = 1),
               "The argument type did not match: character")
  expect_error(obj_rtf_text(text="testing",text_space_before = "1"),
               "The argument type did not match: integer/numeric")
  expect_error(obj_rtf_text(text="testing",text_space_after = "1"),
               "The argument type did not match: integer/numeric")
  expect_error(obj_rtf_text(text="testing",text_new_page = "1"),
               "The argument type did not match: logical")
  expect_error(obj_rtf_text(text="testing",text_hyphenation = "1"),
               "The argument type did not match: logical")
  expect_error(obj_rtf_text(text="testing",text_convert = "1"),
               "The argument type did not match: logical")

})

test_that("Check argument values, test if error message will show correctly", {
  expect_error(obj_rtf_text(text="testing",text_font = 20),)
  expect_error(obj_rtf_text(text="testing",text_format = "aa"),)
  expect_error(obj_rtf_text(text="testing",text_font_size = -1),)
  expect_error(obj_rtf_text(text="testing",text_color = 'redd'),)
  expect_error(obj_rtf_text(text="testing",text_background_color = "redd"),)
  expect_error(obj_rtf_text(text="testing",text_justification = "left"),)
  # expect_error(obj_rtf_text(text="testing",text_space_before = -1),)
  # expect_error(obj_rtf_text(text="testing",text_space_after = -1),)
  # expect_error(obj_rtf_text(text="testing",text_new_page = "1"),)
  # expect_error(obj_rtf_text(text="testing",text_hyphenation = "1"),)
  # expect_error(obj_rtf_text(text="testing",text_convert = "1"),)
  #
})

test_that("Test if attributes are assigned correctly", {
  a <- obj_rtf_text( text="testing"
                     ,text_font = 1
                     ,text_format = "b"
                     ,text_font_size = 16
                     ,text_color = "red"
                     ,text_background_color = "red"
                     ,text_justification = "l"
                     ,text_indent_first = 0
                     ,text_indent_left = 0
                     ,text_indent_right = 0
                     ,text_space = 1
                     ,text_space_before = 15
                     ,text_space_after = 15
                     ,text_new_page = FALSE
                     ,text_hyphenation = TRUE
                     ,text_convert = TRUE
  )
  expect_equal(attr(a,"text_font")[1], 1)
  expect_equal(attr(a,"text_format")[1], "b")
  expect_equal(attr(a,"text_font_size")[1], 16)
  expect_equal(attr(a,"text_color")[1], "red")
  expect_equal(attr(a,"text_background_color")[1], "red")
  expect_equal(attr(a,"text_justification")[1], "l")
  expect_equal(attr(a,"text_indent_first")[1], 0)
  expect_equal(attr(a,"text_indent_left")[1], 0)
  expect_equal(attr(a,"text_indent_right")[1], 0)
  expect_equal(attr(a,"text_space")[1], 1)
  expect_equal(attr(a,"text_space_before")[1], 15)
  expect_equal(attr(a,"text_space_after")[1], 15)
  expect_equal(attr(a,"text_new_page")[1], FALSE)
  expect_equal(attr(a,"text_hyphenation")[1], TRUE)
  expect_equal(attr(a,"text_convert")[1], TRUE)

})

test_that("Test if color_used is derived correctly", {
  a <- obj_rtf_text( text="testing"
                     ,text_font = 1
                     ,text_format = "b"
                     ,text_font_size = 16
                     ,text_color = "red"
                     ,text_background_color = "red"
                     ,text_justification = "l"
                     ,text_indent_first = 0
                     ,text_indent_left = 0
                     ,text_indent_right = 0
                     ,text_space = 1
                     ,text_space_before = 15
                     ,text_space_after = 15
                     ,text_new_page = FALSE
                     ,text_hyphenation = TRUE
                     ,text_convert = TRUE
  )
  expect_equal(attr(a,"use_color")[1], TRUE)

  a <- obj_rtf_text( text="testing"
                     ,text_font = 1
                     ,text_format = "b"
                     ,text_font_size = 16
                     ,text_color = "black"
                     ,text_background_color = "black"
                     ,text_justification = "l"
                     ,text_indent_first = 0
                     ,text_indent_left = 0
                     ,text_indent_right = 0
                     ,text_space = 1
                     ,text_space_before = 15
                     ,text_space_after = 15
                     ,text_new_page = FALSE
                     ,text_hyphenation = TRUE
                     ,text_convert = TRUE
  )
  expect_equal(attr(a,"use_color")[1], FALSE)
})
