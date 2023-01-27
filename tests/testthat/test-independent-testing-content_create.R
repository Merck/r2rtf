test_that("RTF init", {
  expect_equal(
    as_rtf_init(),
    "{\\rtf1\\ansi\n\\deff0\\deflang1033"
  )
})

test_that("RTF font type encode", {
  expect_snapshot_output(as_rtf_font())
})

test_that("RTF font color encode with color not NULL", {
  x <- iris %>%
    rtf_page(orientation = "portrait") %>%
    rtf_body(text_color = "red")
  expect_snapshot_output(as_rtf_color(x))
})

test_that("RTF font color encode with color NULL", {
  x <- iris %>% rtf_body()
  expect_equal(
    as_rtf_color(x),
    NULL
  )
})

test_that("RTF page width encode", {
  x <- iris %>% rtf_page(orientation = "portrait", width = 8.5)
  expect_equal(as_rtf_page(x), "\\paperw12240\\paperh15840\n")
})

test_that("RTF page height encode - 11 inch", {
  x <- iris %>% rtf_page(orientation = "portrait", height = 11)
  expect_equal(
    as_rtf_page(x),
    "\\paperw12240\\paperh15840\n"
  )
})


test_that("RTF page height encode - 10 inch", {
  x <- iris %>% rtf_page(orientation = "portrait", height = 10)
  expect_equal(
    as_rtf_page(x),
    "\\paperw12240\\paperh14400\n"
  )
})

test_that("RTF page orientation encode - landscape", {
  x <- iris %>% rtf_page(orientation = "landscape")
  expect_equal(
    as_rtf_page(x),
    "\\paperw15840\\paperh12240\\landscape\n"
  )
})

test_that("RTF page orientation encode - landscape + height 4 + width 6", {
  x <- iris %>% rtf_page(orientation = "landscape", width = 6, height = 4)
  expect_equal(
    as_rtf_page(x),
    "\\paperw8640\\paperh5760\\landscape\n"
  )
})

test_that("RTF page margin encode", {
  x <- iris %>% rtf_page(orientation = "portrait")
  expect_equal(
    as_rtf_margin(x),
    "\\margl1800\\margr1440\\margt2520\\margb1800\\headery2520\\footery1449\n"
  )
})

test_that("RTF page margin encode - landscape + height 4 + width 6", {
  x <- iris %>% rtf_page(orientation = "landscape", width = 6, height = 4)
  expect_equal(
    as_rtf_margin(x),
    "\\margl1440\\margr1440\\margt2880\\margb1800\\headery1800\\footery1800\n"
  )
})

test_that("RTF title ", {
  x <- iris %>% rtf_title(title = "title test")
  expect_snapshot_output(as_rtf_title(x))
})

test_that("RTF title when no attr assigned", {
  x <- iris
  expect_equal(as_rtf_title(x), NULL)
})


test_that("RTF colheader ", {
  x <- iris %>% rtf_colheader()
  expect_equal(as_rtf_colheader(x), NULL)
})

test_that("RTF footnote font encode - font 2", {
  x <- iris %>% rtf_footnote(footnote = "test", text_font = 2)
 expect_equal(as_rtf_footnote(x), "\\trowd\\trgaph108\\trleft0\\trqc\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrw15\\clbrdrr\\brdrs\\brdrw15\\clbrdrb\\brdrs\\brdrw15\\clvertalt\\cellx9000\n\\pard\\hyphpar0\\sb15\\sa15\\fi0\\li0\\ri0\\ql\\fs18{\\f1 test}\\cell\n\\intbl\\row\\pard")
})

test_that("RTF footnote font encode - font 3", {
  x <- iris %>% rtf_footnote(footnote = "test", text_font = 3)
  expect_equal(as_rtf_footnote(x), "\\trowd\\trgaph108\\trleft0\\trqc\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrw15\\clbrdrr\\brdrs\\brdrw15\\clbrdrb\\brdrs\\brdrw15\\clvertalt\\cellx9000\n\\pard\\hyphpar0\\sb15\\sa15\\fi0\\li0\\ri0\\ql\\fs18{\\f2 test}\\cell\n\\intbl\\row\\pard")
})


test_that("RTF footnote format, size and color encode", {
  x <- iris %>% rtf_footnote(footnote = "test", text_font_size = 8, text_format = "i", text_color = "red")
  expect_equal(as_rtf_footnote(x), "\\trowd\\trgaph108\\trleft0\\trqc\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrw15\\clbrdrr\\brdrs\\brdrw15\\clbrdrb\\brdrs\\brdrw15\\clvertalt\\cellx9000\n\\pard\\hyphpar0\\sb15\\sa15\\fi0\\li0\\ri0\\ql\\fs16{\\f0\\i\\cf552 test}\\cell\n\\intbl\\row\\pard")
})

test_that("RTF footnote NULL", {
  x <- iris
  expect_equal(as_rtf_footnote(x), NULL)
})

