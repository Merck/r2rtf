## create temporary dataset to run the testing
data1 <- iris[1:2, ]
data2 <- data1 |> rtf_body()

test_that("Test if type input is not table or figure", {
  expect_error(data2 |> rtf_encode(type = "plot"))
})

test_that("Test if title/footnote/source input is not first, all, last", {
  expect_error(data2 |> rtf_encode(page_title = "middle"))
  expect_error(data2 |> rtf_encode(page_footnote = "firstlast"))
  expect_error(data2 |> rtf_encode(page_source = "ALL"))
})

test_that("Test if content is converted to RTF correctly when tbl class is list", {
  x <- data.frame(1) |> rtf_body()
  y <- data.frame(1) |> rtf_body()
  z <- list(x, y)
  expect_snapshot_output(rtf_encode(z, doc_type = "table"))
})

test_that("Test if content is converted to RTF correctly when tbl class is data.frame", {
  expect_snapshot_output(rtf_encode(data2, doc_type = "table"))
})


tbl <- rtf_read_figure("fig/fig1.png") |> rtf_figure()
tbl2 <- tbl |>
  rtf_title("This is the title") |>
  rtf_footnote("This is a footnote")
tbl3 <- tbl2 |> rtf_encode(doc_type = "figure")


test_that("Test if content is converted to RTF correctly when type is figure", {
  expect_true(grep("{\\rtf1\\ansi\n\\deff0\\", tbl3, fixed = TRUE) == 1)
})
