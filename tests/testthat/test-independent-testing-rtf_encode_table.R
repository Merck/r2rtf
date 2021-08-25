## create temporary dataset to run the testing
data1 <- iris[1:2, ]
data2 <- data1 %>% rtf_body(
  as_colheader = TRUE,
  col_rel_width = c(5, 9, 13, 18, 9)
)

# create rtf encode table
attr(data2, "page")$page_title <- "all"
attr(data2, "page")$page_footnote <- "last"
attr(data2, "page")$page_source <- "last"

data3 <- data2 %>% rtf_encode_table()

test_that("RTF page, margin encoding", {
  expect_snapshot_output(data3)
})

test_that("RTF colheader", {
  d1 <- iris[1:100, ]
  d2 <- d1 %>% rtf_body(
    as_colheader = TRUE,
    col_rel_width = rep(1, ncol(d1))
  )

  attr(d2, "page")$page_title <- "all"
  attr(d2, "page")$page_footnote <- "last"
  attr(d2, "page")$page_source <- "last"

  encode2 <- rtf_encode_table(d2)

  colheader <- attr(d2, "rtf_colheader")

  if (length(colheader) > 0) {
    head <- attributes(colheader[[1]])$border_top
    attributes(colheader[[1]])$border_top <- matrix(attr(d2, "page")$border_first, nrow = 1, ncol = ncol(head))

    colheader_rtftext_1 <- lapply(colheader, rtf_table_content,
      use_border_bottom = TRUE,
      col_total_width = attr(d2, "page")$col_width
    )

    colheader_rtftext_2 <- unlist(colheader_rtftext_1)

    colheader_rtftext_3 <- paste(unlist(colheader_rtftext_2), collapse = "\n")
  }

  expect_true(grep(colheader_rtftext_3, encode2, fixed = TRUE) == 2)
})


test_that("RTF header, footnote and source encoding", {
  # create test data
  d1 <- iris[1:2, ]
  d2 <- d1 %>% rtf_body(
    as_colheader = TRUE,
    col_rel_width = rep(1, ncol(d1)),
    border_width = 12,
    cell_height = 0.15,
    page_by = NULL,
    new_page = FALSE
  )

  d3 <- d2 %>%
    rtf_footnote("Test footnote xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
      border_width = 15,
      cell_height = 0.15,
      cell_justification = "c",
    ) %>%
    rtf_source("[Source:  mk9999testing]",
      text_indent_first = 1, text_indent_left = 0,
      text_indent_right = 0
    ) %>%
    rtf_title("Title Testing")


  attr(d3, "page")$page_title <- "last"
  attr(d3, "page")$page_footnote <- "first"
  attr(d3, "page")$page_source <- "last"

  encode <- d3 %>% rtf_encode_table()


  expect_true(grep(as_rtf_footnote(d3), encode, fixed = TRUE) == 2)
  expect_true(grep(as_rtf_source(d3), encode, fixed = TRUE) == 2)
  expect_true(grep(as_rtf_title(d3), encode, fixed = TRUE) == 2)
})


test_that("RTF header, footnote and source encoding for different location", {
  # create test data
  d1 <- iris[1:2, ]
  d2 <- d1 %>% rtf_body(
    as_colheader = TRUE,
    col_rel_width = rep(1, ncol(d1)),
    border_width = 12,
    cell_height = 0.15,
    page_by = NULL,
    new_page = FALSE
  )

  d3 <- d2 %>%
    rtf_footnote("Test footnote xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
      border_width = 15,
      cell_height = 0.15,
      cell_justification = "c",
    ) %>%
    rtf_source("[Source:  mk9999testing]",
      text_indent_first = 1, text_indent_left = 0,
      text_indent_right = 0
    ) %>%
    rtf_title("Title Testing")

  attr(d3, "page")$page_title <- "first"
  attr(d3, "page")$page_footnote <- "last"
  attr(d3, "page")$page_source <- "first"

  encode1 <- d3 %>% rtf_encode_table()

  # assign defult value ..
  k <- attr(d3, "rtf_footnote")
  attr(k, "border_bottom") <- attr(d3, "page")$border_last
  attr(d3, "rtf_footnote") <- k
  footnote_rtftext_1 <- as_rtf_footnote(d3)



  expect_true(grep(as_rtf_footnote(d3), encode1, fixed = TRUE) == 2)
  expect_true(grep(as_rtf_source(d3), encode1, fixed = TRUE) == 2)
  expect_true(grep(as_rtf_title(d3), encode1, fixed = TRUE) == 2)
})



