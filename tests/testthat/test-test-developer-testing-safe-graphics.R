test_that("Running graphics functions within with_bmp() does not affect graphics device", {
  dev_cur <- grDevices::dev.cur()

  with_bmp(par("mar"))
  safe_par("font")
  safe_strwidth("Hello world!", units = "inches", cex = 1, font = 1, family = "sans")

  expect_equal(grDevices::dev.cur(), dev_cur)
})