test_that("RTF footnote when as_table = TRUE", {
  x <- iris %>% rtf_footnote(footnote = "test", as_table = TRUE)
  expect_equal(as_rtf_footnote(x), "\\trowd\\trgaph108\\trleft0\\trqc\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrw15\\clbrdrr\\brdrs\\brdrw15\\clbrdrb\\brdrs\\brdrw15\\clvertalt\\cellx9000\n\\pard\\hyphpar0\\sb15\\sa15\\fi0\\li0\\ri0\\ql\\fs18{\\f0 test}\\cell\n\\intbl\\row\\pard")
})

test_that("RTF footnote when as_table = FALSE", {
  x <- iris %>%
    rtf_body() %>%
    rtf_footnote(footnote = "test", as_table = FALSE)
  expect_snapshot_output(as_rtf_footnote(x))
})

test_that("RTF source font encode", {
  x <- iris %>% rtf_source("data source: adae", text_font = 2)
  expect_snapshot_output(as_rtf_source(x))
})

test_that("RTF source format, size and color encode", {
  x <- iris %>% rtf_source("data source: adae", text_font_size = 8, text_format = "b", text_color = "red")
  expect_snapshot_output(as_rtf_source(x))
})

test_that("RTF source NULL", {
  x <- iris
  expect_equal(as_rtf_source(x), NULL)
})

test_that("RTF source when as_table = TRUE", {
  x <- iris %>% rtf_source(source = "test", as_table = TRUE)
  expect_snapshot_output(as_rtf_source(x))
})

test_that("RTF source when as_table = FALSE", {
  x <- iris %>% rtf_source(source = "test", as_table = FALSE)
  expect_snapshot_output(as_rtf_source(x))
})

test_that("RTF new page", {
  expect_snapshot_output(as_rtf_new_page())
})

test_that("RTF end", {
  expect_equal(
    as_rtf_end(),
    "}"
  )
})


# tests not using as_rtf_source
test_that("RTF page width encode", {
  x <- iris %>% rtf_page(orientation = "portrait", width = 8.5)
  expect_equal(attr(x, "page")$width, 8.5)
  expect_equal(attr(x, "page")$orientation, "portrait")
})


test_that("RTF page margin encode - landscape + height 4 + width 6", {
  x <- iris %>% rtf_page(orientation = "landscape", width = 6, height = 4)
  expect_equal(attr(x, "page")$width, 6)
  expect_equal(attr(x, "page")$height, 4)
  expect_equal(attr(x, "page")$orientation, "landscape")
})

# add tests for new features
test_that("Test for function as_rtf_page() when page header exists", {
  x <- head(iris, 2) %>%
    rtf_page_header(text = "header test text")

  expect_equal(as_rtf_page(x), "{\\header\n{\\pard\\sb15\\sa15\\fi0\\li0\\ri0\\qr\\fs24{\\f0 header test text}\\par}\n}\n\\paperw12240\\paperh15840\n")
})

test_that("Test for function as_rtf_page() when page footer exists", {
  ft <- head(iris, 2) %>%
    rtf_page_footer(text = "footer test text")

  expect_equal(as_rtf_page(ft), "{\\footer\n{\\pard\\sb15\\sa15\\fi0\\li0\\ri0\\qc\\fs24{\\f0 footer test text}\\par}\n}\n\\paperw12240\\paperh15840\n")
})

test_that("Test for function as_rtf_subline() when subline exists", {
  sl <- head(iris, 2) %>%
    rtf_subline(text = "subline test text")

  expect_equal(as_rtf_subline(sl), "{\\pard\\hyphpar\\sb180\\sa180\\fi0\\li0\\ri0\\ql\\fs24{\\f0 subline test text}\\par}")
})

# test_that("Test for function as_rtf_footnote() when there is no text conversion
# i.e. attr(text, 'text_convert') = NULL", {
#   fn1 <- head(iris, 2) %>%
#     rtf_title(title = 'footnote example') %>%
#     rtf_footnote(footnote = c("> = sign: {\\geq}", "superscript: {^a}"),
#                  text_convert=FALSE)
#
#   expect_true(grepl("\\geq", as_rtf_footnote(fn1), fixed = TRUE))
#   expect_true(grepl("^a", as_rtf_footnote(fn1), fixed = TRUE))
#
#   fn2 <- head(iris, 2) %>%
#     rtf_title(title = 'footnote example') %>%
#     rtf_footnote(footnote = c("> = sign: {\\geq}", "superscript: {^a}"))
#
#   expect_false(grepl("\\geq", as_rtf_footnote(fn2), fixed = TRUE))
#   expect_false(grepl("^a", as_rtf_footnote(fn2), fixed = TRUE))
# })
#
# test_that("Test for function as_rtf_source() when there is no text conversion
# i.e. attr(text, 'text_convert') = NULL", {
#   sc <- head(iris, 2) %>%
#     rtf_source(source = c(">= sign: {\\geq}", "superscript: {^a}"),
#                text_convert = FALSE)
#
#   expect_true(grepl("\\geq", as_rtf_source(sc), fixed = TRUE))
#   expect_true(grepl("^a", as_rtf_source(sc), fixed = TRUE))
# })