test_that("input value test if data frame or list of data frames", {
  m <- iris[1:2, ]
  m1 <- m %>% rtf_body(
    as_colheader = TRUE,
    col_rel_width = c(5, 9, 13, 18, 9)
  )

  attr(m1, "page")$page_title <- "all"
  attr(m1, "page")$page_footnote <- "last"
  attr(m1, "page")$page_source <- "last"
  m1 <- rtf_encode_table(m1)

  expect_snapshot_output(m1)
})


test_that("Test case when source are included as table", {
  m <- iris[1:2, ]
  m1 <- m %>%
    rtf_body(
      as_colheader = TRUE,
      col_rel_width = c(5, 9, 13, 18, 9)
    ) %>%
    rtf_source("source text", as_table = TRUE)

  attr(m1, "page")$page_title <- "all"
  attr(m1, "page")$page_footnote <- "last"
  attr(m1, "page")$page_source <- "last"
  m1 <- rtf_encode_table(m1)

  expect_snapshot_output(m1)
})

test_that("Test case when page_by var is not NULL", {
  m <- iris[1:60, ]
  m1 <- m %>%
    dplyr::arrange(Species) %>%
    rtf_body(
      page_by = "Species",
      as_colheader = TRUE,
      col_rel_width = c(5, 9, 13, 18, 9),
      border_color_bottom = "black",
      border_color_last = "red"
    )

  attr(m1, "page")$page_title <- "all"
  attr(m1, "page")$page_footnote <- "last"
  attr(m1, "page")$page_source <- "last"
  m1 <- rtf_encode_table(m1)

  expect_snapshot_output(m1)
})


test_that("Test case when footnote and source display in all pages", {
  m <- iris[1:60, ]
  m1 <- m %>%
    dplyr::arrange(Species) %>%
    rtf_body(
      page_by = "Species",
      as_colheader = TRUE,
      col_rel_width = c(5, 9, 13, 18, 9),
      border_color_bottom = "black",
      border_color_last = "red"
    )

  attr(m1, "page")$page_title <- "all"
  attr(m1, "page")$page_footnote <- "last"
  attr(m1, "page")$page_source <- "last"

  m1 <- rtf_encode_table(m1)

  expect_snapshot_output(m1)
})


# add additional test to increase coverage and for new feature
test_that("Test case when page$border_color_first is not NULL", {
  ir <- head(iris, 2) %>%
    rtf_page(border_color_first = "red") %>%
    rtf_body()

  ir <- rtf_encode_table(ir)

  expect_snapshot_output(ir)
})

test_that("Test case when pageby$border_color_last is not NULL", {
  ir2 <- head(iris, 2) %>%
    rtf_page(border_color_last = "red") %>%
    rtf_body()

  ir2 <- rtf_encode_table(ir2)

  expect_snapshot_output(ir2)
})

test_that("Test case when subline is not NULL", {
  ir3 <- iris[c(1:4, 51:54), 3:5] %>%
    mutate(s2 = paste0(Species, 1:2)) %>%
    arrange(Species, s2) %>%
    rtf_colheader("patelLength|patelWidth|s2") %>%
    rtf_body(subline_by = "Species")

  ir3 <- rtf_encode_table(ir3)

  expect_snapshot_output(ir3)
})

