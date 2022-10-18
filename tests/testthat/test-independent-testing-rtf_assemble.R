# test bulletproofing
file <- replicate(2, tempfile(fileext = ".rtf"))
file1 <- head(iris) %>% rtf_body() %>% rtf_encode() %>% write_rtf(file[1])
file2 <- head(cars) %>% rtf_page(orientation = "landscape") %>% rtf_body() %>% rtf_encode() %>% write_rtf(file[2])

test_that("rtf_assemble: bulletproofing argument landscape", {

  expect_error(rtf_assemble(input = file,
                            output = tempfile(fileext = ".rtf"),
                            landscape = "yes",
                            use_officer = FALSE))

  expect_error(rtf_assemble(input = file,
                            output = tempfile(fileext = ".docx"),
                            landscape = c(TRUE, TRUE, FALSE),
                            use_officer = TRUE))

})

test_that("rtf_assemble: bulletproofing argument input", {

  expect_error(rtf_assemble(input = c(TRUE, TRUE), output = "tmp"))

})

test_that("rtf_assemble: bulletproofing argument output", {

  expect_error(rtf_assemble(input = file, output = TRUE))

})

test_that("rtf_assemble: bulletproofing argument use_officer", {

    expect_error(rtf_assemble(input = file,
                              output = "tmp",
                              use_officer = "yes"))

})

# test functionality without officer
test_that("rtf_assemble: output without using officer", {

  file_tmp <- tempfile(fileext = ".rtf")
  expect_message(rtf_path <- rtf_assemble(input = file,
                                          output = file_tmp,
                                          use_officer = FALSE),
                 regexp = "without using `officer` package.")

  expect_equal(rtf_path, file_tmp)
  expect_true(grepl(tempdir(), rtf_path))

  tmp_rtf <- paste(readLines(rtf_path), collapse = "\n")

  expect_true(grepl(tmp_rtf, pattern = "Sepal"))
  expect_true(grepl(tmp_rtf, pattern = "speed"))

})

# test functionality with officer
if (require(officer, quietly = TRUE)){
  test_that("rtf_assemble: output with using officer", {

    file_tmp <- tempfile(fileext = ".docx")
    expect_message(rtf_path <- rtf_assemble(input = file,
                                            output = file_tmp,
                                            landscape = c(FALSE, TRUE),
                                            use_officer = TRUE),
                   regexp = "'.docx' file using `officer` package.")

    expect_equal(rtf_path, file_tmp)
    expect_true(grepl(tempdir(), rtf_path))

    # Need to read in and expose document text for our test
    docx <- officer::read_docx(rtf_path)
    tmp_docx <- officer::docx_summary(docx)
    body_docx <- officer::docx_body_xml(docx)

    # Need to check if both "table seq table" texts are in the docx file.
    expect_true(grepl("Table SEQ Table", tmp_docx$text[1]))

    expect_equal(
      unlist(lapply(xml2::as_list(xml2::xml_find_all(body_docx, "//w:pgSz")), FUN = function(x) attr(x, "orient"))),
      c("portrait", "landscape")
    )
  })
}
