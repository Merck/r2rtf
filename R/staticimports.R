# These functions:
# - `is_installed()`
# - `get_package_version()`
# - `system_file_cached()`
# were sourced from the staticimports package version 0.0.0.9001, available at
# <https://github.com/wch/staticimports>.
#
# For the original version of these functions, please see:
# <https://github.com/wch/staticimports/blob/35ceec8d9d9429d9244aedc3ee6a1e8d62d59f79/inst/staticexports/package.R>.
#
# The staticimports package is licensed under the MIT license.
# For more details on the license, see
# <https://github.com/wch/staticimports/blob/35ceec8d9d9429d9244aedc3ee6a1e8d62d59f79/LICENSE.md>.

is_installed <- function(pkg, version = NULL) {
  installed <- isNamespaceLoaded(pkg) || nzchar(system_file_cached(package = pkg))

  if (is.null(version)) {
    return(installed)
  }

  if (!is.character(version) && !inherits(version, "numeric_version")) {
    # Avoid https://bugs.r-project.org/show_bug.cgi?id=18548
    alert <- if (identical(Sys.getenv("TESTTHAT"), "true")) stop else warning
    alert("`version` must be a character string or a `package_version` or `numeric_version` object.")

    version <- numeric_version(sprintf("%0.9g", version))
  }

  installed && isTRUE(get_package_version(pkg) >= version)
}

get_package_version <- function(pkg) {
  # `utils::packageVersion()` can be slow, so first try the fast path of
  # checking if the package is already loaded.
  ns <- .getNamespace(pkg)
  if (is.null(ns)) {
    utils::packageVersion(pkg)
  } else {
    as.package_version(ns$.__NAMESPACE__.$spec[["version"]])
  }
}

# A wrapper for `system.file()`, which caches the package path because
# `system.file()` can be slow. If a package is not installed, the result won't
# be cached.
system_file_cached <- local({
  pkg_dir_cache <- character()

  function(..., package = "base") {
    if (!is.null(names(list(...)))) {
      stop("All arguments other than `package` must be unnamed.")
    }

    not_cached <- is.na(match(package, names(pkg_dir_cache)))
    if (not_cached) {
      pkg_dir <- system.file(package = package)
      if (nzchar(pkg_dir)) {
        pkg_dir_cache[[package]] <<- pkg_dir
      }
    } else {
      pkg_dir <- pkg_dir_cache[[package]]
    }

    file.path(pkg_dir, ...)
  }
})
