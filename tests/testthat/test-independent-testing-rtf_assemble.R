# test bulletproofing

test_that("rtf_assemble: bulletproofing argument landscape", {

  withr::with_tempdir({
    a <- "Just a random Text and Symbols.!@#$%^&*()[],:; \ <>"
    write_rtf(a, file = "table1.rtf")
    b <- "Just a random Text and Symbols.!@#$%^&*()[],:; \ <>"
    write_rtf(b, file = "table2.rtf")

    expect_error(rtf_assemble(input = dir(pattern = "table"),
                              output = "tmp.rtf",
                              landscape = "yes",
                              use_officer = FALSE))

    expect_error(rtf_assemble(input = dir(pattern = "table"),
                              output = "tmp.docx",
                              landscape = c(TRUE, TRUE, FALSE),
                              use_officer = TRUE))

  })
})

test_that("rtf_assemble: bulletproofing argument input", {

  withr::with_tempdir({
    expect_error(rtf_assemble(input = c(TRUE, TRUE), output = "tmp"))
  })

})

test_that("rtf_assemble: bulletproofing argument output", {
  withr::with_tempdir({
    a <- "Just a random Text and Symbols.!@#$%^&*()[],:; \ <>"
    write_rtf(a, file = "table1.rtf")
    b <- "Just a random Text and Symbols.!@#$%^&*()[],:; \ <>"
    write_rtf(b, file = "table2.rtf")

    expect_error(rtf_assemble(input = dir(pattern = "table"), output = TRUE))
  })
})

test_that("rtf_assemble: bulletproofing argument use_officer", {
  withr::with_tempdir({
    a <- "Just a random Text and Symbols.!@#$%^&*()[],:; \ <>"
    write_rtf(a, file = "table1.rtf")
    b <- "Just a random Text and Symbols.!@#$%^&*()[],:; \ <>"
    write_rtf(b, file = "table2.rtf")

    expect_error(rtf_assemble(input = dir(pattern = "table"), output = "tmp",
                 use_officer = "yes"))
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
      output = "tmp.rtf",
      use_officer = FALSE), regexp = "without using `officer` package.")

    expect_equal(rtf_path, "tmp.rtf")
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
                                              output = "tmp.docx",
                                              use_officer = TRUE),
        regexp = "'.docx' file using `officer` package.")

      expect_equal(rtf_path, "tmp.docx")
      expect_true(rtf_path %in% dir())

      # Need to read in and expose document text for our test
      tmp_docx <- officer::docx_summary(officer::read_docx(rtf_path))

      # Need to check if both "table seq table" texts are in the docx file.
      expect_equal(grepl("Table SEQ Table", tmp_docx$text),
        c(TRUE, FALSE, TRUE, FALSE))


    })
  })
}
