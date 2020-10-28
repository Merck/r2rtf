context("Independent testing for rtf_text.R")

#Build Temporary vector for use in testing
teststr <- "The quick brown fox (){}[]$#&%@,.;:=_+-*/"

#Check Temporary dataset attributes
teststratt<-attributes(teststr)

test_that("RTF text default color", {

  #Check no default color assigned for foreground when background color is null

  expect_false(c("cf") %in%
               rtf_text(text = teststr)
               )

  #Check default black color is assigned for foreground when background color is not null

  expect_match(rtf_text(text = teststr,
                        background_color = "white"),
               "cf25"
              )

})

test_that("check for valid input arguments to text", {

  #Check text argument only takes atomic character vector arguments

  testdat <- iris[1:100,]
  expect_warning(rtf_text(text = testdat),
                 "argument is not an atomic vector; coercing"
                 )

})

test_that("check for valid input arguments to font", {

  #Check font argument matches font_type()$type

  expect_error(rtf_text(text = teststr,
                        font = "4"),
               "font %in% font_type$type is not TRUE",
               fixed = TRUE
               )

})

test_that("check for valid input arguments to font_size", {

  #Check font_size argument only takes atomic numeric vector arguments

  expect_error(rtf_text(text = teststr,
                        font_size = "4"),
               "is.numeric(font_size) is not TRUE",
               fixed = TRUE
               )

})

test_that("check for valid input arguments to format", {

  #Check format argument matches font_format()$type

  expect_error(rtf_text(text = teststr,
                        format = "4"),
               "as.vector(format_check) %in% font_format$type is not TRUE",
               fixed = TRUE
               )

})

test_that("check for valid input arguments to color", {

  #Check color argument matches color_table()$color

  expect_error(rtf_text(text = teststr,
                        color = "check"),
               "color %in% col_tb$color is not TRUE",
               fixed = TRUE
               )

})

test_that("check for valid input arguments to background_color", {

  #Check background_color argument matches color_table()$color

  expect_error(rtf_text(text = teststr,
                        background_color = "check"),
               "background_color %in% col_tb$color is not TRUE",
               fixed = TRUE
               )

})

test_that("text font, size and format checks", {

  #Check font

  expect_match(rtf_text(text = teststr,
                        font = 2),
               "f166"
               )

  expect_match(rtf_text(text = teststr,
                        font = 3),
               "f266"
               )

  #Check font_size

  expect_match(rtf_text(text = teststr,
                        font_size = 2),
               "fs4"
               )

  expect_match(rtf_text(text = teststr,
                        font_size = 100),
               "fs200"
               )

  #Check format

  expect_match(rtf_text(text = teststr,
                        format = "b"),
               "\\b"
               )

  expect_match(rtf_text(text = teststr,
                        format = "ib"),
               "\\i\\b"
               )

})

test_that("text color checks", {

  #Check foreground color

  expect_match(rtf_text(text = teststr,
                        color = "red",
                        background_color = "white"),
               "cf553"
               )

  expect_match(rtf_text(text = teststr,
                        color = "yellow4",
                        background_color = "white"),
               "cf657"
               )

  #Check background_color

  expect_match(rtf_text(text = teststr,
                        color = "white",
                        background_color = "darkviolet"),
               "cb116"
               )

  expect_match(rtf_text(text = teststr,
                        color = "white",
                        background_color = "mistyrose"),
               "cb480"
               )

})

