test_that("Case in defalut", {

  x <- iris[1:1,] %>%
       dplyr::select(1) %>%
       rtf_body() %>%
       as_rtf_table() %>%
       strsplit("\n")

  y <-c("\\trowd\\trgaph108\\trleft0\\trqc",
                    "\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrs\\brdrw15\\clbrdrr\\brdrs\\brdrw15\\clbrdrb\\brdrs\\brdrw15\\cellx9000",
                    "\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 5.1}\\cell" ,
                    "\\intbl\\row\\pard")
  expect_equal(x[[1]], y)

})

test_that("Case for border_color_left and border_color_top", {
  x <- iris[1:1,] %>% dplyr::select(1) %>%
        rtf_body(border_color_left='red', border_color_top='blue') %>%
        as_rtf_table() %>%
        strsplit("\n")

  y <-c("\\trowd\\trgaph108\\trleft0\\trqc" ,
                     "\\clbrdrl\\brdrs\\brdrw15\\brdrcf553\\clbrdrt\\brdrs\\brdrw15\\brdrcf27\\clbrdrr\\brdrs\\brdrw15\\clbrdrb\\brdrs\\brdrw15\\cellx9000",
                     "\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 5.1}\\cell",
                     "\\intbl\\row\\pard")
  expect_equal(x[[1]], y)

})




