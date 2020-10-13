context("independent testing for rtf_encode_figure.R")

library(ggplot2)
#create temporary png file
options(bitmapType='cairo')

df <- data.frame(x = c(1:30), y = c(1:30))



df %>% ggplot(aes(x, y)) + geom_point()

file_out <- tempfile()
ggsave(file_out, device = "png")


tbl <- rtf_read_png(file_out)  %>%
   rtf_figure(fig_width = 5,
              fig_height = 5) #page and image size set here

tbl <- tbl %>%  rtf_title("This is the title") %>% rtf_footnote("This is a footnote") %>%
  rtf_source("Source:  This is the source]")


tbl_encode <- tbl %>% rtf_encode_figure(page_title = "first",
                                        page_footnote = "all",
                                        page_source = "all")


test_that("figure width and height encoding", {
  fig_size <- "{\\pict\\pngblip\\picwgoal7200\\pichgoal7200"

  expect_true(grep(fig_size, tbl_encode,fixed=TRUE) == 2)
})

test_that("RTF page, margin encoding", {
  page_size <- "\\paperw12240\\paperh15840"

  expect_true(grep(page_size, tbl_encode,fixed=TRUE) == 2)

  margin_omi <-  c(1.25, 1, 1.75, 1.25, 1.75, 1.00625) # the margin for "wma" and "portrait"
  margin <- c("\\margl", "\\margr", "\\margt", "\\margb", "\\headery", "\\footery")
  margin <- paste(paste0(margin, inch_to_twip(margin_omi)), collapse = "")
  margin <- paste0(margin, "\n")

  expect_true(grep(margin, tbl_encode,fixed=TRUE) == 2)
})

test_that("RTF title, footnote and source encoding", {
  # Footnote always be free text in figures
  footnote <- attr(tbl, "rtf_footnote")
  if(! is.null(footnote)){
    attr(footnote, "as_table") <- FALSE
    attr(tbl, "rtf_footnote") <- footnote
  }

  title_rtftext <- as_rtf_title(tbl)
  footnote_rtftext <- as_rtf_footnote(tbl)
  source_rtftext <- as_rtf_source(tbl)

  expect_true(grep(title_rtftext, tbl_encode,fixed=TRUE) == 2)
  expect_true(grep(footnote_rtftext, tbl_encode,fixed=TRUE) == 2)
  expect_true(grep(source_rtftext, tbl_encode,fixed=TRUE) == 2)
})


test_that("RTF title, footnote and source encoding other case for locations", {

  tbl_encode1 <- tbl %>% rtf_encode_figure(page_title = "last",
                                           page_footnote = "first",
                                           page_source = "first")

  footnote <- attr(tbl, "rtf_footnote")
  if(! is.null(footnote)){
    attr(footnote, "as_table") <- FALSE
    attr(tbl, "rtf_footnote") <- footnote
  }

  title_rtftext <- as_rtf_title(tbl)
  footnote_rtftext <- as_rtf_footnote(tbl)
  source_rtftext <- as_rtf_source(tbl)

  expect_true(grep(title_rtftext, tbl_encode,fixed=TRUE) == 2)
  expect_true(grep(footnote_rtftext, tbl_encode,fixed=TRUE) == 2)
  expect_true(grep(source_rtftext, tbl_encode,fixed=TRUE) == 2)
})

test_that("RTF title, footnote and source encoding other case for locations", {

  tbl_encode1 <- tbl %>% rtf_encode_figure(page_title = "last",
                                           page_footnote = "last",
                                           page_source = "last")

  footnote <- attr(tbl, "rtf_footnote")
  if(! is.null(footnote)){
    attr(footnote, "as_table") <- FALSE
    attr(tbl, "rtf_footnote") <- footnote
  }

  title_rtftext <- as_rtf_title(tbl)
  footnote_rtftext <- as_rtf_footnote(tbl)
  source_rtftext <- as_rtf_source(tbl)

  expect_true(grep(title_rtftext, tbl_encode,fixed=TRUE) == 2)
  expect_true(grep(footnote_rtftext, tbl_encode,fixed=TRUE) == 2)
  expect_true(grep(source_rtftext, tbl_encode,fixed=TRUE) == 2)
})
