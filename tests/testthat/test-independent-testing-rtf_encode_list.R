test_that("Test case when footnote and source display in all pages", {
  m1 <- iris[1:2,] %>%
    rtf_body (as_colheader = TRUE, border_color_left = "red") %>%
    rtf_title("title")  %>%
    rtf_source("source")
  m2 <- iris[3:4,] %>%
    rtf_body (as_colheader = TRUE)
  m3 <- iris[5:6,] %>%
    rtf_body (as_colheader = TRUE)
  m <- list(m1, m2, m3)

  attr(m1, "page")$page_title <- "all"
  attr(m1, "page")$page_footnote <- "all"
  attr(m1, "page")$page_source <- "all"

  attr(m2, "page")$page_title <- "all"
  attr(m2, "page")$page_footnote <- "all"
  attr(m2, "page")$page_source <- "all"

  attr(m3, "page")$page_title <- "all"
  attr(m3, "page")$page_footnote <- "all"
  attr(m3, "page")$page_source <- "all"

  m_out <- m %>%
    rtf_encode_list()

  expect_snapshot_output(m_out)
})
