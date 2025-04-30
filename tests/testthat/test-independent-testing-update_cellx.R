file <- file.path(tempdir(), "tmp.rtf")

iris[1:2, 1:2] |>
  rtf_body() |>
  rtf_encode() |>
  write_rtf(file)

x <- readLines(file)
y <- update_cellx(x)



test_that("attribute was updated with correct maximum twip", {
  expect_equal(attr(y, "max_twip"), max(as.numeric(gsub("cellx", "", unique(unlist(regmatches(x, gregexpr("cellx([0-9]+)", x))))))))
})
