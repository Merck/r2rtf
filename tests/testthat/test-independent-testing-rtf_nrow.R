# create testing example
svg(tempfile("tmp.svg"))

font   <- 2:3
format <- matrix(c("", "i", 'b', 'ib'), nrow = 4, ncol = 2, byrow = FALSE)
size   <- matrix(9:9, nrow = 4, ncol = 2, byrow = FALSE)
indent_first <- matrix(c(0,  80), nrow = 4, ncol = 2, byrow = FALSE)
indent_left  <- matrix(c(0, 300), nrow = 4, ncol = 2, byrow = FALSE)

tbl1 <- matrix( "RStudio is an integrated development environment for R, a programming language for statistical computing and graphics.", nrow = 2, ncol = 2 )
tbl2 <- matrix( "RStudio", nrow = 2, ncol = 2 )
tbl  <- rbind(tbl1, tbl2)

tbl  <- data.frame(tbl) %>%
  rtf_page(orientation = "portrait") %>%
  rtf_title(title = c('title here',
                      'title 2 here',
                      'here is a very very very very very long title 3 that should be broken to two lines if calculated correctly')) %>%
  rtf_subline(text = c('subline 1',
                       'this is a very long subline that should be broken to 2 lines if calculated correctly by rtf_nrow function')) %>%
  rtf_colheader(colheader = "a long column 1 header to test line break|col2",
                col_rel_width = c(1, 5)) %>%
  rtf_footnote(footnote = c('footer1',
                            'this is a very very very very very very very long footer2 that should be broken to 2 lines if calculated correctly by rtf_nrow function')) %>%
  rtf_source(source = c('source here','source 2')) %>%
  rtf_body(text_justification = "l",
           col_rel_width = c(1, 5),
           text_font = font,
           text_font_size = size,
           text_format = format,
           text_indent_first = indent_first,
           text_indent_left = indent_left)
#tbl %>% rtf_encode() %>% write_rtf("tmp.rtf")


# rtf_nrow
tbl1 <- rtf_nrow(tbl)
bodys    <- attr(tbl1, "rtf_nrow")
titles   <- attr(tbl1, "rtf_nrow_meta")$title
sublines <- attr(tbl1, "rtf_nrow_meta")$subline
headers  <- attr(tbl1, "rtf_nrow_meta")$col_header
footers  <- attr(tbl1, "rtf_nrow_meta")$footnote
sources  <- attr(tbl1, "rtf_nrow_meta")$source


# nrow_paragraph
nrowpara_title   <- nrow_paragraph(attr(tbl,'rtf_title'), size=6.25, padding = 0)
nrowpara_subline <- nrow_paragraph(attr(tbl,'rtf_subline'), size=6.25, padding = 0)
nrowpara_footer  <- nrow_paragraph(attr(tbl,'rtf_footnote'), size=6.25, padding = 0)
nrowpara_source  <- nrow_paragraph(attr(tbl,'rtf_source'), size=6.25, padding = 0)


# nrow_table
nrowtable <- nrow_table(tbl, size = 6.25)
nrowtablefooter <- nrow_table(attr(tbl, 'rtf_footnote'), size = 6.25)
nrowtablesource <- nrow_table(attr(tbl, 'rtf_source'), size = 6.25)


# rnow_table cell size calculation
pad <-  (attr(tbl, "text_indent_left") + attr(tbl, "text_indent_right")) / 1440 + 0.2
rel_width <- attr(tbl, "col_rel_width")
width <- 6.25 *  rel_width/ sum(rel_width)
cellsize <- matrix(width, nrow = nrow(tbl), ncol = ncol(tbl), byrow = TRUE) - pad


# rtf_nline_vector example
nline_vector <- rtf_nline_vector(text = c('title 1', "this is a sentence for title 2"),
                             strwidth = c(strwidth("title 1", units = 'inches'),
                                          strwidth("this is a sentence for title 2", units = 'inches')),
                                 size = 0.5)


# rtf_nline_matrix example
mtx <- matrix("this is a sentence for title 2", nrow = 2, ncol = 2)
mtxstrwidth <- matrix(2, nrow = 2, ncol = 2)
mtxsize <- matrix(5:8/10, nrow = 2)
nline_matrix <- rtf_nline_matrix(text = mtx, strwidth = mtxstrwidth, size = mtxsize)


# pageby example

iris[1:2, 1] <- 'a long string to test line breaks'

irs <- iris[1:55, ] %>%
   rtf_title(title = 'pageby example') %>%
   rtf_body(page_by = 'Species', new_page = TRUE)
# irs %>% rtf_encode() %>% write_rtf("tmp.rtf")

irs1 <- rtf_nrow(irs)
irsbodys <- attr(irs1, "rtf_nrow")
irspagebybodys <- attr(attr(irs1, "rtf_pageby_table"), "rtf_nrow")
irspagebyrows  <- attr(attr(irs1, "rtf_pageby_row")$Species, "rtf_nrow")



test_that("test if rtf_nline_vector() return to correct numbers", {

    # line for first vector
    expect_equal(nline_vector[1], 1)

    # lines for second vector
    expect_equal(nline_vector[2], 6)

 })


test_that("test if rtf_nline_matrix() return to correct numbers", {

   # maximum lines for first row
   expect_equal(nline_matrix[1], 6)

   # maximum lines for second row
   expect_equal(nline_matrix[2], 5)

})


test_that("test if nrow_paragraph() return to correct number of titles when there are 3 title lines", {

   # title lines through rtf_nrow
   expect_equal(titles, 4)

   # subline lines through nrow_paragraph
   expect_equal(sum(nrowpara_title), 4)

})


test_that("test if nrow_paragraph() return to correct number of sublines", {

   # subline lines through rtf_nrow
   expect_equal(sublines, 3)

   # subline lines through nrow_paragraph
   expect_equal(sum(nrowpara_subline), 3)

})


test_that("test for nrow_table() when as_table attr is FALSE",{

   expect_equal(sum(nrowpara_source), sources)

})


test_that("test for nrow_table() when as_table attr is TRUE",{

   expect_equal(sum(nrowtablefooter), footers)

})


test_that("test for nrow_table() if actual column size are calculated correctly",{

   # first cell size calculated within nrow_table
   expect_equal(round(cellsize[1, 1], 5), round(6.25*1/6 - 0.2, 5) )

   if(interactive ()){
      # first cell returned lines through nrow_table
      expect_true(nrowtable[1] >= 10 )

      # first cell returned lines through rtf_nrow
      expect_true(bodys[1] >= 10 )
   }

})


test_that("test for rtf-nrow() if 'rtf-nrow' attributes are added correctly for pageby table",{

   expect_equal(irspagebybodys[1], 2)

})


test_that("test for rtf-nrow() if 'rtf-nrow' attributes are added correctly for pageby_row table",{

   expect_equal(irspagebyrows[1], 1)

})

dev.off()

