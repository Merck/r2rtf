#' Assemble Multiple RTF Table Listing and Figure Into One RTF Document
#'
#' The function assemble multiple RTF table, listing, and figures into
#' one document as RTF file.
#'
#' @param input Character vector of file path.
#' @param output Character string to the output file path.
#' @param landscape Logical value to determine page direction.
#'
#' @section Specification:
#' \if{latex}{
#'   \itemize{
#'     \item Read individual RTF files.
#'     \item Insert into one RTF file.
#'   }
#' }
#' \if{html}{
#' The contents of this section are shown in PDF user manual only.
#' }
#'
#' @examples
#'
#' library(magrittr)
#'
#' file <- replicate(2, tempfile(fileext = ".rtf"))
#' file1 <- head(iris) %>%
#'   rtf_body() %>%
#'   rtf_encode() %>%
#'   write_rtf(file[1])
#' file2 <- head(cars) %>%
#'   rtf_page(orientation = "landscape") %>%
#'   rtf_body() %>%
#'   rtf_encode() %>%
#'   write_rtf(file[2])
#' output <- tempfile(fileext = ".rtf")
#'
#' assemble_rtf(
#'   input = file,
#'   output = output
#' )
#'
#' @export
assemble_rtf <- function(input,
                         output,
                         landscape = FALSE) {
  # input checking
  check_args(input, type = "character")
  check_args(output, type = "character", length = 1)

  # define variables
  input <- normalizePath(input)
  n_input <- length(input)
  missing_input <- input[!file.exists(input)]
  ext_output <- tolower(tools::file_ext(output))

  # input checking
  check_args(landscape, "logical", length = 1)
  match_arg(ext_output, "rtf")

  # warning missing input
  if (length(missing_input) > 0) {
    warning("Missing files: \n", paste(missing_input, collapse = "\n"))
    input <- setdiff(input, missing_input)
  }

  # assemble RTF
  rtf <- lapply(input, readLines)
  n <- length(rtf)
  start <- c(1, vapply(rtf[-1], function(x) max(grep("fcharset", rtf[[1]])) + 2, numeric(1)))
  end <- vapply(rtf, length, numeric(1))
  end[-n] <- end[-n] - 1

  for (i in seq_len(n)) {
    rtf[[i]] <- rtf[[i]][start[i]:end[i]]
    if (i < n) rtf[[i]] <- c(rtf[[i]], as_rtf_new_page())
  }

  rtf <- do.call(c, rtf)

  write_rtf(rtf, output)
}

#' Assemble Multiple RTF Table Listing and Figure Into One Word Document
#'
#' The function assemble multiple RTF table, listing, and figures into
#' one document as Microsoft Word (i.e., `docx`).
#'
#' @param input Character vector of file path.
#' @param output Character string to the output file path.
#' @param landscape Logical vector to determine page direction.
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
#' @examplesIf r2rtf:::is_installed("officer") && r2rtf:::is_installed("systemfonts")
#'
#' library(officer)
#' library(magrittr)
#'
#' file <- replicate(2, tempfile(fileext = ".rtf"))
#' file1 <- head(iris) %>%
#'   rtf_body() %>%
#'   rtf_encode() %>%
#'   write_rtf(file[1])
#' file2 <- head(cars) %>%
#'   rtf_page(orientation = "landscape") %>%
#'   rtf_body() %>%
#'   rtf_encode() %>%
#'   write_rtf(file[2])
#' output <- tempfile(fileext = ".docx")
#'
#' assemble_docx(
#'   input = file,
#'   output = output
#' )
#'
#' @export
assemble_docx <- function(input,
                          output,
                          landscape = FALSE) {
  # input checking
  check_args(input, type = "character")
  check_args(output, type = "character", length = 1)

  # define variables
  input <- normalizePath(input)
  n_input <- length(input)
  missing_input <- input[!file.exists(input)]
  ext_output <- tolower(tools::file_ext(output))

  # input checking
  check_args(landscape, "logical", length = c(1, n_input))
  landscape <- rep(landscape, length.out = n_input)
  match_arg(ext_output, "docx")

  # warning missing input
  if (length(missing_input) > 0) {
    warning("Missing files: \n", paste(missing_input, collapse = "\n"))
    input <- setdiff(input, missing_input)
  }

  # assemble RTF
  if (!requireNamespace("officer")) {
    stop("The officer package is required but not installed.")
  }

  field <- ifelse(grepl("/", input),
    paste0("INCLUDETEXT \"", gsub("/", "\\\\\\\\", input), "\""),
    paste0("INCLUDETEXT \"", gsub("\\", "\\\\", input, fixed = "TRUE"), "\"")
  )

  docx <- officer::read_docx()

  for (i in seq_along(input)) {
    docx <- officer::body_add_fpar(
      docx,
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

  invisible(output)
}
