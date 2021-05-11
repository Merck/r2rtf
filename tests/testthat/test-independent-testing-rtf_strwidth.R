# create testing example

 df <- data.frame(x = rep("This is a long sentence", 5),
                  y = "short",
                  z = 'third')

 tbl <- df %>%
   rtf_body(text_font = c(1, 9, 1),
            text_font_size = 8,
            text_format = c('i','b','b'))

 strw <- round(r2rtf:::rtf_strwidth(tbl),5)

 size8italic <- round(graphics::strwidth('This is a long sentence',
                                   units = "inches",
                                   cex = 2/3,
                                   font = 3,
                                   family = 'Times New Roman'), 5)

 bold <- round(graphics::strwidth('third',
                                  units = "inches",
                                  cex = 2/3,
                                  font = 2,
                                  family = 'Times New Roman'), 5)


test_that("test if width are calculated correctly for case when font size is 8", {
font_type()

    expect_equal(strw[1,1], size8italic)

})


test_that("test if width are calculated correctly for case when font format is bold", {

   expect_equal(strw[1,3], bold)

})


test_that("test if width are calculated correctly for case when font format is italic", {

  expect_equal(strw[1,1], size8italic)

})


test_that("test if width are calculated correctly for case when 'Courier New' is used", {

  expect_equal(strw[1,2], round(5*8*0.52/72, 5))

})



