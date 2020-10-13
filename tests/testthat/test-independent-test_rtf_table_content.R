context("Independent testing for rtf_table_content.R")

#Build Temporary dataset for use in testing
testdat <- iris[1:100,]

#Check Temporary dataset attributes
testdatatt<-attributes(testdat)

#Encode Temporary dataset
testdat2 <- rtf_table_content(db = testdat,
                              border_left = "single",
                              border_right = "double",
                              border_top = "triple",
                              border_bottom = "dot",
                              border_color_left = "black",
                              border_color_right = "red",
                              border_color_top = "green",
                              border_color_bottom = "gold",
                              border_width = 1440,
                              text_font = 2,
                              text_format = "iub",
                              text_color = "greenyellow",
                              text_justification = "l",
                              text_font_size = 12,
                              text_space_before = 10,
                              text_space_after = 10,
                              text_background_color = "lightgoldenrod",
                              text_convert = matrix(TRUE, nrow(testdat), ncol(testdat)),
                              cell_justification = "r",
                              col_rel_width = c(1,2,3,4,5),
                              col_total_width = 10,
                              cell_height = 2,
                              use_border_bottom = TRUE
)


test_that("RTF table begin and end encoding", {

  #Check table begin encoding

  expect_match(c(testdat2[1,1]) ,
                   "\\\\trowd\\\\trgaph1440\\\\trleft0\\\\trqr")

  #Check table end encoding

  expect_match(c(testdat2[12,100]) ,
               "\\\\intbl\\\\row\\\\pard")

})

test_that("RTF table cell border type encoding", {

  #Check cell border left encoding

  expect_match(testdat2[2,1] ,
               "clbrdrl\\\\brdrs"
               )

  #Check cell border right encoding

  expect_match(testdat2[6,100] ,
               "clbrdrr\\\\brdrdb"
               )

  #Check cell border top encoding

  expect_match(testdat2[2,1] ,
               "clbrdrt\\\\brdrtriple"
               )

  #Check cell border bottom encoding

  expect_match(testdat2[6,100] ,
               "clbrdrb\\\\brdrdot"
               )

})

test_that("RTF table cell border color encoding", {

  #Check cell border left color encoding

  expect_match(testdat2[2,1] ,
               "clbrdrl\\\\brdrs\\\\brdrw1440\\\\brdrcf25"
               )

  #Check cell border right color encoding

  expect_match(testdat2[6,100] ,
               "clbrdrr\\\\brdrdb\\\\brdrw1440\\\\brdrcf553"
               )

  #Check cell border top color encoding

  expect_match(testdat2[2,1] ,
               "clbrdrt\\\\brdrtriple\\\\brdrw1440\\\\brdrcf255"
               )

  #Check cell border bottom color encoding

  expect_match(testdat2[6,100] ,
               "clbrdrb\\\\brdrdot\\\\brdrw1440\\\\brdrcf143"
               )

})

test_that("RTF table cell background color encoding", {

  #Check cell background color encoding

  expect_match(testdat2[2,1] ,
               "clcbpat411"
               )

})

test_that("RTF table cell size encoding", {

  #Check cell size encoding

  expect_match(testdat2[2,1] ,
               "cellx960"
               )

  expect_match(testdat2[3,10] ,
               "cellx2880"
               )

  expect_match(testdat2[4,40],
               "cellx5760"
               )

  expect_match(testdat2[5,75] ,
               "cellx9600"
               )

  expect_match(testdat2[6,100] ,
               "cellx14400"
               )

})

test_that("RTF table cell text justification, alignment encoding", {

  #Check cell text justification encoding

  expect_match(testdat2[1,50] ,
               "\\\\trqr"
               )

  #Check text alignment encoding

  expect_match(testdat2[7,1] ,
               "\\\\ql"
               )

  expect_match(testdat2[8,10] ,
               "\\\\ql"
               )

  expect_match(testdat2[9,40],
               "\\\\ql"
               )

  expect_match(testdat2[10,75] ,
               "\\\\ql"
               )

  expect_match(testdat2[11,100] ,
               "\\\\ql"
               )


})

test_that("RTF table cell text font, size and format encoding", {

  #Check cell text font type encoding

  expect_match(testdat2[7,1] ,
               "\\\\f166"
               )

  expect_match(testdat2[8,10] ,
               "\\\\f166"
               )

  expect_match(testdat2[9,40],
               "\\\\f166"
               )

  expect_match(testdat2[10,75] ,
               "\\\\f166"
               )

  expect_match(testdat2[11,100] ,
               "\\\\f166"
               )

  #Check cell text font size encoding

  expect_match(testdat2[7,1] ,
               "\\\\fs24"
               )

  expect_match(testdat2[8,10] ,
               "\\\\fs24"
               )

  expect_match(testdat2[9,40],
               "\\\\fs24"
               )

  expect_match(testdat2[10,75] ,
               "\\\\fs24"
               )

  expect_match(testdat2[11,100] ,
               "\\\\fs24"
               )

  #Check cell text font format encoding

  expect_match(testdat2[7,1] ,
               "\\\\i\\\\ul\\\\b"
               )

  expect_match(testdat2[8,10] ,
               "\\\\i\\\\ul\\\\b"
               )

  expect_match(testdat2[9,40],
               "\\\\i\\\\ul\\\\b"
               )

  expect_match(testdat2[10,75] ,
               "\\\\i\\\\ul\\\\b"
               )

  expect_match(testdat2[11,100] ,
               "\\\\i\\\\ul\\\\b"
               )

})

test_that("RTF table cell text color encoding", {

  #Check cell text color encoding

  expect_match(testdat2[7,1] ,
               "\\\\cf260"
               )

  expect_match(testdat2[8,10] ,
               "\\\\cf260"
               )

  expect_match(testdat2[9,40],
               "\\\\cf260"
               )

  expect_match(testdat2[10,75] ,
               "\\\\cf260"
               )

  expect_match(testdat2[11,100] ,
               "\\\\cf260"
               )

})
