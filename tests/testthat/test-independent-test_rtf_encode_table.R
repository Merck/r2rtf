context("Independent testing for rtf_encode_table.R")

##create temporary dataset to run the testing
data1 <- iris[1:2,]
data2 <- data1 %>% rtf_body (colheader = TRUE
                             ,col_rel_width = c(5,9,13,18,9)
)

#create rtf encode table
data3 <- data2 %>%  rtf_encode_table()

#create temporary table output and read input for testing
write_rtf(data3, file = file.path(tempdir(), "test01.rtf"))
tbl <- readLines(file.path(tempdir(), "test01.rtf"))


test_that("RTF page, margin encoding", {
  #check for rtf page height and width
  pghw <- tbl[9]
  expect_true(grep(pghw, data3, fixed = TRUE) == 2)
  expect_equal(as_rtf_page(data2), paste0(tbl[9], "\n") )

  #check for rtf page margin
  rtfmrg <- tbl[11]
  expect_true(grep(rtfmrg, data3, fixed = TRUE) == 2)
  expect_equal(as_rtf_margin(data2), paste0(tbl[11], "\n") )
})

test_that("RTF colheader", {

  d1 <- iris[1:100,]
  d2 <- d1 %>% rtf_body (colheader = TRUE
                         , col_rel_width = rep(1, ncol(d1))
  )

  encode2 <-  rtf_encode_table (d2)

  colheader <- attr(d2, "rtf_colheader")

  if (length(colheader) > 0) {
    head <- attributes(colheader[[1]])$border_top
    attributes(colheader[[1]])$border_top <- matrix( attr(d2, "page")$border_first, nrow = 1, ncol = ncol(head))

    colheader_rtftext_1 <- lapply(colheader, rtf_table_content,
                                  col_total_width = attr(d2, "page")$col_width)

    colheader_rtftext_2 <- unlist(colheader_rtftext_1)

    colheader_rtftext_3 <-paste(unlist(colheader_rtftext_2), collapse = "\n")
  }

  expect_true(grep(colheader_rtftext_3 , encode2, fixed=TRUE) == 2)

  })


test_that("RTF header, footnote and source encoding", {
  #create test data
  d1 <- iris[1:2,]
  d2 <- d1 %>% rtf_body (colheader = TRUE
                         , col_rel_width = rep(1, ncol(d1))
                         ,border_width = 12
                         ,cell_height = 0.15
                         ,page_by = NULL
                         ,new_page = FALSE)

  d3 <- d2 %>% rtf_footnote("Test footnote xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" ,  border_width = 15,
                            cell_height = 0.15,
                            cell_justification = "c", ) %>%
    rtf_source ("[Source:  mk9999testing]",  text_indent_first = 1 , text_indent_left = 0,
                text_indent_right = 0) %>%
    rtf_title ("Title Testing")

  encode <-  d3 %>% rtf_encode_table (page_title = "last",
                                      page_footnote = "first",
                                      page_source = "last" )


  expect_true(grep(as_rtf_footnote(d3), encode, fixed=TRUE) == 2)
  expect_true(grep(as_rtf_source(d3), encode, fixed=TRUE)   == 2)
  expect_true(grep(as_rtf_title(d3), encode, fixed=TRUE)    == 2)

})


test_that("RTF header, footnote and source encoding for different location", {
    #create test data
    d1 <- iris[1:2,]
    d2 <- d1 %>% rtf_body (colheader = TRUE
                           , col_rel_width = rep(1, ncol(d1))
                           ,border_width = 12
                           ,cell_height = 0.15
                           ,page_by = NULL
                           ,new_page = FALSE)

    d3 <- d2 %>% rtf_footnote("Test footnote xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" ,  border_width = 15,
                              cell_height = 0.15,
                              cell_justification = "c", ) %>%
      rtf_source ("[Source:  mk9999testing]",  text_indent_first = 1 , text_indent_left = 0,
                  text_indent_right = 0) %>%
      rtf_title ("Title Testing")

  encode1 <- d3 %>%  rtf_encode_table(page_title = "first",
                                      page_footnote = "last",
                                      page_source = "first")

  #assign defult value ..
  k   <- attr(d3, "rtf_footnote")
  attr(k, "border_bottom") <- attr(d3, "page")$border_last
  attr(d3, "rtf_footnote") <- k
  footnote_rtftext_1 <- as_rtf_footnote(d3)



  expect_true(grep(as_rtf_footnote(d3), encode1, fixed=TRUE) == 2)
  expect_true(grep(as_rtf_source(d3), encode1, fixed=TRUE)   == 2)
  expect_true(grep(as_rtf_title(d3), encode1, fixed=TRUE)    == 2)



})



test_that("input value test if data frame or list of data frames", {
  m <- iris[1:2,]
  m1 <- m %>% rtf_body (colheader = TRUE
                        ,col_rel_width = c(5,9,13,18,9)) %>%
    rtf_encode_table()

  write_rtf(m1, file = file.path(tempdir(), "temp.rtf"))

  y <- readLines(file.path(tempdir(), "temp.rtf"))


  expect_equal(paste(unlist(m1), collapse = "\n"), paste(y, collapse= "\n" ))
})


test_that("Test case when source are included as table", {
  m <- iris[1:2,]
  m1 <- m %>% rtf_body (colheader = TRUE
                        ,col_rel_width = c(5,9,13,18,9)) %>%
    rtf_source("source text", as_table = TRUE) %>%
    rtf_encode_table()

  write_rtf(m1, file = file.path(tempdir(), "temp.rtf"))

  y <- readLines(file.path(tempdir(), "temp.rtf"))

  expect_equal(paste(unlist(m1), collapse = "\n"), paste(y, collapse= "\n" ))
})

test_that("Test case when page_by var is not NULL", {
  m <- iris[1:60,]
  m1 <- m %>% dplyr::arrange(Species) %>%
              rtf_body (page_by = 'Species',
                        colheader = TRUE,
                        col_rel_width = c(5,9,13,18,9),
                        border_color_bottom = "black",
                        border_color_last = "red") %>%
              rtf_encode_table()

  write_rtf(m1, file = file.path(tempdir(), "temp.rtf"))

  y <- readLines(file.path(tempdir(), "temp.rtf"))

  expect_equal(paste(unlist(m1), collapse = "\n"), paste(y, collapse= "\n" ))
})


test_that("Test case when footnote and source display in all pages", {
  m <- iris[1:60,]
  m1 <- m %>% dplyr::arrange(Species) %>%
    rtf_body (page_by = 'Species',
              colheader = TRUE,
              col_rel_width = c(5,9,13,18,9),
              border_color_bottom = "black",
              border_color_last = "red") %>%
              rtf_encode_table(page_footnote = "all", page_source = "all")

  write_rtf(m1, file = file.path(tempdir(), "temp.rtf"))

  y <- readLines(file.path(tempdir(), "temp.rtf"))

  expect_equal(paste(unlist(m1), collapse = "\n"), paste(y, collapse= "\n" ))
})


