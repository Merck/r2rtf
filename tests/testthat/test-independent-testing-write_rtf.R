test_that("Write function test for simple text and dataset", {

  a <- "Just a random Text and Symbols.!@#$%^&*()[],:; \ <>"
  write_rtf(a, file = file.path(tempdir(), "tabel.rtf"))
  b <- paste(readLines(file.path(tempdir(), "tabel.rtf")), collapse = "\n")

  x <- head(iris) %>%
       rtf_body() %>%
       rtf_encode()
  write_rtf(x, file = file.path(tempdir(), "tabel.rtf"))
  y <- paste(readLines(file.path(tempdir(), "tabel.rtf")), collapse = "\n")

  expect_equal(paste(unlist(a), collapse = "\n"), b )
  expect_equal(paste(unlist(x), collapse = "\n"), y )

})

test_that("Write function test for simple text", {

  a <- "Just a random Text and Symbols.!@#$%^&*()[],:; \ <>"
  write_rtf_para(a, file = file.path(tempdir(), "tabel.rtf"))
  b <- paste(readLines(file.path(tempdir(), "tabel.rtf")), collapse = "\n")

  cl <- color_table()
  rt_cl <- paste(c("{\\colortbl; ", cl$rtf_code, "}"), collapse = "\n")
  st_rt <- paste(as_rtf_init(),as_rtf_font(), rt_cl,sep = "\n")
  c <- paste(st_rt, "{\\pard \\par}", paste(a, collapse = ""), as_rtf_end(), sep = "\n")

  expect_equal(b, c)

})

test_that("Write function test for dataset input", {

  x <- head(iris) %>% rtf_body() %>%  rtf_encode()
  write_rtf_para(x, file = file.path(tempdir(), "tabel.rtf"))
  y <- paste(readLines(file.path(tempdir(), "tabel.rtf")), collapse = "\n")

  cl <- color_table()
  rt_cl <- paste(c("{\\colortbl; ", cl$rtf_code, "}"), collapse = "\n")
  st_rt <- paste(as_rtf_init(),as_rtf_font(), rt_cl,sep = "\n")
  z <- paste(st_rt, "{\\pard \\par}", paste(x, collapse = ""), as_rtf_end(), sep = "\n")

  expect_equal(y, z)

})


