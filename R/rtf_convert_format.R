#    Copyright (c) 2020 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.
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
#' This is a experimental function.
#'
#' Convert RTF files to PDF or DOCX files. Require libreoffice7.1.
#'
#' @param input A vector of file paths for the input file to be converted.
#' @param output_file A vector of filename for the output file. Default is the same filename for input.
#' @param output_dir The output directory for the converted `output_dir`.
#' @param format Converted file format extension. Currently support "pdf" or "docx"
#' @param overwrite logical; should existing destination files be overwritten?
#'
#' @return A vector of file paths for the converted files.
#'
rtf_convert_format <- function(input,
                               output_file = NULL,
                               output_dir = ".",
                               format = "pdf",
                               overwrite = FALSE){

  match_arg(tolower(format), c("pdf", "docx", "html"))

  # Check libreoffice dependency
  if(.Platform$OS.type == "unix"){
    sys_dep <- system("which libreoffice7.1", ignore.stderr = TRUE, ignore.stdout = TRUE)
  }else{
    stop("Only Unix/Linux is currently supported")
  }

  if(sys_dep == 1){
    stop("libreoffice7.1 is required")
  }

  file_pattern <- paste0("*.", format)

  # Define command line
  tmp_dir <- file.path(tempdir(), "rtf_convert")
  if(dir.exists(tmp_dir)){
    file.remove(list.files(tmp_dir, pattern = file_pattern, full.names = TRUE))
  }else{
    dir.create(tmp_dir)
  }

  cmd <- paste0("libreoffice7.1 --convert-to ",
                format, " ",
                input,
                " --outdir ", tmp_dir)

  # Convert RTF to PDF
  output <- lapply(cmd, system, ignore.stderr = TRUE, ignore.stdout = TRUE)


  # Report error
  if( any( unlist(output) == 1 ) ){
    stop(paste0("File convert error: ",
                paste(basename(input)[output == 1], collapse = "; ") ) )
  }

  if( (! overwrite)){
    out_file <- list.files(output_dir)
    tmp_file <- list.files(tmp_dir, pattern = file_pattern)
    tmp_file <- tmp_file[tmp_file %in% out_file]

    for(i in seq_along(tmp_file)){
      out_path <- file.path(output_dir, tmp_file[i])
      tmp_path <- file.path(tmp_dir, tmp_file[i])

      a <- readLines(out_path, encoding = "UTF-8", warn = FALSE)
      b <- readLines(tmp_path, encoding = "UTF-8", warn = FALSE)

      if(format == "pdf"){
        a_end <- max(grep("<</Creator", a))
        b_end <- max(grep("<</Creator", b))
      }else{
        a_end <- length(a)
        b_end <- length(b)
      }

      if(identical(a[1:a_end], b[1:b_end])) file.remove(file.path(tmp_dir, tmp_file[i]) )
    }

  }

  # Copy file with difference
  tmp_file <- list.files(tmp_dir, pattern = file_pattern)
  file.copy(file.path(tmp_dir, tmp_file), file.path(output_dir, tmp_file), overwrite = TRUE)

  # Output path
  output_path <- file.path(output_dir,
                           gsub("\\.rtf$", paste0("\\.", format),
                           basename(input)))

  # Rename file
  if(! is.null(output_file)){
    file.rename(from = output_path, to = file.path(output_dir, output_file))
    output_path <- file.path(output_dir, output_file)
  }

  invisible(output_path)

}
