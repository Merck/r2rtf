df <- c("fig/fig1.png", "fig/fig2.png")
df <- df %>% rtf_read_png()

df1 <- df %>% rtf_figure()  #to test default values

#to check multiple values
df2 <- df %>% rtf_figure(fig_width = c(4.5 , 6.2), fig_height = c(5.5, 6.1))

test_that("figure width and height attributes", {
  # check default values
  expect_true(is.matrix(attr(df1, "fig_width")))
  expect_true(is.matrix(attr(df1, "fig_height")))
  expect_equal(attr(df1, "fig_width"), matrix(c(5,5) , nrow = 2, ncol = 1))
  expect_equal(attr(df1, "fig_height"), matrix(c(5,5) , nrow = 2, ncol = 1))


#check with non-default values
  expect_equal(attr(df2, "fig_width") , matrix(c(4.5 , 6.2), nrow = 2 , ncol = 1))
  expect_equal(attr(df2, "fig_height") , matrix(c(5.5, 6.1), nrow= 2, ncol = 1))
  expect_error(df %>% rtf_figure(fig_width = c(-4 , 6.2)))
  expect_error(df %>% rtf_figure(fig_height = c(-4 , -6)))


})
