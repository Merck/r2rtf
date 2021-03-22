test_that("Case in defalut", {

  x <- iris[1:1,] %>%
       dplyr::select(1) %>%
       rtf_body() %>%
       as_rtf_table() %>%
       strsplit("\n")

  expect_snapshot_output(x[[1]])

})

test_that("Case for border_color_left and border_color_top", {
  x <- iris[1:1,] %>% dplyr::select(1) %>%
        rtf_body(border_color_left='red', border_color_top='blue') %>%
        as_rtf_table() %>%
        strsplit("\n")

  expect_snapshot_output(x[[1]])

})

test_that("Case for having group_by without page_by", {
  x <- iris[1:2, 4:5] %>%
    rtf_body(group_by = "Species") %>%
    as_rtf_table() %>%
    strsplit("\n")

  expect_snapshot_output(x[[1]])

})




