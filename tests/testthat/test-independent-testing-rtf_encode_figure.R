
tbl <- rtf_read_figure("fig/fig1.png") %>%
  rtf_figure(
    fig_width = 5,
    fig_height = 5
  ) # page and image size set here

tbl <- tbl %>%
  rtf_title("This is the title") %>%
  rtf_footnote("This is a footnote") %>%
  rtf_source("Source:  This is the source]")

attr(tbl, "page")$page_title <- "first"
attr(tbl, "page")$page_footnote <- "all"
attr(tbl, "page")$page_source <- "all"

tbl_encode <- tbl %>% rtf_encode_figure()


test_that("figure width and height encoding", {
  fig_size <- "{\\pict\\pngblip\\picwgoal7200\\pichgoal7200"

  expect_true(grep(fig_size, tbl_encode, fixed = TRUE) == 2)
})

test_that("RTF page, margin encoding", {
  page_size <- "\\paperw12240\\paperh15840"

  expect_true(grep(page_size, tbl_encode, fixed = TRUE) == 2)

  margin_omi <- c(1.25, 1, 1.75, 1.25, 1.75, 1.00625) # the margin for "wma" and "portrait"
  margin <- c("\\margl", "\\margr", "\\margt", "\\margb", "\\headery", "\\footery")
  margin <- paste(paste0(margin, inch_to_twip(margin_omi)), collapse = "")
  margin <- paste0(margin, "\n")

  expect_true(grep(margin, tbl_encode, fixed = TRUE) == 2)
})

test_that("RTF title, footnote and source encoding", {
  # Footnote always be free text in figures
  footnote <- attr(tbl, "rtf_footnote")
  if (!is.null(footnote)) {
    attr(footnote, "as_table") <- FALSE
    attr(tbl, "rtf_footnote") <- footnote
  }

  title_rtftext <- as_rtf_title(tbl)
  footnote_rtftext <- as_rtf_footnote(tbl)
  source_rtftext <- as_rtf_source(tbl)

  expect_true(grep(title_rtftext, tbl_encode, fixed = TRUE) == 2)
  expect_true(grep(footnote_rtftext, tbl_encode, fixed = TRUE) == 2)
  expect_true(grep(source_rtftext, tbl_encode, fixed = TRUE) == 2)
})


test_that("RTF title, footnote and source encoding other case for locations", {
  attr(tbl, "page")$page_title <- "last"
  attr(tbl, "page")$page_footnote <- "first"
  attr(tbl, "page")$page_source <- "first"

  tbl_encode1 <- rtf_encode_figure(tbl)

  footnote <- attr(tbl, "rtf_footnote")
  if (!is.null(footnote)) {
    attr(footnote, "as_table") <- FALSE
    attr(tbl, "rtf_footnote") <- footnote
  }

  title_rtftext <- as_rtf_title(tbl)
  footnote_rtftext <- as_rtf_footnote(tbl)
  source_rtftext <- as_rtf_source(tbl)

  expect_true(grep(title_rtftext, tbl_encode, fixed = TRUE) == 2)
  expect_true(grep(footnote_rtftext, tbl_encode, fixed = TRUE) == 2)
  expect_true(grep(source_rtftext, tbl_encode, fixed = TRUE) == 2)
})

test_that("RTF title, footnote and source encoding other case for locations", {
  attr(tbl, "page")$page_title <- "last"
  attr(tbl, "page")$page_footnote <- "last"
  attr(tbl, "page")$page_source <- "last"

  tbl_encode1 <- rtf_encode_figure(tbl)

  footnote <- attr(tbl, "rtf_footnote")
  if (!is.null(footnote)) {
    attr(footnote, "as_table") <- FALSE
    attr(tbl, "rtf_footnote") <- footnote
  }

  title_rtftext <- as_rtf_title(tbl)
  footnote_rtftext <- as_rtf_footnote(tbl)
  source_rtftext <- as_rtf_source(tbl)

  expect_true(grep(title_rtftext, tbl_encode, fixed = TRUE) == 2)
  expect_true(grep(footnote_rtftext, tbl_encode, fixed = TRUE) == 2)
  expect_true(grep(source_rtftext, tbl_encode, fixed = TRUE) == 2)
})
