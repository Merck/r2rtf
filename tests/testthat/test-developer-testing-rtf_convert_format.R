if (Sys.info()[["sysname"]] == "Linux") {
  test_that("Report ERROR if libreoffice7.1 is not avaiable", {
    file <- file.path(tempdir(), "tmp.rtf")
    iris %>%
      head() %>%
      rtf_body() %>%
      rtf_encode() %>%
      write_rtf(file)
    if (system("which libreoffice7.1", ignore.stderr = TRUE, ignore.stdout = TRUE) == 1) {
      expect_error(rtf_convert_format(input = file, output_dir = tempdir()))
    } else {
      expect_equal(rtf_convert_format(input = file, output_dir = tempdir()), file.path(tempdir(), "tmp.pdf"))
    }
  })
}
