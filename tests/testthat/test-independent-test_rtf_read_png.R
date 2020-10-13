context("Independent testing for rtf_read_png.R")

#create temporary plots for testing
options(bitmapType='cairo')
png(filename =  file.path(tempdir(), "plot1.png"))
df <- rnorm(300, 1, 2)
plot(df)
dev.off()

png(filename = file.path(tempdir(), "plot2.png"))
x <- seq(-10,10,1)
options(bitmapType='cairo')
plot(x, (x*2))
dev.off()

test_that("read in PNG file in binary format", {
  df <- file.path(tempdir(), c("plot1.png", "plot2.png"))

  file_png_1 <- df[1]
  file_png_2 <- df[2]

  file_png_vec <- c(file_png_1, file_png_2)
  png_vec_in <-rtf_read_png(file_png_vec)

  png_in_1 <- readBin(file_png_1, what="raw", size=1, signed = TRUE, endian = "little", n = 1e8)
  png_in_2 <- readBin(file_png_2, what="raw", size=1, signed = TRUE, endian = "little", n = 1e8)

  png_lst <- list(png_in_1, png_in_2)

  expect_equal(png_vec_in, png_lst)
 })
