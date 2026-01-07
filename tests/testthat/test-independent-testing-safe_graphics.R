safe_device_ids <- function() {
  devices <- grDevices::dev.list()
  if (is.null(devices)) integer() else unname(devices)
}

close_new_devices <- function(before_ids) {
  after_ids <- safe_device_ids()
  new_ids <- setdiff(after_ids, before_ids)
  if (length(new_ids) > 0) {
    for (id in new_ids) {
      grDevices::dev.off(id)
    }
  }
  invisible(new_ids)
}

test_that("file_null returns the platform null device", {
  expected <- if (.Platform$OS.type == "windows") "nul:" else "/dev/null"
  expect_identical(r2rtf:::file_null(), expected)
})

test_that("close_device ignores invalid identifiers", {
  before <- safe_device_ids()
  r2rtf:::close_device(NA_real_)
  r2rtf:::close_device("not-a-device")
  r2rtf:::close_device(1)
  r2rtf:::close_device(9999)
  expect_identical(safe_device_ids(), before)
})

test_that("close_device closes a live device", {
  before <- safe_device_ids()
  on.exit(close_new_devices(before), add = TRUE)

  grDevices::pdf(file = r2rtf:::file_null())
  new_ids <- setdiff(safe_device_ids(), before)

  expect_true(length(new_ids) >= 1)

  r2rtf:::close_device(new_ids[1])

  expect_identical(safe_device_ids(), before)
})

test_that("with_graphics_device restores device state", {
  before <- safe_device_ids()
  on.exit(close_new_devices(before), add = TRUE)

  width <- r2rtf:::with_graphics_device({
    graphics::plot.new()
    graphics::strwidth("x")
  })

  expect_true(is.numeric(width))
  expect_identical(safe_device_ids(), before)
})

test_that("with_graphics_device does not add devices when one is active", {
  before <- safe_device_ids()
  on.exit(close_new_devices(before), add = TRUE)

  grDevices::pdf(file = r2rtf:::file_null())
  open_devices <- safe_device_ids()

  width <- r2rtf:::with_graphics_device({
    graphics::plot.new()
    graphics::strwidth("x")
  })

  expect_true(is.numeric(width))
  expect_identical(safe_device_ids(), open_devices)
})

test_that("open_null_device honors device option with file", {
  before <- safe_device_ids()
  on.exit(close_new_devices(before), add = TRUE)

  old_device <- getOption("device")
  on.exit(options(device = old_device), add = TRUE)

  called <- FALSE
  file_arg <- NULL
  device_fun <- function(file, ...) {
    called <<- TRUE
    file_arg <<- file
    grDevices::pdf(file = file, ...)
  }
  options(device = device_fun)

  opened <- r2rtf:::open_null_device()

  expect_true(called)
  expect_identical(file_arg, r2rtf:::file_null())
  expect_true(opened %in% safe_device_ids())
})

test_that("open_null_device honors device option with filename", {
  before <- safe_device_ids()
  on.exit(close_new_devices(before), add = TRUE)

  old_device <- getOption("device")
  on.exit(options(device = old_device), add = TRUE)

  called <- FALSE
  filename_arg <- NULL
  device_fun <- function(filename, ...) {
    called <<- TRUE
    filename_arg <<- filename
    grDevices::pdf(file = filename, ...)
  }
  options(device = device_fun)

  opened <- r2rtf:::open_null_device()

  expect_true(called)
  expect_identical(filename_arg, r2rtf:::file_null())
  expect_true(opened %in% safe_device_ids())
})

test_that("open_null_device falls back when option cannot accept a file", {
  before <- safe_device_ids()
  if (length(before) > 0) {
    skip("requires no active devices for fallback path")
  }
  on.exit(close_new_devices(before), add = TRUE)

  old_device <- getOption("device")
  on.exit(options(device = old_device), add = TRUE)

  options(device = function(...) NULL)

  opened <- r2rtf:::open_null_device()

  after <- safe_device_ids()
  expect_true(length(after) >= 1)
  expect_true(opened %in% after)
})
