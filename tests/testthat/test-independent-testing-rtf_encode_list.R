test_that("Test case when footnote and source display in all pages", {
  m1 <- iris[1:2, ] %>%
    rtf_body(as_colheader = TRUE, border_color_left = "red") %>%
    rtf_title("title") %>%
    rtf_source("source")
  m2 <- iris[3:4, ] %>%
    rtf_body(as_colheader = TRUE)
  m3 <- iris[5:6, ] %>%
    rtf_body(as_colheader = TRUE)
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

test_that("Test case when page width, height, or orientation are not consistent", {
  m1 <- iris[1:2, ] %>%
    rtf_body()

  m2 <- iris[3:4, ] %>%
    rtf_page(width = 9) %>%
    rtf_body()

  m3 <- iris[3:4, ] %>%
    rtf_page(height = 10) %>%
    rtf_body()

  m4 <- iris[3:4, ] %>%
    rtf_page(orientation = "landscape") %>%
    rtf_body()

  width_diff <- list(m1, m2)
  height_diff <- list(m1, m3)
  orientation_diff <- list(m1, m4)

  expect_error(rtf_encode_list(width_diff))
  expect_error(rtf_encode_list(height_diff))
  expect_error(rtf_encode_list(orientation_diff))
})


test_that("Test case when footnote location or source location are not consistent, page_footnote or page_source != 'last', length of list == 1", {
  m1 <- iris[1:2, ] %>%
    rtf_footnote("footer 1") %>%
    rtf_body()

  attr(m1, "page")$page_footnote <- "all"

  m2 <- iris[3:4, ] %>%
    rtf_body()

  m3 <- iris[3:4, ] %>%
    rtf_source("source") %>%
    rtf_body()

  attr(m3, "page")$page_source <- "all"

  m4 <- iris[3:4, ] %>%
    rtf_body()

  attr(m4, "page")$page_footnote <- "all"

  m5 <- iris[3:4, ] %>%
    rtf_source("source") %>%
    rtf_body()

  attr(m5, "page")$page_source <- "all"

  footnote_diff <- list(m1, m2)
  source_diff <- list(m2, m3)
  footnote_all <- list(m1, m4)
  source_all <- list(m3, m5)
  onelist <- list(m2)

  expect_error(rtf_encode_list(footnote_diff))
  expect_error(rtf_encode_list(source_diff))
  expect_error(rtf_encode_list(footnote_all))
  expect_error(rtf_encode_list(source_all))
  expect_error(rtf_encode_list(onelist))
})


test_that("Test case when having multiple footnotes or sources", {
  m1 <- iris[1:2, ] %>%
    rtf_footnote("footer 1") %>%
    rtf_source("source 1") %>%
    rtf_body()

  m2 <- iris[3:4, ] %>%
    rtf_footnote("footer 2") %>%
    rtf_body()

  m3 <- iris[3:4, ] %>%
    rtf_source("source 2") %>%
    rtf_body()

  footnote_multi <- list(m1, m2)
  source_multi <- list(m1, m3)

  expect_message(rtf_encode_list(footnote_multi), "Only rtf_footnote in first item is used")
  expect_message(rtf_encode_list(source_multi), "Only rtf_source in first item is used")
})


test_that("Test nrow is consistent with first list", {
  m1 <- iris %>%
    rtf_body()

  m2 <- iris %>%
    rtf_page(
      nrow = 10,
      border_color_first = "red",
      border_color_last = "red"
    ) %>%
    rtf_body()

  m3 <- iris %>%
    rtf_body()

  tbl <- list(m1, m2, m3)

  n <- length(tbl)

  tbl[2:n] <- lapply(tbl[2:n], function(x) {
    attr(x, "page")$nrow <- attr(tbl[[1]], "page")$nrow
    x
  })

  attr(tbl[[2]], "page")$border_color_first

  expect_equal(attr(tbl[[2]], "page")$nrow, 40)

  m1 <- iris %>%
    rtf_body()

  m2 <- iris %>%
    rtf_page(
      nrow = 10,
      border_color_first = "red",
      border_color_last = "red"
    ) %>%
    rtf_body()

  m3 <- iris %>%
    rtf_body()

  tbl <- list(m1, m2, m3)

  n <- length(tbl)

  tbl[2:(n - 1)] <- lapply(tbl[2:(n - 1)], function(x) {
    attr(x, "page")$border_first <- NULL
    attr(x, "page")$border_last <- NULL
    attr(x, "page")$border_color_first <- NULL
    attr(x, "page")$border_color_last <- NULL
    x
  })

  expect_equal(attr(tbl[[2]], "page")$border_first, NULL)
  expect_equal(attr(tbl[[2]], "page")$border_last, NULL)
  expect_equal(attr(tbl[[2]], "page")$border_color_first, NULL)
  expect_equal(attr(tbl[[2]], "page")$border_color_last, NULL)
})


test_that("Test border_color_first, border_color_last, border_first, and nrow", {
  m1 <- iris[1:15, ] %>%
    rtf_page(
      nrow = 5,
      border_color_first = "red"
    ) %>%
    rtf_body()

  m2 <- iris[31:50, ] %>%
    rtf_page(
      border_first = "double",
      border_last = "double"
    ) %>%
    rtf_body()

  m3 <- iris[51:60, ] %>%
    rtf_page(border_color_last = "red") %>%
    rtf_body()

  tbl <- list(m1, m2, m3)

  tbl_out <- tbl %>%
    rtf_encode_list()

  expect_snapshot_output(tbl_out)
})

test_that("Test when orientation are different in the list", {
  m1 <- iris[1:15, ] %>%
    rtf_page(
      nrow = 5,
      border_color_first = "red", orientation = "landscape"
    ) %>%
    rtf_body()

  m2 <- iris[31:50, ] %>%
    rtf_page(
      border_first = "double",
      border_last = "double"
    ) %>%
    rtf_body()

  m3 <- iris[51:60, ] %>%
    rtf_page(border_color_last = "red") %>%
    rtf_body()

  tbl <- list(m1, m2, m3)

  expect_error(tbl_out <- tbl %>% rtf_encode_list())
})

test_that("Test case to split page", {

  m1 <- iris[1:31, ] %>%
    rtf_page(
      nrow = 4,
    ) %>%
    rtf_body()

  m2 <- iris[40:50, ] %>%
    rtf_body()

  tbl <- list(m1, m2)

  tbl %>%
    rtf_encode_list() %>%
    expect_snapshot_output()

})
