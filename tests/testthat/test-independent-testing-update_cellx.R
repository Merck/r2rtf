file <- file.path(tempdir(), "tmp.rtf")

iris[1:2, 1:2] |>
  rtf_body() |>
  rtf_encode() |>
  write_rtf(file)

x <- readLines(file)

x[24] <- gsub("4500", "4501", x[24])
x[36] <- gsub("4500", "4502", x[36])
x[31] <- gsub("9000", "9001", x[31])

y <- update_cellx(x)

test_that("border twips were updated to maxinum as expected", {
  expect_equal(sum(grepl("cellx4502", y[24]), grepl("cellx4502", y[30]), grepl("cellx4502", y[36]), grepl("cellx9001", y[31])), 4)
})


test_that("attribute was updated with correct maximum twip", {
  expect_equal(attr(y, "max_twip"), max(as.numeric(gsub("cellx", "", unique(unlist(regmatches(x, gregexpr("cellx([0-9]+)", x))))))))
})
