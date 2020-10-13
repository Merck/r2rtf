context("Independent testing for rtf_encode.R")

##create temporary dataset to run the testing
data1 <- iris[1:2,]
data2 <- data1 %>% rtf_body ()

test_that("Test if type input is not table or figure", {
  expect_error(data2 %>%  rtf_encode(type = "plot")  )
})

test_that("Test if title/footnote/source input is not first, all, last", {
  expect_error(data2 %>%  rtf_encode(page_title = "middle")  )
  expect_error(data2 %>%  rtf_encode(page_footnote = "firstlast")  )
  expect_error(data2 %>%  rtf_encode(page_source = "ALL")  )
})

test_that("Test if content is converted to RTF correctly when tbl class is list", {
    x <- data.frame(1) %>% rtf_body()
    y <- data.frame(1) %>% rtf_body()
    z <- list(x, y)
    encode = "{\\rtf1\\ansi\n\\deff0\\deflang1033\n{\\fonttbl{\\f0\\froman\\fcharset161\\fprq2 Times New Roman;}\n{\\f166\\froman\\fcharset161\\fprq2 Times New Roman Greek;}\n{\\f266\\fswiss\\fcharset161\\fprq2 Arial Greek;}\n}\n\n\n\\paperw12240\\paperh15840\n\n\\margl1800\\margr1440\\margt2520\\margb1800\\headery2520\\footery1449\n\n\n\n\\trowd\\trgaph108\\trleft0\\trqc\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrs\\brdrw15\\clbrdrr\\brdrs\\brdrw15\\cellx9000\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 X1}\\cell\n\\intbl\\row\\pard\n\\trowd\\trgaph108\\trleft0\\trqc\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrs\\brdrw15\\clbrdrr\\brdrs\\brdrw15\\clbrdrb\\brdrs\\brdrw15\\cellx9000\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 1}\\cell\n\\intbl\\row\\pard\n\\trowd\\trgaph108\\trleft0\\trqc\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrs\\brdrw15\\clbrdrr\\brdrs\\brdrw15\\cellx9000\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 X1}\\cell\n\\intbl\\row\\pard\n\\trowd\\trgaph108\\trleft0\\trqc\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrs\\brdrw15\\clbrdrr\\brdrs\\brdrw15\\clbrdrb\\brdrs\\brdrw15\\cellx9000\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 1}\\cell\n\\intbl\\row\\pard\n\n\n}"
      expect_equal(encode, paste(unlist(rtf_encode(z, type = "table")), collapse = "\n"))

})

test_that("Test if content is converted to RTF correctly when tbl class is data.frame", {
  expect_equal(paste(unlist(rtf_encode(data2, type = "table")), collapse = "\n"), "{\\rtf1\\ansi\n\\deff0\\deflang1033\n{\\fonttbl{\\f0\\froman\\fcharset161\\fprq2 Times New Roman;}\n{\\f166\\froman\\fcharset161\\fprq2 Times New Roman Greek;}\n{\\f266\\fswiss\\fcharset161\\fprq2 Arial Greek;}\n}\n\n\n\\paperw12240\\paperh15840\n\n\\margl1800\\margr1440\\margt2520\\margb1800\\headery2520\\footery1449\n\n\n\n\\trowd\\trgaph108\\trleft0\\trqc\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrdb\\brdrw15\\cellx1800\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrdb\\brdrw15\\cellx3600\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrdb\\brdrw15\\cellx5400\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrdb\\brdrw15\\cellx7200\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrdb\\brdrw15\\clbrdrr\\brdrs\\brdrw15\\cellx9000\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 Sepal.Length}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 Sepal.Width}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 Petal.Length}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 Petal.Width}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 Species}\\cell\n\\intbl\\row\\pard\n\\trowd\\trgaph108\\trleft0\\trqc\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrs\\brdrw15\\clbrdrb\\brdrw15\\cellx1800\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrs\\brdrw15\\clbrdrb\\brdrw15\\cellx3600\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrs\\brdrw15\\clbrdrb\\brdrw15\\cellx5400\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrs\\brdrw15\\clbrdrb\\brdrw15\\cellx7200\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrs\\brdrw15\\clbrdrr\\brdrs\\brdrw15\\clbrdrb\\brdrw15\\cellx9000\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 5.1}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 3.5}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 1.4}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 0.2}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 setosa}\\cell\n\\intbl\\row\\pard\n\\trowd\\trgaph108\\trleft0\\trqc\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrw15\\clbrdrb\\brdrdb\\brdrw15\\cellx1800\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrw15\\clbrdrb\\brdrdb\\brdrw15\\cellx3600\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrw15\\clbrdrb\\brdrdb\\brdrw15\\cellx5400\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrw15\\clbrdrb\\brdrdb\\brdrw15\\cellx7200\n\\clbrdrl\\brdrs\\brdrw15\\clbrdrt\\brdrw15\\clbrdrr\\brdrs\\brdrw15\\clbrdrb\\brdrdb\\brdrw15\\cellx9000\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 4.9}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 3}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 1.4}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 0.2}\\cell\n\\pard\\intbl\\sb15\\sa15\\qc{\\f0\\fs18 setosa}\\cell\n\\intbl\\row\\pard\n\n\n\n}")
})


#create temporary png file

df <- data.frame(x = c(1:30), y = c(1:30))
library(ggplot2)
options(bitmapType='cairo')

df %>% ggplot(aes(x, y)) + geom_point()

file_out <- tempfile()
ggsave(file_out, device = "png")

tbl <- rtf_read_png(file_out)  %>% rtf_figure()
tbl2 <- tbl %>%  rtf_title("This is the title") %>% rtf_footnote("This is a footnote")
tbl3 <- tbl2 %>%  rtf_encode(type = "figure")


test_that("Test if content is converted to RTF correctly when type is figure", {
  expect_true(grep("{\\rtf1\\ansi\n\\deff0\\", tbl3,fixed=TRUE) == 1)
})
