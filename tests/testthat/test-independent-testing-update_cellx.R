file <- file.path(tempdir(), "tmp.rtf")

iris[1:2, 1:2] |>
  rtf_body() |>
  rtf_encode() |>
  write_rtf(file)

x <- readLines(file)

x[25] <- gsub("4500", "4501", x[25])
x[37] <- gsub("4500", "4502", x[37])
x[32] <- gsub("9000", "9001", x[32])

y <- update_cellx(x)

test_that("border twips were updated to maxinum as expected", {
  expect_equal(sum(grepl("cellx4502", y[25]), grepl("cellx4502", y[31]), grepl("cellx4502", y[37]), grepl("cellx9001", y[32])), 4)
})


test_that("attribute was updated with correct maximum twip", {
  expect_equal(attr(y, "max_twip"), max(as.numeric(gsub("cellx", "", unique(unlist(regmatches(x, gregexpr("cellx([0-9]+)", x))))))))
})
