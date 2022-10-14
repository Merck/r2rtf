# test bulletproofing

test_that("rtf_assemble: bulletproofing argument landscape", {
  withr::with_tempdir({
    a <- "Just a random Text and Symbols.!@#$%^&*()[],:; \ <>"
    write_rtf(a, file = "table1.rtf")
    b <- "Just a random Text and Symbols.!@#$%^&*()[],:; \ <>"
    write_rtf(b, file = "table2.rtf")

    expect_error(rtf_assemble(input = dir(pattern = "table"),
      output = "tmp",
      landscape = "yes"),
      regexp = "Landscape argument must be of type 'logical'.")
    expect_error(rtf_assemble(input = dir(pattern = "table"),
      output = "tmp",
      landscape = c(TRUE, TRUE, FALSE)),
      regexp = "Landscape argument is length")

  })
})

test_that("rtf_assemble: bulletproofing argument input", {
  withr::with_tempdir({
    expect_error(rtf_assemble(input = c(TRUE, TRUE), output = "tmp"),
      regexp = "Input argument must be of type 'character'.")
  })
})

test_that("rtf_assemble: bulletproofing argument output", {
  withr::with_tempdir({
    a <- "Just a random Text and Symbols.!@#$%^&*()[],:; \ <>"
    write_rtf(a, file = "table1.rtf")
    b <- "Just a random Text and Symbols.!@#$%^&*()[],:; \ <>"
    write_rtf(b, file = "table2.rtf")

    expect_error(rtf_assemble(input = dir(pattern = "table"), output = TRUE),
      regexp = "Output argument must be of type 'character'.")
  })
})

test_that("rtf_assemble: bulletproofing argument use_officer", {
  withr::with_tempdir({
    a <- "Just a random Text and Symbols.!@#$%^&*()[],:; \ <>"
    write_rtf(a, file = "table1.rtf")
    b <- "Just a random Text and Symbols.!@#$%^&*()[],:; \ <>"
    write_rtf(b, file = "table2.rtf")

    expect_error(rtf_assemble(input = dir(pattern = "table"), output = "tmp",
      use_officer = "yes"),
      regexp = "Use_officer argument must be of type 'logical'.")
  })
})

# test functionality without officer
test_that("rtf_assemble: output without using officer", {
  withr::with_tempdir({
    a <- "A: Just a random Text and Symbols.!@#$%^&*()[],:; \ <>"
    write_rtf(a, file = "table1.rtf")
    b <- "B: Just a random Text and Symbols.!@#$%^&*()[],:; \ <>"
    write_rtf(b, file = "table2.rtf")

    expect_message(rtf_path <- rtf_assemble(input = dir(pattern = "table"),
      output = "tmp_rtf",
      use_officer = FALSE), regexp = "page orientation will be ignored.")

    expect_equal(rtf_path, "tmp_rtf.rtf")
    expect_true(rtf_path %in% dir())

    tmp_rtf <- paste(readLines(rtf_path), collapse = "\n")

    expect_true(
      all(c(grepl(tmp_rtf, pattern = "A: Just a random Text"),
        grepl(tmp_rtf, pattern = "B: Just a random Text"))))
  })
})

# test functionality with officer
if (require(officer, quietly = TRUE)){
  test_that("rtf_assemble: output with using officer", {

    withr::with_tempdir({
      a <- "A: Just a random Text and Symbols.!@#$%^&*()[],:; \ <>"
      write_rtf(a, file = "table1.rtf")
      b <- "B: Just a random Text and Symbols.!@#$%^&*()[],:; \ <>"
      write_rtf(b, file = "table2.rtf")

      expect_message(rtf_path <- rtf_assemble(input = dir(pattern = "table"),
        output = "tmp_docx",
        use_officer = TRUE),
        regexp = "Appending rtf files into a '.docx'")

      expect_equal(rtf_path, "tmp_docx.docx")
      expect_true(rtf_path %in% dir())

      # Need to read in and expose document text for our test
      tmp_docx <- docx_summary(officer::read_docx(rtf_path))

      # Need to check if both "table seq table" texts are in the docx file.
      expect_equal(grepl("Table SEQ Table", tmp_docx$text),
        c(TRUE, FALSE, TRUE, FALSE))


    })
  })
}
