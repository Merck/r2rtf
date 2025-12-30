#' Evaluate graphics code without leaking devices
#'
#' Functions like [graphics::strwidth()] and [graphics::par()] require an
#' active graphics device. When no device is active, they may implicitly
#' open the default device (for example, [grDevices::pdf()]), which can
#' leave a device open and/or create `Rplots.*` files.
#'
#' This helper evaluates an expression with an active device and restores the
#' original device state on exit.
#'
#' @noRd
with_graphics_device <- function(expr) {
  expr <- substitute(expr)

  if (!is.null(grDevices::dev.list())) {
    return(eval(expr, envir = parent.frame()))
  }

  opened_device <- open_null_device()
  on.exit(close_device(opened_device), add = TRUE)

  eval(expr, envir = parent.frame())
}

#' Open a null device
#'
#' Open a file-backed device (prefer the session default) targeting the
#' platform null file so no output is created on disk.
#'
#' @returns The opened device number (or 1 if opening failed).
#'
#' @noRd
open_null_device <- function() {
  null_file <- file_null()
  device_opt <- getOption("device")

  device_fun <- NULL
  if (is.function(device_opt)) {
    device_fun <- device_opt
  } else if (is.character(device_opt) && length(device_opt) == 1L) {
    device_fun <- get(device_opt, mode = "function")
  }

  if (is.function(device_fun)) {
    arg_names <- tryCatch(names(formals(device_fun)), error = function(e) NULL)
    if (!is.null(arg_names)) {
      tryCatch(
        suppressWarnings(
          suppressMessages(
            if ("file" %in% arg_names) {
              device_fun(file = null_file)
            } else if ("filename" %in% arg_names) {
              device_fun(filename = null_file)
            }
          )
        ),
        error = function(e) NULL
      )
    }
  }

  if (is.null(grDevices::dev.list())) {
    suppressWarnings(suppressMessages(grDevices::pdf(file = null_file)))
  }

  grDevices::dev.cur()
}

close_device <- function(which) {
  if (!is.numeric(which) || length(which) != 1L || is.na(which) || which == 1L) {
    return(invisible(NULL))
  }

  open_devices <- grDevices::dev.list()
  if (!is.null(open_devices) && which %in% open_devices) {
    grDevices::dev.off(which)
  }

  invisible(NULL)
}

file_null <- function() {
  if (.Platform$OS.type == "windows") "nul:" else "/dev/null"
}