test_that("Test case when subline is not NULL and verbose equals to TRUE", {
  ir3 <- iris[c(1:4, 51:54), 3:5] %>%
    mutate(s2 = paste0(Species, 1:2)) %>%
    arrange(Species, s2) %>%
    rtf_colheader("patelLength|patelWidth|s2") %>%
    rtf_body(subline_by = "Species")

  ir3 <- rtf_encode_table(ir3, verbose = TRUE)

  expect_true(length(ir3$info) > 0)
})

test_that("Test case when using subline_by, page_by, group_by simultaneously in rtf_body", {
  data(r2rtf_adae)
  ae_t1 <- r2rtf_adae[200:260, ] %>%
    mutate(
      SUBLINEBY = paste0(
        "Trial Number: ", STUDYID,
        ", Site Number: ", SITEID
      ),
    ) %>%
    select(USUBJID, ASTDY, AEDECOD, TRTA, SUBLINEBY) %>%
    arrange(SUBLINEBY, TRTA, USUBJID, ASTDY) %>%
    rtf_colheader("Subject| Rel Day | Adverse |") %>%
    rtf_body(
      subline_by = "SUBLINEBY",
      page_by = c("TRTA"),
      group_by = c("USUBJID", "ASTDY"),
    )

  ae_t1 <- rtf_encode_table(ae_t1)

  expect_snapshot_output(ae_t1)
})


test_that("Test case when using subline_by, page_by, group_by simultaneously with pageby_row = 'first_row' and new_page = TRUE in rtf_body", {
  data(r2rtf_adae)
  ae_t2 <- r2rtf_adae[200:260, ] %>%
    subset(USUBJID != "01-701-1442") %>%
    mutate(
      SUBLINEBY = paste0(
        "Trial Number: ", STUDYID,
        ", Site Number: ", SITEID
      ),
    ) %>%
    select(USUBJID, ASTDY, AEDECOD, TRTA, SUBLINEBY) %>%
    arrange(SUBLINEBY, TRTA, USUBJID, ASTDY) %>%
    rtf_colheader("Subject| Rel Day | Adverse |",
      border_bottom = "single"
    ) %>%
    rtf_body(
      subline_by = "SUBLINEBY",
      page_by = c("TRTA"),
      pageby_row = "first_row",
      new_page = TRUE,
      group_by = c("USUBJID", "ASTDY")
    )

  ae_t2 <- rtf_encode_table(ae_t2)

  expect_snapshot_output(ae_t2)
})

test_that("Test case when using subline_by, page_by, group_by simultaneously with pageby_row = 'first_row' and new_page = TRUE in rtf_body and rtf_subline not null and page_title is 'first' or 'last'", {
  data(r2rtf_adae)
  ae_t3 <- r2rtf_adae[200:260, ] %>%
    subset(USUBJID != "01-701-1442") %>%
    mutate(
      SUBLINEBY = paste0(
        "Trial Number: ", STUDYID,
        ", Site Number: ", SITEID
      ),
    ) %>%
    select(USUBJID, ASTDY, AEDECOD, TRTA, SUBLINEBY) %>%
    arrange(SUBLINEBY, TRTA, USUBJID, ASTDY) %>%
    rtf_colheader("Subject| Rel Day | Adverse |",
      border_bottom = "single"
    ) %>%
    rtf_body(
      subline_by = "SUBLINEBY",
      page_by = c("TRTA"),
      pageby_row = "first_row",
      new_page = TRUE,
      group_by = c("USUBJID", "ASTDY")
    ) %>%
    rtf_subline("subline")

  attr(ae_t3, "page")$page_title <- "first"
  ae_t3a <- rtf_encode_table(ae_t3)
  expect_snapshot_output(ae_t3a)

  attr(ae_t3, "page")$page_title <- "last"
  ae_t3b <- rtf_encode_table(ae_t3)
  expect_snapshot_output(ae_t3b)
})
