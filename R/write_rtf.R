#    Copyright (c) 2022 Merck & Co., Inc., Rahway, NJ, USA and its affiliates. All rights reserved.
#
#    This file is part of the r2rtf program.
#
#    r2rtf is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

#' @title Write an RTF Table or Figure to an RTF File
#'
#' @description
#' The write_rtf function writes rtf encoding string to an .rtf file
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Export a single RTF string into an file using \code{write} function.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @param rtf A character rtf encoding string rendered by `rtf_encode()`.
#' @param file A character string naming a file to save rtf file.
#'
#' @export
write_rtf <- function(rtf, file) {
  write(paste(unlist(rtf), collapse = "\n"), file)

  invisible(file)
}


#' Write a Paragraph to an RTF File
#'
#' @param rtf rtf code for text paragraph, obtained using `rtf_paragraph(text,...)` function
#' @param file file name to save rtf text paragraph, eg. filename.rtf
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Define table color using \code{color_table()} and translate in RTF syntax.
#'    \item Initiate rtf using \code{as_rtf_init()} and \code{as_rtf_font()}.
#'    \item Combine the text with other components into a single RTF code string.
#'    \item Output the paragraph into a file.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @noRd
write_rtf_para <- function(rtf, file) {
  col_tb <- color_table()
  rtf_color <- paste(c("{\\colortbl\n;", col_tb$rtf_code, "}"), collapse = "\n")

  start_rtf <- paste(
    as_rtf_init(),
    as_rtf_font(),
    rtf_color,
    sep = "\n"
  )

  rtf <- paste(start_rtf, "{\\pard \\par}", paste(rtf, collapse = ""), as_rtf_end(), sep = "\n")
  write(rtf, file)

  invisible(file)
}

#' Write an RTF Table or Figure to a DOCX File
#'
#' @description
#' The write_docx function writes an RTF encoding string to a .docx file
#' by first writing to a temporary RTF file and then converting it to DOCX
#' using LibreOffice.
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Write RTF encoding to a temporary RTF file.
#'    \item Convert RTF to DOCX using LibreOffice command-line tool via \code{rtf_convert_format()}.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @param rtf A character rtf encoding string rendered by `rtf_encode()`.
#' @param file A character string naming a file to save docx file.
#'
#' @details
#' This function requires LibreOffice to be installed on the system.
#' The function uses the internal \code{rtf_convert_format()} function
#' to perform the conversion from RTF to DOCX format.
#'
#' Currently only Unix/Linux/macOS systems are supported.
#'
#' @export
write_docx <- function(rtf, file) {
  # Normalize the output file path
  file <- normalizePath(file, mustWork = FALSE)

  # Create output directory if it doesn't exist
  output_dir <- dirname(file)
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }

  # Create a temporary RTF file
  tmpdir <- tempfile(pattern = "r2rtf_")
  dir.create(tmpdir)
  on.exit(unlink(tmpdir, recursive = TRUE), add = TRUE)

  file_basename <- tools::file_path_sans_ext(basename(file))
  rtf_path <- file.path(tmpdir, paste0(file_basename, ".rtf"))
  write_rtf(rtf, rtf_path)

  # Convert RTF to DOCX using existing rtf_convert_format function
  rtf_convert_format(
    input = rtf_path,
    output_file = basename(file),
    output_dir = output_dir,
    format = "docx",
    overwrite = TRUE
  )

  invisible(file)
}
