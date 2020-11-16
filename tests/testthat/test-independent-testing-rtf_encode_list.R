test_that("Test case when footnote and source display in all pages", {
  m1 <- iris[1:2,] %>%
    rtf_body (as_colheader = TRUE, border_color_left = "red") %>% rtf_title("title")
  m2 <- iris[3:4,] %>%
    rtf_body (as_colheader = TRUE)
  m3 <- iris[5:6,] %>%
    rtf_body (as_colheader = TRUE) %>% rtf_source("source")
  m <- list(m1, m2, m3)
  m_out <- m %>%
    rtf_encode_list(page_footnote = "all", page_source = "all")

  expect_snapshot_output(m_out)
})
