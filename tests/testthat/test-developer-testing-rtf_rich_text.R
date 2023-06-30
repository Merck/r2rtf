test_that("rtf_rich_text fundamentally works.", {
  output <- rtf_rich_text(
    text = "This is {.emph important}. This is {.blah relevant}.",
    theme = list(
      .emph = list(color = "blue", `format` = "b"),
      .blah = list(color = "red")
    )
  )

  expectation <- rtf_text(paste0(
    "This is ",
    rtf_text("important", color = "blue", `format` = "b"),
    ". This is ",
    rtf_text("relevant", color = "red"),
    "."
  ))

  expect_equal(output, expectation)
})

test_that("rtf_rich_text works with example from check_args.", {
  output <- r2rtf:::rtf_paragraph(
    r2rtf:::rtf_rich_text(
      text = "3.5{^\\dagger}\n{.red red} {.hl highlight}",
      theme = list(
        .red = list(color = "red"),
        .hl = list(background_color = "yellow")
      )
  ))

  expectation <- r2rtf:::rtf_paragraph(
    r2rtf:::rtf_text(paste0(
    "3.5{^\\dagger}\\line ",
    r2rtf:::rtf_text("red", color = "red"),
    " ",
    r2rtf:::rtf_text("highlight", background_color = "yellow")
  )))

  expect_equal(output, expectation)
})

