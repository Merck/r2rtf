context("Independent testing for footnote_source_space")

tbl.p <- head(iris) %>% rtf_footnote(text_indent_left = 1) %>% rtf_page(orientation = "portrait")
tbl.l <- head(iris) %>% rtf_footnote(text_indent_left = 1) %>% rtf_page(orientation = "landscape")

test_that("space adjust when orientation is portrait", {
  adj.space.p<-round((round(attr(tbl.p, "page")$width*1440)
                      -round(attr(tbl.p, "page")$margin[1]*1440)
                      -round(attr(tbl.p, "page")$margin[2]*1440)
                      -round(attr(tbl.p, "page")$col_width*1440))/2)
  expect_equal(footnote_source_space(tbl.p), adj.space.p)
})

test_that("space adjust when orientation is landscape", {
  adj.space.l<-round((round(attr(tbl.l, "page")$width*1440)
                      -round(attr(tbl.l, "page")$margin[1]*1440)
                      -round(attr(tbl.l, "page")$margin[2]*1440)
                      -round(attr(tbl.l, "page")$col_width*1440))/2)
  expect_equal(footnote_source_space(tbl.l), adj.space.l)
})

