test_that("read in PNG file in binary format", {
  df <- c("fig/fig1.png", "fig/fig2.png")
  png_vec_in <- rtf_read_figure(df)

  png_in_1 <- readBin(df[1], what = "raw", size = 1, signed = TRUE, endian = "little", n = 1e8)
  png_in_2 <- readBin(df[2], what = "raw", size = 1, signed = TRUE, endian = "little", n = 1e8)

  png_lst <- list(png_in_1, png_in_2)
  attr(png_vec_in, "fig_format") <- NULL

  expect_equal(png_vec_in, png_lst)
})
