# Build Temporary vector for use in testing
teststr <- "The quick brown fox (){}[]$#&%@,.;:=_+-*/"

# Use rtf_text on temporary vector to use as input
rtf_text(
  text = teststr,
  font = 1,
  font_size = 6,
  format = "b",
  color = "black",
  background_color = "white"
)

# Check Temporary input attributes
teststratt <- attributes(teststr)

test_that("check valid input arguments to justification", {

  # Check justification argument matches justification()$type

  expect_error(rtf_paragraph(
    text = teststr,
    justification = 1
  ),
  "as.vector(justification) %in% para_justification$type is not TRUE",
  fixed = TRUE
  )
})

test_that("check valid input arguments to indent_first", {

  # Check indent_first argument only takes atomic numeric vector arguments

  expect_error(rtf_paragraph(
    text = teststr,
    indent_first = "4"
  ),
  "is.numeric(indent_first) is not TRUE",
  fixed = TRUE
  )
})

test_that("check valid input arguments to indent_left", {

  # Check indent_left argument only takes atomic numeric vector arguments

  expect_error(rtf_paragraph(
    text = teststr,
    indent_left = "4"
  ),
  "is.numeric(indent_left) is not TRUE",
  fixed = TRUE
  )
})

test_that("check valid input arguments to indent_right", {

  # Check indent_right argument only takes atomic numeric vector arguments

  expect_error(rtf_paragraph(
    text = teststr,
    indent_right = "4"
  ),
  "is.numeric(indent_right) is not TRUE",
  fixed = TRUE
  )
})

test_that("check valid input arguments to spacing", {

  # Check space argument matches spacing()$type

  expect_error(rtf_paragraph(
    text = teststr,
    space = "2.5"
  ),
  "space %in% spacing$type is not TRUE",
  fixed = TRUE
  )
})

test_that("check valid input arguments to space_before", {

  # Check space_before argument only takes atomic numeric vector arguments

  expect_error(rtf_paragraph(
    text = teststr,
    space_before = "4"
  ),
  "is.numeric(space_before) is not TRUE",
  fixed = TRUE
  )
})

test_that("check valid input arguments to space_after", {

  # Check space_after argument only takes atomic numeric vector arguments

  expect_error(rtf_paragraph(
    text = teststr,
    space_after = "4"
  ),
  "is.numeric(space_after) is not TRUE",
  fixed = TRUE
  )
})


test_that("check line, paragraph space encoding", {

  # Check paragraph space encoding

  expect_match(
    rtf_paragraph(
      text = teststr,
      space = 1.5
    ),
    "sl360\\\\slmult1"
  )

  # Check line space_before encoding

  expect_match(
    rtf_paragraph(
      text = teststr,
      space_before = 240
    ),
    "sb240"
  )

  # Check line space_after encoding

  expect_match(
    rtf_paragraph(
      text = teststr,
      space_after = 480
    ),
    "sa480"
  )
})

test_that("check page break encoding", {

  # Check page break new_page encoding

  expect_match(
    rtf_paragraph(
      text = teststr,
      new_page = TRUE
    ),
    "pagebb"
  )
})

test_that("check indentation, alignment encoding", {

  # Check alignment justification encoding

  expect_match(
    rtf_paragraph(
      text = teststr,
      justification = "d"
    ),
    "qj"
  )

  # Check indentation indent_first encoding

  expect_match(
    rtf_paragraph(
      text = teststr,
      indent_first = 134
    ),
    "fi134"
  )

  # Check indentation indent_left encoding

  expect_match(
    rtf_paragraph(
      text = teststr,
      indent_left = 134
    ),
    "li134"
  )

  # Check indentation indent_right encoding

  expect_match(
    rtf_paragraph(
      text = teststr,
      indent_right = 134
    ),
    "ri134"
  )
})

test_that("check hyphenation encoding", {

  # Check page break new_page encoding

  expect_match(
    rtf_paragraph(
      text = teststr,
      hyphenation = TRUE
    ),
    "hyphpar"
  )
})
