#' Assemble RTF TLFs
#'
#' Add a set of RTF/TEXT fields into an rdocx object.
#'
#' @param input Character vector of file path.
#' @param output Character string to the output file path.
#' @param landscape Logical vector to determine whether to
#' display files as portrait or landscape.
#' @param use_officer Logical value to determine whether the package officer::
#' should be used to assemble rtfs.
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
#' \dontrun{
#' rtf_assemble(
#'   list.files(
#'     "outtable/",
#'     pattern = "*.rtf",
#'     full.names = TRUE
#'   ),
#'   output = "tmp.docx"
#' )
#' }
#'
#' @export
rtf_assemble <- function(input, output, landscape = FALSE, use_officer = require(officer, quietly = TRUE)) {
  if (!is.logical(landscape)) stop("Landscape argument must be of type 'logical'.")
  if (!is.character(input)) stop("Input argument must be of type 'character'.")
  if (!is.character(output)) stop("Output argument must be of type 'character'.")
  if (!is.logical(use_officer)) stop("Use_officer argument must be of type 'logical'.")
  if (!(length(landscape) %in% c(1, length(input)))) {
    stop(
      "Landscape argument is length ", length(landscape),
      " but must be length 1 or ", length(input), " (input length)."
    )
  }


  # We need to choose correct extension based on officer:: use.
  output_ext <- ifelse(use_officer, ".docx", ".rtf")

  # We need to remove extension from output
  output <- paste0(regmatches(x = output,
    m = gregexpr(pattern = "^[aA-zZ0-9_]+", text = output))[[1]],
    output_ext)

  input <- normalizePath(input)

  if (!all(file.exists(input))) {
    warning("Some files do not exist and will not be included in the final document.")
  }

  field <- ifelse(grepl("/", input),
    paste0("INCLUDETEXT \"", gsub("/", "\\\\\\\\", input), "\""),
    paste0("INCLUDETEXT \"", gsub("\\", "\\\\", input, fixed = "TRUE"), "\"")
  )

  if (length(landscape) == 1) {
    landscape <- rep(landscape, length(field))
  }

  if (use_officer) {
    message("Appending rtf files into a '.docx' file with the use of officer:: package.")

    docx <- officer::read_docx()

    for (i in seq_along(input)) {
      docx <-
        docx |>
        officer::body_add_fpar(
          officer::fpar(
            officer::ftext("Table "),
            officer::run_word_field("SEQ Table \\* ARABIC"),
            officer::run_linebreak(),
            officer::run_word_field(field[i]),
            officer::run_pagebreak()
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
    message("Appending rtf files into a '.rtf' without the use of officer:: package,",
      "page orientation will be ignored.")

    rtf <- lapply(input, readLines)
    n <- length(rtf)
    start <- c(1, rep(2, n - 1))
    end <- vapply(rtf, length, numeric(1))
    end[-n] <- end[-n] - 1

    for (i in 1:n) {
      rtf[[i]] <- rtf[[i]][start[i]:end[i]]
      if (i < n) rtf[[i]] <- c(rtf[[i]], r2rtf:::as_rtf_new_page())
    }

    rtf <- do.call(c, rtf)

    write_rtf(rtf, output)
  }

  invisible(output)
}
