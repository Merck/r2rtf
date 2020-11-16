test_that("Case when colheader equals to NULL", {

  x <- iris %>% rtf_colheader(colheader = "")
  expect_null(as_rtf_colheader(x))

  x <- iris %>% rtf_colheader(colheader = "", border_color_left="red")
  expect_null(as_rtf_colheader(x))

})

test_that("Case when colheader is not NULL and border color is specified", {

  x <- iris %>% rtf_colheader(colheader="a | b| c",border_color_left="green")
  y <-c("\\trowd\\trgaph108\\trleft0\\trqc",
        "\\clbrdrl\\brdrs\\brdrw15\\brdrcf255\\clbrdrt\\brdrs\\brdrw15\\cellx3000",
        "\\clbrdrl\\brdrs\\brdrw15\\brdrcf255\\clbrdrt\\brdrs\\brdrw15\\cellx6000",
        "\\clbrdrl\\brdrs\\brdrw15\\brdrcf255\\clbrdrt\\brdrs\\brdrw15\\clbrdrr\\brdrs\\brdrw15\\cellx9000",
        "\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 a}\\cell",
        "\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 b}\\cell",
        "\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 c}\\cell",
        "\\intbl\\row\\pard")
  expect_equal(as_rtf_colheader(x), y)

  x <- iris %>% rtf_colheader(colheader="a | b| c",border_color_left="red",border_color_right="red")
  y <- c("\\trowd\\trgaph108\\trleft0\\trqc",
         "\\clbrdrl\\brdrs\\brdrw15\\brdrcf553\\clbrdrt\\brdrs\\brdrw15\\cellx3000",
         "\\clbrdrl\\brdrs\\brdrw15\\brdrcf553\\clbrdrt\\brdrs\\brdrw15\\cellx6000",
         "\\clbrdrl\\brdrs\\brdrw15\\brdrcf553\\clbrdrt\\brdrs\\brdrw15\\clbrdrr\\brdrs\\brdrw15\\brdrcf553\\cellx9000",
         "\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 a}\\cell",
         "\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 b}\\cell",
         "\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 c}\\cell",
         "\\intbl\\row\\pard" )
  expect_equal(as_rtf_colheader(x), y)

})

test_that("case when colheader is not NULL and border type is specified", {

  x <- iris %>% rtf_colheader(colheader="a | b| c", border_right="double")
  y <-c("\\trowd\\trgaph108\\trleft0\\trqc",
        "\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrs\\brdrw15\\cellx3000",
        "\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrs\\brdrw15\\cellx6000",
        "\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrs\\brdrw15\\clbrdrr\\brdrdb\\brdrw15\\cellx9000",
        "\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 a}\\cell",
        "\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 b}\\cell",
        "\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 c}\\cell",
        "\\intbl\\row\\pard")
  expect_equal(as_rtf_colheader(x), y)

  x <- iris %>% rtf_colheader(colheader="a | b| c", border_top="dot dash")
  y <-c("\\trowd\\trgaph108\\trleft0\\trqc",
        "\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrdashd\\brdrw15\\cellx3000",
        "\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrdashd\\brdrw15\\cellx6000",
        "\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrdashd\\brdrw15\\clbrdrr\\brdrs\\brdrw15\\cellx9000",
        "\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 a}\\cell",
        "\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 b}\\cell",
        "\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 c}\\cell",
        "\\intbl\\row\\pard")
  expect_equal(as_rtf_colheader(x), y)

})

test_that("case when colheader is not NULL and cell text formats is specified", {

  x <- iris %>% rtf_colheader(colheader="a | b| c", text_format="i")
  y <- c("\\trowd\\trgaph108\\trleft0\\trqc",
         "\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrs\\brdrw15\\cellx3000",
         "\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrs\\brdrw15\\cellx6000",
         "\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrs\\brdrw15\\clbrdrr\\brdrs\\brdrw15\\cellx9000",
         "\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18\\i a}\\cell",
         "\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18\\i b}\\cell",
         "\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18\\i c}\\cell",
         "\\intbl\\row\\pard")
  expect_equal(as_rtf_colheader(x), y)

  x <- iris %>% rtf_colheader(colheader="a | b| c", text_format="b")
  y <- c("\\trowd\\trgaph108\\trleft0\\trqc",
         "\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrs\\brdrw15\\cellx3000",
         "\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrs\\brdrw15\\cellx6000",
         "\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrs\\brdrw15\\clbrdrr\\brdrs\\brdrw15\\cellx9000",
         "\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18\\b a}\\cell",
         "\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18\\b b}\\cell",
         "\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18\\b c}\\cell",
         "\\intbl\\row\\pard")
  expect_equal(as_rtf_colheader(x), y)

})


