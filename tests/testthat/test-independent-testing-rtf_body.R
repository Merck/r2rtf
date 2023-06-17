# Build Temporary dataset for use in testing
testdat <- iris[1:100, ]

# Check Temporary dataset attributes
testdatatt <- attributes(testdat)


test_that("case when as_colheader equals to NULL", {
  # Check case when as_colheader equals to ""

  expect_error(
    rtf_body(
      tbl = testdat,
      as_colheader = ""
    ),
    "The argument type did not match: logical"
  )

  # Check case when as_colheader equals to NULL

  expect_error(
    rtf_body(
      tbl = testdat,
      as_colheader = NULL
    ),
    "argument is of length zero"
  )
})

test_that("Column relative width", {
  # Check case when col_rel_width equals to ""

  expect_error(
    rtf_body(
      tbl = testdat,
      col_rel_width = ""
    ),
    "The argument type did not match: integer/numeric"
  )

  # Check col_rel_width attributes

  testdat2 <- testdat |>
    rtf_body(col_rel_width = c(1, 2, 3, 4, 5))

  expect_identical(
    attributes(testdat2)$col_rel_width,
    c(1, 2, 3, 4, 5)
  )
})

test_that("border type and color", {
  # Check border type and color attributes defaults

  testdat2 <- testdat |>
    rtf_body()

  expect_identical(
    attributes(testdat2)$border_left[50, 1:5],
    rep(c("single"), 5)
  )

  expect_identical(
    attributes(testdat2)$border_right[35, 1:5],
    rep(c("single"), 5)
  )

  expect_identical(
    attributes(testdat2)$border_top[1, 1:5],
    rep(c(""), 5)
  )

  expect_identical(
    attributes(testdat2)$border_bottom[100, 1:5],
    rep(c(""), 5)
  )

  expect_identical(
    attributes(testdat2)$border_first[1, 1:5],
    rep(c("single"), 5)
  )

  expect_identical(
    attributes(testdat2)$border_last[100, 1:5],
    rep(c("single"), 5)
  )

  expect_identical(
    attributes(testdat2)$border_color_left[50, 1:5],
    rep(c(NULL), 5)
  )

  expect_identical(
    attributes(testdat2)$border_color_right[35, 1:5],
    rep(c(NULL), 5)
  )

  expect_identical(
    attributes(testdat2)$border_color_top[1, 1:5],
    rep(c(NULL), 5)
  )

  expect_identical(
    attributes(testdat2)$border_color_bottom[100, 1:5],
    rep(c(NULL), 5)
  )

  expect_identical(
    attributes(testdat2)$border_color_first[1, 1:5],
    rep(c(NULL), 5)
  )

  expect_identical(
    attributes(testdat2)$border_color_last[100, 1:5],
    rep(c(NULL), 5)
  )

  # Check commonly used border type and color attributes formats

  testdat2 <- testdat |>
    rtf_body(
      border_left = c(
        "",
        "single",
        "double",
        "double",
        "dash"
      ),
      border_right = c(
        "dot",
        "dot dash",
        "double",
        "dash",
        "double"
      ),
      border_color_left = c(
        "white",
        "red",
        "blue",
        "green",
        "yellow"
      ),
      border_color_right = c(
        "brown",
        "violet",
        "bisque",
        "black",
        "cyan"
      ),
      border_color_top = c(
        "cadetblue",
        "darkblue",
        "violetred",
        "yellowgreen",
        "skyblue"
      ),
      border_color_bottom = c(
        "salmon",
        "sienna",
        "pink",
        "plum",
        "purple"
      ),
      border_color_first = c(
        "orange",
        "navy",
        "mintcream",
        "orchid",
        "magenta"
      ),
      border_color_last = c(
        "linen",
        "ivory",
        "khaki",
        "lavender",
        "indianred"
      )
    )

  expect_identical(
    attributes(testdat2)$border_color_left[50, 1:5],
    c("white", "red", "blue", "green", "yellow")
  )

  expect_identical(
    attributes(testdat2)$border_color_right[35, 1:5],
    c("brown", "violet", "bisque", "black", "cyan")
  )

  expect_identical(
    attributes(testdat2)$border_color_top[1, 1:5],
    c("cadetblue", "darkblue", "violetred", "yellowgreen", "skyblue")
  )

  expect_identical(
    attributes(testdat2)$border_color_bottom[100, 1:5],
    c("salmon", "sienna", "pink", "plum", "purple")
  )

  expect_identical(
    attributes(testdat2)$border_color_first[1, 1:5],
    c("orange", "navy", "mintcream", "orchid", "magenta")
  )

  expect_identical(
    attributes(testdat2)$border_color_last[100, 1:5],
    c("linen", "ivory", "khaki", "lavender", "indianred")
  )
})

test_that("cell justification and height", {
  # Check cell justification and height attribute default

  testdat2 <- testdat |>
    rtf_body()

  expect_identical(attributes(testdat2)$cell_justification, "c")

  expect_identical(attributes(testdat2)$cell_height, 0.15)

  testdat2 <- testdat[1:2, ] |>
    rtf_body(
      cell_justification = "j",
      cell_height = 2
    )

  expect_identical(attributes(testdat2)$cell_justification, "j")

  expect_identical(attributes(testdat2)$cell_height, 2)
})

