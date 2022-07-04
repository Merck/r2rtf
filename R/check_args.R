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

#' Check Argument Types, Length or Dimension
#'
#' @param arg An argument to be checked.
#' @param type A character vector of candidate argument type.
#' @param length A numeric value of argument length or NULL
#' @param dim A numeric vector of argument dimension or NULL.
#'
#' @details if `type`, `length` or `dim` is NULL, the corresponding check will not be executed.
#'
#' @section Specification:
#' \if{latex}{
#'  \itemize{
#'    \item Check if arg is NULL.
#'    \item Extract the type, length and dim information from arg.
#'    \item Compare with target values and report error message if it does not match.
#'  }
#'  }
#' \if{html}{The contents of this section are shown in PDF user manual only.}
#'
#' @return Check failure detailed error message
#'
#' @examples
#' \dontrun{
#' tbl < -as.data.frame(matrix(1:9, nrow = 3))
#' check_args(arg = tbl, type = c("data.frame"))
#'
#' vec <- c("a", "b", "c")
#' check_args(arg = vec, type = c("character"), length = 3)
#' }
#'
check_args <- function(arg, type, length = NULL, dim = NULL) {
  if (is.null(arg)) {
    return(NULL)
  }

  if(any(class(arg) %in% "matrix")) arg <- as.vector(arg)

  check <- list()
  message <- list()

  if (!is.null(type)) {
    check[["type"]] <- any(class(arg) %in% type) & (!is.null(class(arg)))
    message[["type"]] <- paste("The argument type did not match:", paste(type, collapse = "/"))
  }

  if (!is.null(length)) {
    check[["length"]] <- all(length(arg) == length) & (!is.null(length(arg)))
    message[["length"]] <- paste("The argument length is not", length)
  }

  if (!is.null(dim)) {
    check[["dim"]] <- all(dim(arg) == dim) & (!is.null(dim(arg)))
    message[["dim"]] <- paste("The argument dimension is not", paste(dim, collapse = ","))
  }

  check <- unlist(check)
  message <- unlist(message)

  if (!all(unlist(check))) {
    stop(paste(message[!check], collapse = "\n"))
  } else {
    return(NULL)
  }
}
