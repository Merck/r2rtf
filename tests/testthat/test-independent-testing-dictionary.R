test_that("text font", {
  expect_snapshot_output(font_type())
})

test_that("text color", {
  t_color <- data.frame(color = grDevices::colors())
  t_color$type <- 1:nrow(t_color) + 1
  t_color <- cbind(t_color, t(grDevices::col2rgb(t_color$color)))
  t_color$rtf_code <- paste0("\\red", t_color$red, "\\green", t_color$green, "\\blue", t_color$blue, ";")

  expect_equal(color_table(),t_color)
})

test_that("text format", {
  t_format <-  data.frame(
    type = c("", "b", "i", "u", "s", "^", "_"),
    name = c("normal", "bold", "italics", "underline", "strike", "superscript", "subscript"),
    rtf_code = c("", "\\b", "\\i", "\\ul", "\\strike", "\\super", "\\sub"),
    stringsAsFactors = FALSE
  )

  expect_equal(font_format(), t_format)
})

test_that("text justification", {
  t_just<- data.frame(
    type = c("l", "c", "r", "d", "j"),
    name = c("left", "center", "right", "decimal", "justified"),
    rtf_code_text = c("\\ql", "\\qc", "\\qr", "\\qj", "\\qj"),
    rtf_code_row = c("\\trql", "\\trqc", "\\trqr", "", ""),
    stringsAsFactors = FALSE
  )

  expect_equal(justification(),t_just)
})

test_that("border type", {
  brd_typ<-  data.frame(
    name = c(
      "", "single", "double thick", "shadowed", "double", "dot", "dash", "hairline", "small dash", "dot dash", "dot dot", "triple",
      "thick thin small", "thin thick small", "thin thick thin small",
      "thick thin medium", "thin thick medium", "thin thick thin medium",
      "thick thin large", "thin thick large", "thin thick thin large",
      "wavy", "double wavy", "stripe", "emboss", "engrave"
    ),
    rtf_code = c(
      "", "\\brdrs", "\\brdrth", "\\brdrsh", "\\brdrdb", "\\brdrdot", "\\brdrdash",
      "\\brdrhair", "\\brdrdashsm", "\\brdrdashd", "\\brdrdashdd", "\\brdrtriple",
      "\\brdrtnthsg", "\\brdrthtnsg", "\\brdrtnthtnsg",
      "\\brdrtnthmg", "\\brdrthtnmg", "\\brdrtnthtnmg",
      "\\brdrtnthlg", "\\brdrthtnlg", "\\brdrtnthtnlg",
      "\\brdrwavy", "\\brdrwavydb", "\\brdrdashdotstr",
      "\\brdremboss", "\\brdrengrave"
    ),
    stringsAsFactors = FALSE
  )
  expect_equal(border_type(),brd_typ)
})


test_that("spacing", {
  spacing <-   data.frame(
    type = c(1, 2, 1.5),
    name = c("single-space", "double-space", "1.5-space"),
    rtf_code = c("", "\\sl480\\slmult1", "\\sl360\\slmult1"),
    stringsAsFactors = FALSE
  )
  expect_equal(spacing(),spacing)
})
