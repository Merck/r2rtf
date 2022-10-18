#' Assemble Multiple RTF Table Listing and Figure Into One Document
#'
#' The function asseble multiple RTF table, listing, and figures into one document
#' as RTF file or Microsft Word in `docx` format.
#'
#' @param input Character vector of file path.
#' @param output Character string to the output file path. File extension should
#' be `.docx` if `use_officer = TRUE` and `.rtf` if `FALSE`.
#' @param landscape Logical vector to determine whether to
#' display files as portrait or landscape. If `use_officer = FALSE`, only singular value is allowed.
#' @param use_officer Logical value to determine whether the package `officer`
#' should be used to assemble RTF table, listing and figure.
#'
#' @section Specification:
#' \if{latex}{
#'   \itemize{
#'     \item Transfer files to toggle fields format in Word
#'     \item Insert into Word file using officer
#'   }
#' }
#' \if{html}{
#' The contents of this section are shown in PDF user manual only.
#' }
#'
#' @examples
#'
#' file <- replicate(2, tempfile(fileext = ".rtf"))
#' file1 <- head(iris) %>% rtf_body() %>% rtf_encode() %>% write_rtf(file[1])
#' file2 <- head(cars) %>% rtf_page(orientation = "landscape") %>%
#'               rtf_body() %>% rtf_encode() %>% write_rtf(file[2])
#' output <- tempfile(fileext = ".rtf")
#'
#' rtf_assemble(
#'   input = file,
#'   output = output,
#'   use_officer = FALSE
#' )
#'
#' @export
rtf_assemble <- function(input,
                         output,
                         landscape = FALSE,
                         use_officer = TRUE) {

  # input checking
  check_args(input, type = "character")
  check_args(output, type = "character", length = 1)
  check_args(use_officer, type = "logical", length = 1)

  # define variables
  input <- normalizePath(input)
  n_input <- length(input)
  missing_input <- input[! file.exists(input)]
  ext_output <- tolower(tools::file_ext(output))

  # input checking based on use_officer
  if(use_officer){
    check_args(landscape, "logical", length = c(1, n_input))
    landscape <- rep(landscape, length.out = n_input)
    match_arg(ext_output, "docx")
  }else{
    check_args(landscape, "logical", length = 1)
    match_arg(ext_output, "rtf")
  }

  # warning missing input
  if(length(missing_input) > 0){
    warning("Missing files: \n", paste(missing_input, collapse = "\n"))
  }

  # assemble RTF
  if (use_officer) {
    message("Assemble rtf files into a '.docx' file using `officer` package.")
    if (!require(officer, quietly = TRUE)) stop("Use_officer = TRUE, but the ",
      "officer package is not installed.")

    field <- ifelse(grepl("/", input),
                    paste0("INCLUDETEXT \"", gsub("/", "\\\\\\\\", input), "\""),
                    paste0("INCLUDETEXT \"", gsub("\\", "\\\\", input, fixed = "TRUE"), "\"")
    )

    docx <- officer::read_docx()

    for (i in seq_along(input)) {
      docx <- officer::body_add_fpar(docx,
                officer::fpar(
                  officer::ftext("Table "),
                  officer::run_word_field("SEQ Table \\* ARABIC"),
                  officer::run_linebreak(),
                  officer::run_word_field(field[i])
               )
              )
      if (landscape[i]) {
        docx <- officer::body_end_section_landscape(docx)
      } else {
        docx <- officer::body_end_section_portrait(docx)
      }

      print(docx, target = output)
    }
  } else {

    message("Assemble rtf files into a '.rtf' without using `officer` package.")

    rtf <- lapply(input, readLines)
    n <- length(rtf)
    start <- c(1, rep(2, n - 1))
    end <- vapply(rtf, length, numeric(1))
    end[-n] <- end[-n] - 1

    for (i in seq_len(n)) {
      rtf[[i]] <- rtf[[i]][start[i]:end[i]]
      if (i < n) rtf[[i]] <- c(rtf[[i]], as_rtf_new_page())
    }

    rtf <- do.call(c, rtf)

    write_rtf(rtf, output)
  }

  invisible(output)
}
