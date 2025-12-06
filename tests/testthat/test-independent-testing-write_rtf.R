test_that("Write function test for simple text and dataset", {
  a <- "Just a random Text and Symbols.!@#$%^&*()[],:; \ <>"
  write_rtf(a, file = file.path(tempdir(), "tabel.rtf"))
  b <- paste(readLines(file.path(tempdir(), "tabel.rtf")), collapse = "\n")

  x <- head(iris) |>
    rtf_body() |>
    rtf_encode()
  write_rtf(x, file = file.path(tempdir(), "tabel.rtf"))
  y <- paste(readLines(file.path(tempdir(), "tabel.rtf")), collapse = "\n")

  expect_equal(paste(unlist(a), collapse = "\n"), b)
  expect_equal(paste(unlist(x), collapse = "\n"), y)
})

test_that("Write function test for simple text", {
  a <- "Just a random Text and Symbols.!@#$%^&*()[],:; \ <>"
  write_rtf_para(a, file = file.path(tempdir(), "tabel.rtf"))
  b <- paste(readLines(file.path(tempdir(), "tabel.rtf")), collapse = "\n")

  cl <- color_table()
  rt_cl <- paste(c("{\\colortbl\n;", cl$rtf_code, "}"), collapse = "\n")
  st_rt <- paste(as_rtf_init(), as_rtf_font(), rt_cl, sep = "\n")
  c <- paste(st_rt, "{\\pard \\par}", paste(a, collapse = ""), as_rtf_end(), sep = "\n")

  expect_equal(b, c)
})

test_that("Write function test for dataset input", {
  x <- head(iris) |>
    rtf_body() |>
    rtf_encode()
  write_rtf_para(x, file = file.path(tempdir(), "tabel.rtf"))
  y <- paste(readLines(file.path(tempdir(), "tabel.rtf")), collapse = "\n")

  cl <- color_table()
  rt_cl <- paste(c("{\\colortbl\n;", cl$rtf_code, "}"), collapse = "\n")
  st_rt <- paste(as_rtf_init(), as_rtf_font(), rt_cl, sep = "\n")
  z <- paste(st_rt, "{\\pard \\par}", paste(x, collapse = ""), as_rtf_end(), sep = "\n")

  expect_equal(y, z)
})

test_that("write_docx creates DOCX file from RTF encoding", {
  skip_on_os("windows") # rtf_convert_format only supports Unix/Linux/macOS
  skip_if_not(
    nzchar(Sys.which("libreoffice")) ||
      nzchar(Sys.which("libreoffice24.8")) ||
      nzchar(Sys.which("libreoffice7.6")),
    "LibreOffice is not installed"
  )

  # Create RTF encoding
  rtf <- head(iris) |>
    rtf_body() |>
    rtf_encode()

  # Write to DOCX
  docx_file <- file.path(tempdir(), "test_table.docx")
  result <- write_docx(rtf, docx_file)

  # Verify file was created
  expect_true(file.exists(docx_file))
  expect_equal(result, docx_file)

  # Clean up
  unlink(docx_file)
})

test_that("write_docx creates output directory if needed", {
  skip_on_os("windows") # rtf_convert_format only supports Unix/Linux/macOS
  skip_if_not(
    nzchar(Sys.which("libreoffice")) ||
      nzchar(Sys.which("libreoffice24.8")) ||
      nzchar(Sys.which("libreoffice7.6")),
    "LibreOffice is not installed"
  )

  # Create RTF encoding
  rtf <- head(cars) |>
    rtf_body() |>
    rtf_encode()

  # Create nested path
  nested_path <- file.path(tempdir(), "test_output_dir", "nested", "test.docx")

  # Write to DOCX
  result <- write_docx(rtf, nested_path)

  # Verify directory and file were created
  expect_true(dir.exists(dirname(nested_path)))
  expect_true(file.exists(nested_path))

  # Clean up
  unlink(file.path(tempdir(), "test_output_dir"), recursive = TRUE)
})

test_that("write_docx fails gracefully when LibreOffice is not available", {
  skip_on_os("windows") # rtf_convert_format only supports Unix/Linux/macOS
  skip_if(
    nzchar(Sys.which("libreoffice")) ||
      nzchar(Sys.which("libreoffice24.8")) ||
      nzchar(Sys.which("libreoffice7.6")),
    "Skip if LibreOffice IS installed"
  )

  rtf <- head(iris) |>
    rtf_body() |>
    rtf_encode()

  expect_error(
    write_docx(rtf, file.path(tempdir(), "test.docx")),
    "Can't find libreoffice"
  )
})