test_that("text type", {
  # Check text attributes default

  testdat2 <- testdat |>
    rtf_body()

  expect_identical(attributes(testdat2)$text_justification[35, 1:5], rep(c("c"), 5))

  expect_identical(attributes(testdat2)$text_font[50, 1:5], rep(c(1), 5))

  expect_identical(attributes(testdat2)$text_font_size[100, 1:5], rep(c(9), 5))

  expect_null(attributes(testdat2)$text_format)

  expect_null(attributes(testdat2)$text_color)

  expect_null(attributes(testdat2)$text_background_color)

  expect_identical(attributes(testdat2)$text_space_before, 15)

  expect_identical(attributes(testdat2)$text_space_after, 15)


  testdat2 <- testdat[1:2, ] |>
    rtf_body(
      text_justification = c("l", "c", "r", "d", "j", "l", "c", "r", "d", "j"),
      text_font = c(1, 2, 3, 3, 2, 1, 2, 1, 3, 1),
      text_font_size = c(1, 2, 5, 10, 20, 30, 40, 50, 60, 100),
      text_format = c("", "b", "i", "u", "s", "ub", "ib", "sb", "^", ""),
      text_color = c(
        "white", "red", "blue", "green", "yellow",
        "cadetblue", "darkblue", "violetred",
        "yellowgreen", "skyblue"
      ),
      text_background_color = c(
        "salmon", "sienna", "pink", "plum",
        "purple", "orange", "navy", "mintcream",
        "orchid", "magenta"
      ),
      text_space_before = c(1, 2, 3, 10, 1.56, 7.23, 4.5, 6.986, 100, 3.23),
      text_space_after = c(3.25, 1.235, 1.852, 187, 38, 1.45, 2, 8, 100, 0.12)
    )

  expect_identical(
    attributes(testdat2)$text_justification[1, 1:5],
    c("l", "c", "r", "d", "j")
  )

  expect_identical(
    attributes(testdat2)$text_font[2, 1:5],
    c(1, 2, 1, 3, 1)
  )

  expect_identical(
    attributes(testdat2)$text_font_size[1, 1:5],
    c(1, 2, 5, 10, 20)
  )

  expect_identical(
    attributes(testdat2)$text_format[2, 1:5],
    c("ub", "ib", "sb", "^", "")
  )

  expect_identical(
    attributes(testdat2)$text_color[1, 1:5],
    c("white", "red", "blue", "green", "yellow")
  )

  expect_identical(
    attributes(testdat2)$text_background_color[2, 1:5],
    c("orange", "navy", "mintcream", "orchid", "magenta")
  )

  expect_identical(
    attributes(testdat2)$text_space_before[1:5],
    c(1, 2, 3, 10, 1.56)
  )

  expect_identical(
    attributes(testdat2)$text_space_after[6:10],
    c(1.45, 2, 8, 100, 0.12)
  )
})


test_that("Case for subline_by", {
  tbl <- iris[c(1:2, 51:52), ] |>
    rtf_body(
      subline_by = c("Species")
    )

  expect_identical(
    data.frame(attributes(tbl)$rtf_by_subline_row),
    data.frame(x = unique(tbl$Species))
  )

  expect_identical(
    attr(attr(tbl, "rtf_by_subline_row"), "border_top"),
    matrix("", nrow = 2, ncol = 1)
  )

  expect_identical(
    attributes(attr(tbl, "rtf_by_subline_row"))$border_bottom,
    matrix("", nrow = 2, ncol = 1)
  )
})


test_that("Case for page_by", {
  tbl0 <- iris[c(1:2, 51:52), ] |>
    rtf_body(
      page_by = c("Species")
    )

  expect_identical(
    data.frame(attributes(tbl0)$rtf_pageby_row),
    data.frame(x = unique(tbl0$Species))
  )
})


test_that("Case for using subline_by and page_by together", {
  tbl1 <- iris[c(1:4, 51:54), 3:5] |>
    mutate(s2 = paste0(Species, 1:2), s3 = s2) |>
    arrange(Species, s2) |>
    rtf_body(
      subline_by = "Species",
      page_by = "s2"
    )

  expect_identical(
    data.frame(attributes(tbl1)$rtf_by_subline_row),
    data.frame(x = unique(tbl1$Species))
  )

  expect_identical(
    data.frame(attributes(tbl1)$rtf_pageby_row),
    data.frame(x = unique(tbl1$s2))
  )

  expect_identical(
    attr(attr(tbl1, "rtf_by_subline_row"), "border_top"),
    matrix("", nrow = 2, ncol = 1)
  )

  expect_identical(
    attributes(attr(tbl1, "rtf_by_subline_row"))$border_bottom,
    matrix("", nrow = 2, ncol = 1)
  )
})

test_that("Case for using subline_by and page_by with pageby_row = 'first_row'", {
  tbl2 <- iris[c(1:4, 51:54), 3:5] |>
    mutate(s2 = paste0(Species, 1:2), s3 = s2) |>
    arrange(Species, s2) |>
    rtf_body(
      subline_by = "Species",
      page_by = "s2",
      pageby_row = "first_row"
    )

  pageby_exp <- data.frame(tbl2[c(1, 3, 5, 7), c(1:2, 5)])
  colnames(pageby_exp) <- paste("s2", colnames(pageby_exp), sep = ".")

  expect_identical(
    data.frame(attributes(tbl2)$rtf_by_subline_row),
    data.frame(x = unique(tbl2$Species))
  )

  expect_identical(
    data.frame(attributes(tbl2)$rtf_pageby_row),
    pageby_exp
  )

  expect_identical(
    attr(attr(tbl2, "rtf_by_subline_row"), "border_top"),
    matrix("", nrow = 2, ncol = 1)
  )

  expect_identical(
    attributes(attr(tbl2, "rtf_by_subline_row"))$border_bottom,
    matrix("", nrow = 2, ncol = 1)
  )
})
