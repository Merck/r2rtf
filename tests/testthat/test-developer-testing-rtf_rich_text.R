test_that("rtf_rich_text fundamentally works.", {
  output <- rtf_rich_text(
    text = "This is {.emph important}. This is {.blah relevant}.",
    theme = list(
      .emph = list(color = "blue", `format` = "b"),
      .blah = list(color = "red")
    )
  )

  expectation <- paste0(
    "This is ",
    rtf_text("important", color = "blue", `format` = "b"),
    ". This is ",
    rtf_text("relevant", color = "red"),
    "."
  )

  expect_equal(output, expectation)
})
