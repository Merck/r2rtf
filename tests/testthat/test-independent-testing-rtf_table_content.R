#Build Temporary dataset for use in testing
testdat <- iris[1:5,]

#Check Temporary dataset attributes
testdatatt<-attributes(testdat)

#Encode Temporary dataset
testdat2 <- rtf_table_content(tbl = testdat,
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


test_that("RTF table content generation", {

  #Check cell text font type encoding

  expect_snapshot_output(testdat2)

})
