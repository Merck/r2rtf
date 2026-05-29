# =============================================================================
# Unit tests for rtf_span_row
# =============================================================================

# --- rtf_span_row() function tests ---

test_that("rtf_span_row sets attribute with logical vector", {
  tbl <- iris[1:5, ] |> rtf_body()
  result <- rtf_span_row(tbl, span_row = c(TRUE, FALSE, FALSE, TRUE, FALSE))
  expect_equal(attr(result, "rtf_span_row"), c(TRUE, FALSE, FALSE, TRUE, FALSE))
})

test_that("rtf_span_row sets attribute with integer indices", {
  tbl <- iris[1:5, ] |> rtf_body()
  result <- rtf_span_row(tbl, span_row = c(1L, 4L))
  expect_equal(attr(result, "rtf_span_row"), c(TRUE, FALSE, FALSE, TRUE, FALSE))
})

test_that("rtf_span_row errors on wrong length", {
  tbl <- iris[1:5, ] |> rtf_body()
  expect_error(rtf_span_row(tbl, span_row = c(TRUE, FALSE)))
})

test_that("rtf_span_row errors when called before rtf_body", {
  expect_error(rtf_span_row(iris[1:5, ], span_row = c(TRUE, FALSE, FALSE, TRUE, FALSE)))
})

test_that("rtf_span_row errors on out-of-range indices", {
  tbl <- iris[1:5, ] |> rtf_body()
  expect_error(rtf_span_row(tbl, span_row = c(0L, 6L)))
})

test_that("rtf_span_row errors on non-logical non-integer input", {

  tbl <- iris[1:5, ] |> rtf_body()
  expect_error(rtf_span_row(tbl, span_row = "row1"))
})


# --- rtf_table_content() with span ---

test_that("rtf_table_content emits clmgf and clmrg for span rows", {
  tbl <- iris[1:3, ] |> rtf_body() |> rtf_span_row(span_row = c(TRUE, FALSE, FALSE))
  result <- rtf_table_content(tbl, use_border_bottom = TRUE)

  # result is a matrix; columns correspond to rows in the table
  # Row 1 (column 1 of result) should have \\clmgf and \\clmrg
  col1 <- paste(result[, 1], collapse = "\n")
  expect_true(grepl("\\\\clmgf", col1))
  expect_true(grepl("\\\\clmrg", col1))

  # Row 2 (column 2) should NOT have merge codes

  col2 <- paste(result[, 2], collapse = "\n")
  expect_false(grepl("\\\\clmgf", col2))
  expect_false(grepl("\\\\clmrg", col2))
})

test_that("rtf_table_content empties continuation cells for span rows", {
  tbl <- iris[1:3, ] |> rtf_body() |> rtf_span_row(span_row = c(TRUE, FALSE, FALSE))
  result <- rtf_table_content(tbl, use_border_bottom = TRUE)

  # For span row (column 1 of result matrix), continuation cells should be \\pard\\cell
  # The cell content rows start after row_begin + n_col border rows
  n_col <- ncol(iris)
  # Content for columns 2..n_col should be \\pard\\cell
  content_rows <- result[(1 + n_col + 2):(1 + n_col + n_col), 1]
  expect_true(all(content_rows == "\\pard\\cell"))
})

test_that("rtf_table_content first cell retains content for span rows", {
  tbl <- iris[1:3, ] |> rtf_body() |> rtf_span_row(span_row = c(TRUE, FALSE, FALSE))
  result <- rtf_table_content(tbl, use_border_bottom = TRUE)

  # First cell content (row after borders) should NOT be just \\pard\\cell
  n_col <- ncol(iris)
  first_cell_content <- result[1 + n_col + 1, 1]
  expect_false(first_cell_content == "\\pard\\cell")
  expect_true(grepl("5.1", first_cell_content))
})


# --- as_rtf_table() with span + group_by ---

test_that("as_rtf_table preserves span_row through group_by", {
  tbl <- iris[1:4, 4:5] |>
    rtf_body(group_by = "Species") |>
    rtf_span_row(span_row = c(TRUE, FALSE, FALSE, FALSE))

  result <- as_rtf_table(tbl)
  expect_true(grepl("\\\\clmgf", result[1]))
})


# --- rtf_subset() with span ---

test_that("rtf_subset subsets rtf_span_row attribute", {
  tbl <- iris[1:5, ] |>
    rtf_body() |>
    rtf_span_row(span_row = c(TRUE, FALSE, TRUE, FALSE, TRUE))

  sub <- rtf_subset(tbl, row = 2:4, col = 1:3)
  expect_equal(attr(sub, "rtf_span_row"), c(FALSE, TRUE, FALSE))
})


# --- End-to-end: rtf_encode with span ---

test_that("rtf_encode produces valid RTF with span rows", {
  tbl <- iris[1:3, ] |>
    rtf_body() |>
    rtf_span_row(span_row = c(TRUE, FALSE, FALSE)) |>
    rtf_encode()

  rtf_text <- paste(unlist(tbl), collapse = "\n")
  expect_true(grepl("\\\\clmgf", rtf_text))
  expect_true(grepl("\\\\clmrg", rtf_text))
})

test_that("rtf_encode without span_row produces no merge codes", {
  tbl <- iris[1:3, ] |>
    rtf_body() |>
    rtf_encode()

  rtf_text <- paste(unlist(tbl), collapse = "\n")
  expect_false(grepl("\\\\clmgf", rtf_text))
  expect_false(grepl("\\\\clmrg", rtf_text))
})


# --- Edge cases ---

test_that("single-column table with span_row does not error", {
  tbl <- data.frame(x = 1:3) |>
    rtf_body() |>
    rtf_span_row(span_row = c(TRUE, FALSE, FALSE))

  result <- rtf_table_content(tbl, use_border_bottom = TRUE)
  # Should not contain merge codes (only 1 column, merge is no-op)
  col1 <- paste(result[, 1], collapse = "\n")
  expect_false(grepl("\\\\clmgf", col1))
})

test_that("all rows as span rows works", {
  tbl <- iris[1:3, ] |>
    rtf_body() |>
    rtf_span_row(span_row = c(TRUE, TRUE, TRUE)) |>
    rtf_encode()

  rtf_text <- paste(unlist(tbl), collapse = "\n")
  expect_true(grepl("\\\\clmgf", rtf_text))
})

test_that("span_row on first and last rows works with border_first/last", {
  tbl <- iris[1:5, ] |>
    rtf_body(border_first = "single", border_last = "single") |>
    rtf_span_row(span_row = c(TRUE, FALSE, FALSE, FALSE, TRUE)) |>
    rtf_encode()

  rtf_text <- paste(unlist(tbl), collapse = "\n")
  expect_true(grepl("\\\\clmgf", rtf_text))
})
