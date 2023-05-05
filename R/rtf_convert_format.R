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

#' Convert RTF file to Other Format
#'
#' This is an experimental function.
#'
#' Convert RTF files to PDF or DOCX files. Require `libreoffice`.
#'
#' @param input A vector of file paths for the input file to be converted.
#' @param output_file A vector of filename for the output file.
#' Default is the same filename for input.
#' @param output_dir The output directory for the converted `output_dir`.
#' @param format Converted file format extension. Currently support "pdf" or "docx"
#' @param overwrite logical; should existing destination files be overwritten?
#'
#' @return A vector of file paths for the converted files.
#'
#' @noRd
rtf_convert_format <- function(input,
                               output_file = NULL,
                               output_dir = ".",
                               format = "pdf",
                               overwrite = FALSE) {
  if (length(input) == 0) stop("The input variable can not be null")

  match_arg(tolower(format), c("pdf", "docx", "html"))

  # Check libreoffice dependency
  if (.Platform$OS.type == "unix") {
    sys_cmd <- c(
      paste0(
        "libreoffice",
        c(
          "7.5", "7.4", "7.3", "7.2", "7.1"
        )
      ),
      "libreoffice"
    )
    sys_loc <- which(Sys.which(sys_cmd) != "")[1]
    if (is.na(sys_loc)) stop("libreoffice is required")
    sys_cmd <- sys_cmd[sys_loc]

    # Libreoffice version require to be >= 7.1
    version <- strsplit(system(paste(sys_cmd, "--version"), intern = TRUE), " ")[[1]][[2]]
    if (as.package_version(version) < as.package_version("7.1")) {
      stop("libreoffice version required to be >= 7.1")
    }
  } else {
    stop("Only Unix/Linux is currently supported")
  }

  file_pattern <- paste0("*.", format)

  # Add blank cell for html output
  if (format == "html") {
    dir.create(file.path(tempdir(), "rtf"), showWarnings = FALSE)
    input_convert <- file.path(tempdir(), "rtf", basename(input))

    for (i in seq_along(input)) {
      x <- readLines(input[i])
      x <- update_cellx(x)

      index <- grep("^\\{\\\\pard", x)

      x_cell <- gsub("\\\\par", "\\\\cell", x[index])
      x_cell <- paste0(
        "\\trowd\\trgaph108\\trleft0\\trqc\\cellx", attr(x, "max_twip"), "\n",
        x_cell, "\n\\intbl\\row\\pard"
      )

      x[index] <- x_cell

      write_rtf(x, input_convert[i])
    }
  } else {
    input_convert <- input
  }

  # Define command line
  tmp_dir <- file.path(tempdir(), "rtf_convert")
  if (dir.exists(tmp_dir)) {
    file.remove(list.files(tmp_dir, pattern = file_pattern, full.names = TRUE))
  } else {
    dir.create(tmp_dir)
  }

  cmd <- paste0(
    sys_cmd, " --convert-to ",
    format, " ",
    input_convert,
    " --outdir ", tmp_dir
  )

  # Convert RTF to PDF
  output <- lapply(cmd, system, ignore.stderr = TRUE, ignore.stdout = TRUE)


  # Report error
  if (any(unlist(output) == 1)) {
    stop(paste0(
      "File convert error: ",
      paste(basename(input_convert)[output == 1], collapse = "; ")
    ))
  }

  if ((!overwrite)) {
    out_file <- list.files(output_dir)
    tmp_file <- list.files(tmp_dir, pattern = file_pattern)
    tmp_file <- tmp_file[tmp_file %in% out_file]

    for (i in seq_along(tmp_file)) {
      out_path <- file.path(output_dir, tmp_file[i])
      tmp_path <- file.path(tmp_dir, tmp_file[i])

      a <- readLines(out_path, encoding = "UTF-8", warn = FALSE)
      b <- readLines(tmp_path, encoding = "UTF-8", warn = FALSE)

      if (format == "pdf") {
        a_end <- max(grep("<</Creator", a))
        b_end <- max(grep("<</Creator", b))
      } else {
        a_end <- length(a)
        b_end <- length(b)
      }

      if (identical(a[1:a_end], b[1:b_end])) file.remove(file.path(tmp_dir, tmp_file[i]))
    }
  }

  # Copy file with difference
  tmp_file <- list.files(tmp_dir, pattern = file_pattern)
  file.copy(file.path(tmp_dir, tmp_file), file.path(output_dir, tmp_file), overwrite = TRUE)

  # Output path
  output_path <- file.path(
    output_dir,
    gsub(
      "\\.rtf$", paste0("\\.", format),
      basename(input_convert)
    )
  )

  # Rename file
  if (!is.null(output_file)) {
    file.rename(from = output_path, to = file.path(output_dir, output_file))
    output_path <- file.path(output_dir, output_file)
  }

  invisible(output_path)
}


#' Update RTF border twips
#'
#' @param x a character vector of RTF encoding.
#' @param tolerance tolerance of the difference for `\\cellx`.
#'
#' @return a character vector of RTF encoding.
#'
#' @keywords internal
#'
#' @noRd
update_cellx <- function(x, tolerance = 5) {
  cellx <- regmatches(x, gregexpr("cellx([0-9]+)", x))

  index <- sapply(cellx, function(x) length(x) > 0)

  cellx_num <- sort(as.numeric(gsub("cellx", "", unique(unlist(cellx)))))

  if (length(cellx_num) == 0) {
    return(x)
  }

  cellx_diff <- cumsum(c(tolerance + 1, diff(cellx_num)) > tolerance)

  cellx_update <- unlist(tapply(cellx_num, cellx_diff, function(x) rep(max(x), length(x))))

  origin <- paste0("\\\\cellx", cellx_num[cellx_num != cellx_update])
  convert <- paste0("\\\\cellx", cellx_update[cellx_num != cellx_update])

  for (i in seq_along(origin)) {
    x[index] <- gsub(origin[i], convert[i], x[index])
  }

  attr(x, "max_twip") <- max(cellx_num, na.rm = TRUE)

  x
}
