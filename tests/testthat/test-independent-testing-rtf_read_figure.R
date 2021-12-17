library(dplyr)
test_that("Test fig_format attribute", {
  a <- rtf_read_figure(c("fig/fig3.jpeg" ,"fig/fig2.png","fig/fig4.emf"))

  expect_equal(sum(attr(a,"fig_format")==c("jpeg","png","emf")),3)
})

test_that("Test outputs", {
  a <- rtf_read_figure(c("fig/fig3.jpeg" ,"fig/fig2.png","fig/fig4.emf")) %>%
    rtf_figure() %>%
    rtf_encode(doc_type = "figure")

  expect_snapshot_output(a)
})
