context("test-convert_latex")

test_that("multiplication works", {
  .x <- c(
    "Greek: \\alpha\\beta\\gamma",
    "Symbole: \\dagger\\ddagger",
    "superscript: LS Mean^\\dagger",
    "superscript: LS Mean ^{\\dagger\\dagger}",
    "subscript:, HAMD_{17}",
    "superscript and subscript:, x_2^5"
  )

  .x_utf8 <- c(
    "Greek: \\uc1\\u945*\\uc1\\u946*\\uc1\\u947*",
    "Symbole: \\uc1\\u8224*\\uc1\\u8225*",
    "superscript: LS Mean\\super \\uc1\\u8224*",
    "superscript: LS Mean \\super {\\uc1\\u8224*\\uc1\\u8224*}",
    "subscript:, HAMD\\sub {17}",
    "superscript and subscript:, x\\sub 2\\super 5"
  )


  expect_equal(.convert(.x), .x_utf8)
})
