context("Independent testing for rtf_read_png.R")

test_that("read in PNG file in binary format", {
  file_png_1 <- "https://lctcvp7236.merck.com:3838/content/26/images/r_version.png"
  file_png_2 <- "https://lctcvp7236.merck.com:3838/content/26/images/Jira_import_issues.PNG"

  file_png_vec <- c(file_png_1, file_png_2)
  png_vec_in <-rtf_read_png(file_png_vec)

  png_in_1 <- readBin(file_png_1, what="raw", size=1, signed = TRUE, endian = "little", n = 1e8)
  png_in_2 <- readBin(file_png_2, what="raw", size=1, signed = TRUE, endian = "little", n = 1e8)

  png_lst <- list(png_in_1, png_in_2)

  expect_equal(png_vec_in, png_lst)
 })
