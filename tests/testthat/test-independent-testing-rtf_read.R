test_that("read in PNG file in binary format", {
  df <- c("fig/fig1.png", "fig/fig2.png")

  file_png_1 <- df[1]
  file_png_2 <- df[2]

  file_png_vec <- c(file_png_1, file_png_2)
  png_vec_in <- rtf_read_figure(file_png_vec)

  png_in_1 <- readBin(file_png_1, what = "raw", size = 1, signed = TRUE, endian = "little", n = 1e8)
  png_in_2 <- readBin(file_png_2, what = "raw", size = 1, signed = TRUE, endian = "little", n = 1e8)

  png_lst <- list(png_in_1, png_in_2)

  expect_equal(png_vec_in, png_lst)
})
