test_that("RTF init", {
  expect_equal(as_rtf_init(),
               "{\\rtf1\\ansi\n\\deff0\\deflang1033"
  )
})

test_that("RTF font type encode", {

  expect_snapshot_output(as_rtf_font())

})

test_that("RTF font color encode with color not NULL", {
  x <- iris %>% rtf_page(orientation = 'portrait') %>% rtf_body(text_color = "red")
  expect_snapshot_output(as_rtf_color(x))

})

test_that("RTF font color encode with color NULL", {
  x <- iris %>% rtf_body()
  expect_equal(as_rtf_color(x),
               NULL)
})

test_that("RTF page width encode", {
  x <- iris %>% rtf_page(orientation = 'portrait', width=8.5)
  expect_equal(as_rtf_page(x),"\\paperw12240\\paperh15840\n")
})

test_that("RTF page height encode - 11 inch", {
  x <- iris %>% rtf_page(orientation = 'portrait', height=11)
  expect_equal(as_rtf_page(x),
               "\\paperw12240\\paperh15840\n")
})


test_that("RTF page height encode - 10 inch", {
  x <- iris %>% rtf_page(orientation = 'portrait', height=10)
  expect_equal(as_rtf_page(x),
               "\\paperw12240\\paperh14400\n")
})

test_that("RTF page orientation encode - landscape", {
  x <- iris %>% rtf_page(orientation = 'landscape')
  expect_equal(as_rtf_page(x),
               "\\paperw15840\\paperh12240\\landscape\n")
})

test_that("RTF page orientation encode - landscape + height 4 + width 6", {
  x <- iris %>% rtf_page(orientation = 'landscape', width=6, height=4)
  expect_equal(as_rtf_page(x),
               "\\paperw8640\\paperh5760\\landscape\n")
})

test_that("RTF page margin encode", {
  x <- iris %>% rtf_page(orientation = 'portrait')
  expect_equal(as_rtf_margin(x),
               "\\margl1800\\margr1440\\margt2520\\margb1800\\headery2520\\footery1449\n")
})

test_that("RTF page margin encode - landscape + height 4 + width 6", {
  x <- iris %>% rtf_page(orientation = 'landscape', width=6, height=4)
  expect_equal(as_rtf_margin(x),
               "\\margl1440\\margr1440\\margt2880\\margb1800\\headery1800\\footery1800\n")
})

test_that("RTF title ", {
  x <- iris %>% rtf_title(title="title test")
  expect_equal(as_rtf_title(x),
               "{\\pard\\hyphpar\n\\sb180\\sa180\\fi0\\li0\\ri0\\qc\n{\\f0\\fs24 title test}\n\\par}"
  )
})

test_that("RTF title when no attr assigned", {
  x <- iris
  expect_equal(as_rtf_title(x), NULL)
})


test_that("RTF colheader ", {
  x <- iris %>% rtf_colheader()
  expect_equal(as_rtf_colheader(x),NULL)
})

test_that("RTF footnote font encode - font 2", {
  x <- iris %>% rtf_footnote(footnote = "test", text_font=2 )
  expect_snapshot_output(as_rtf_footnote(x))
})

test_that("RTF footnote font encode - font 3", {
  x <- iris %>% rtf_footnote(footnote = "test", text_font=3 )
  expect_snapshot_output(as_rtf_footnote(x))
})


test_that("RTF footnote format, size and color encode", {
  x <- iris %>% rtf_footnote(footnote = "test", text_font_size=8, text_format="i",text_color="red" )
  expect_snapshot_output(as_rtf_footnote(x))
})

test_that("RTF footnote NULL", {
  x <- iris
  expect_equal(as_rtf_footnote(x), NULL)
})

test_that("RTF footnote when as_table = TRUE", {
  x <- iris %>% rtf_footnote(footnote = "test", as_table = TRUE)
  expect_snapshot_output(as_rtf_footnote(x))})

test_that("RTF footnote when as_table = FALSE", {
  x <- iris %>% rtf_body() %>% rtf_footnote(footnote = "test", as_table = FALSE)
  expect_equal(as_rtf_footnote(x),
               "{\\pard\\hyphpar\n\\sb15\\sa15\\fi0\\li0\\ri0\\ql\n{\\f0\\fs18 test}\n\\par}")
})

test_that("RTF source font encode", {
  x <- iris %>% rtf_source("data source: adae", text_font=2)
  expect_snapshot_output(as_rtf_source(x))
})

test_that("RTF source format, size and color encode", {
  x <- iris %>% rtf_source("data source: adae", text_font_size=8, text_format="b", text_color="red" )
  expect_equal(as_rtf_source(x),
               "{\\pard\\hyphpar\n\\sb15\\sa15\\fi0\\li0\\ri0\\qc\n{\\f0\\fs16\\b\\cf553 data source: adae}\n\\par}"
    )

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
  expect_equal(as_rtf_source(x),
               "{\\pard\\hyphpar\n\\sb15\\sa15\\fi0\\li0\\ri0\\qc\n{\\f0\\fs18 test}\n\\par}")
})

test_that("RTF new page", {
  expect_equal(as_rtf_new_page(),
               "\\intbl\\row\\pard\\page\\par\\pard"
  )
})

test_that("RTF end", {
  expect_equal(as_rtf_end(),
               "}"
  )
})


# tests not using as_rtf_source
test_that("RTF page width encode", {
  x <- iris %>% rtf_page(orientation = 'portrait', width=8.5)
  expect_equal(attr(x, "page")$width, 8.5)
  expect_equal(attr(x, "page")$orientation, "portrait")
})


test_that("RTF page margin encode - landscape + height 4 + width 6", {
  x <- iris %>% rtf_page(orientation = 'landscape', width=6, height=4)
  expect_equal(attr(x, "page")$width, 6)
  expect_equal(attr(x, "page")$height, 4)
  expect_equal(attr(x, "page")$orientation, "landscape")
})

test_that("RTF source format, size and color encode", {
  x <- iris %>% rtf_source("data source: adae", text_font_size=8, text_format="b", text_color="red" )
  expect_equal(attr(attr(x, "rtf_source"), 'text_font_size'), 8)
  expect_equal(attr(attr(x, "rtf_source"), 'text_format'), "b")
  expect_equal(attr(attr(x, "rtf_source"), 'text_color'), "red")


})


