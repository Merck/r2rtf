context("Independent testing for as_rtf_pageby.R")

library(dplyr)

test_that("Test for case when output has title, footnote and source", {

   x <- iris[1:2, ] %>%
        rtf_title("Title") %>%
        rtf_footnote("Footnote") %>%
        rtf_source("DataSource") %>%
        rtf_body() %>%
        rtf_pageby(page_by="Species", new_page = TRUE, pageby_header = TRUE ) %>%
        as_rtf_pageby()

   attr(x, "info") <- NULL

   y <- c("\\trowd\\trgaph108\\trleft0\\trqc\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrw15\\clbrdrr\\brdrs\\brdrw15\\clbrdrb\\brdrw15\\cellx9000\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 setosa}\\cell\n\\intbl\\row\\pard",
          "\\trowd\\trgaph108\\trleft0\\trqc\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrs\\brdrw15\\clbrdrb\\brdrw15\\cellx2250\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrs\\brdrw15\\clbrdrb\\brdrw15\\cellx4500\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrs\\brdrw15\\clbrdrb\\brdrw15\\cellx6750\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrs\\brdrw15\\clbrdrr\\brdrs\\brdrw15\\clbrdrb\\brdrw15\\cellx9000\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 5.1}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 3.5}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 1.4}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 0.2}\\cell\n\\intbl\\row\\pard",
          "\\trowd\\trgaph108\\trleft0\\trqc\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrw15\\clbrdrb\\brdrs\\brdrw15\\cellx2250\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrw15\\clbrdrb\\brdrs\\brdrw15\\cellx4500\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrw15\\clbrdrb\\brdrs\\brdrw15\\cellx6750\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrw15\\clbrdrr\\brdrs\\brdrw15\\clbrdrb\\brdrs\\brdrw15\\cellx9000\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 4.9}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 3}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 1.4}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 0.2}\\cell\n\\intbl\\row\\pard")

   expect_equal(x, y)

})

test_that("Test the pageby rows are the last rows of a page", {

  x <- iris %>%
    rtf_title("Title") %>%
    rtf_footnote("Footnote") %>%
    rtf_source("DataSource") %>%
    rtf_body() %>%
    rtf_pageby(page_by="Species", new_page = TRUE, pageby_header = FALSE )

  y <- as.data.frame(attributes(as_rtf_pageby(x))) %>%
       group_by(info.id) %>%
       summarise_all(last) %>%
       mutate(row = substr(as.character(info.page),1,1))

  z <- as.data.frame(table(x$Species)) %>%
       mutate(cu = cumsum(Freq))
  z <- z %>%mutate(cum = cu + as.numeric(rownames(z)))

  expect_equal(y$row, rownames(y))
  expect_equal(y$info.index, z$cum)
  expect_false(all(y$info.pageby))

})

test_that("Test if border type/color for first/last row are assigned correctly", {

   x <- iris[1:2, ] %>%
        rtf_body(border_first = c("single","dash", "dot","triple", ""),
                 border_last  = c("single","dash", "dot","triple", ""),

                 border_color_top = c("black","gold", "ivory", "blue", "white"),
                 border_color_bottom = c("black","gold", "ivory", "blue", "white"),

                 border_color_first = c("azure","gold", "ivory", "bisque", "white"),
                 border_color_last  = c("red","gold", "ivory", "bisque", "white")) %>%
        rtf_pageby(page_by="Species", new_page = TRUE, pageby_header = TRUE ) %>%
        as_rtf_pageby()

   attr(x, "info") <- NULL

   y <- c("\\trowd\\trgaph108\\trleft0\\trqc\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrw15\\brdrcf2\\clbrdrr\\brdrs\\brdrw15\\clbrdrb\\brdrw15\\brdrcf2\\cellx9000\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 setosa}\\cell\n\\intbl\\row\\pard"
          ,"\\trowd\\trgaph108\\trleft0\\trqc\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrs\\brdrw15\\brdrcf14\\clbrdrb\\brdrw15\\brdrcf25\\cellx2250\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrdash\\brdrw15\\brdrcf143\\clbrdrb\\brdrw15\\brdrcf143\\cellx4500\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrdot\\brdrw15\\brdrcf378\\clbrdrb\\brdrw15\\brdrcf378\\cellx6750\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrtriple\\brdrw15\\brdrcf20\\clbrdrr\\brdrs\\brdrw15\\clbrdrb\\brdrw15\\brdrcf27\\cellx9000\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 5.1}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 3.5}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 1.4}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 0.2}\\cell\n\\intbl\\row\\pard"
          ,"\\trowd\\trgaph108\\trleft0\\trqc\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrw15\\brdrcf25\\clbrdrb\\brdrs\\brdrw15\\brdrcf553\\cellx2250\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrw15\\brdrcf143\\clbrdrb\\brdrdash\\brdrw15\\brdrcf143\\cellx4500\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrw15\\brdrcf378\\clbrdrb\\brdrdot\\brdrw15\\brdrcf378\\cellx6750\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrw15\\brdrcf27\\clbrdrr\\brdrs\\brdrw15\\clbrdrb\\brdrtriple\\brdrw15\\brdrcf20\\cellx9000\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 4.9}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 3}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 1.4}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 0.2}\\cell\n\\intbl\\row\\pard"
   )
   expect_equal(x, y)
})

test_that("Test if page_dict attribute is created for tbl", {

  x <- iris %>%
       rtf_body() %>%
       rtf_pageby(page_by="Species", new_page = TRUE, pageby_header = FALSE )

  y <- as_rtf_pageby(x)

  expect_equal(names(attributes(y)), "info")

  expect_output(str(y), "id    : Factor")
  expect_output(str(y), "pageby: logi")
  expect_output(str(y), "nrow  : num")
  expect_output(str(y), "total : num")
  expect_output(str(y), "page  : num")
  expect_output(str(y), "index : int")

})
