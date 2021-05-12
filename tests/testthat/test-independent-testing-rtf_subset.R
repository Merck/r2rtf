test_that("Input check for arguments", {

# check each arguments with different input type
    expect_error(rtf_subset(c('a','b'), row = 1, col = 1))
    expect_error(rtf_subset(matrix(1:9, nrow = 3, ncol = 3), row = 1:2, col = c(1:2)))
    expect_error(rtf_subset(r2rtf_tbl1, row ='1', col = c(1:2)))

})


# an example of data frame with attributes
tbl <- r2rtf_tbl1 %>%
    rtf_colheader(colheader = "Trt|N1|Mean1|N2|Mean2|N3|Mean3|CI", border_left="") %>%
    rtf_body(col_rel_width = c(1,2,3,4,2,2,2,2))

# an example of subsetted data frame
tbl_sub <- tbl %>% rtf_subset(row = 1:2, col = 2:4)

# create two expected matrices
blk <- matrix('', nrow = 2, ncol = 3)
sgl <- matrix('single', nrow = 2, ncol = 3)


test_that("Test whether border/text attributes were passed correctly", {

    expect_equal(attr(tbl_sub, 'border_top'), blk)
    expect_equal(attr(tbl_sub, 'border_left'), sgl)
    expect_equal(attr(tbl_sub, 'border_right'), sgl)
    expect_equal(attr(tbl_sub, 'border_bottom'), blk)
    expect_equal(attr(tbl_sub, 'border_first'), sgl)
    expect_equal(attr(tbl_sub, 'border_last'), sgl)
    expect_equal(attr(tbl_sub, 'border_color_left'), NULL)
    expect_equal(attr(tbl_sub, 'border_color_right'), NULL)
    expect_equal(attr(tbl_sub, 'border_color_first'), NULL)
    expect_equal(attr(tbl_sub, 'text_font'), matrix(1, nrow = 2, ncol = 3))
    expect_equal(attr(tbl_sub, 'text_format'), NULL)
    expect_equal(attr(tbl_sub, 'text_font_size'), matrix(9, nrow = 2, ncol = 3))
    expect_equal(attr(tbl_sub, 'text_justification'), matrix('c', nrow = 2, ncol = 3))
    expect_equal(attr(tbl_sub, 'text_convert'), matrix(TRUE, nrow = 2, ncol = 3))
    expect_equal(attr(tbl_sub, 'cell_nrow'), NULL)

})


test_that("Test whether scale attributes were passed correctly", {

    expect_equal(attr(tbl_sub, 'border_width'), 15)
    expect_equal(attr(tbl_sub, 'cell_height'), .15)
    expect_equal(attr(tbl_sub, 'text_space_before'), 15)
    expect_equal(attr(tbl_sub, 'text_space_after'), 15)
    expect_equal(attr(tbl_sub, 'cell_justification'), 'c')

})


test_that("Test whether other attributes were passed correctly", {

   expect_equal(attr(tbl_sub,"rtf_pageby")['new_page'] , list(new_page = FALSE))
   expect_true(is.null(attr(tbl_sub,"rtf_pageby$by_var")))
   expect_true(is.null(attr(tbl_sub,"rtf_pageby$id")))
   expect_true(attr(tbl_sub,'last_row'))
   expect_true(attr(tbl_sub,'text_hyphenation'))
   expect_false(attr(tbl_sub,'use_color'))
   expect_false(attr(tbl_sub,'text_new_page'))
   expect_equal(attr(tbl_sub,"col_rel_width"), c(2, 3, 4))
   expect_equal(attr(tbl_sub,"text_indent_first"), matrix(0, nrow = 2, ncol = 3))
   expect_equal(attr(tbl_sub,"page")['use_color'], list(use_color = FALSE))
   expect_equal(attr(tbl_sub,"page")['border_last'], list(border_last = 'double'))
   expect_equal(attr(tbl_sub,"page")['col_width'], list(col_width = 6.25))
   expect_equal(attr(tbl_sub,"page")['nrow'], list(nrow = 40))
   expect_equal(attr(tbl_sub,"page")['margin'], list(margin = c(1.25, 1, 1.75, 1.25, 1.75, 1.00625)))
   expect_equal(attr(tbl_sub,"page")['orientation'], list(orientation = 'portrait'))
   expect_equal(attr(tbl_sub,"page")['height'], list(height = 11))
   expect_equal(attr(tbl_sub,"names"), c("N1", "Mean1", "N2"))
   expect_equal(attr(tbl_sub,"class"), c("data.frame", "rtf_text", "rtf_border"))
   expect_equal(attr(tbl_sub,"row.names"), c(1, 2))

})


