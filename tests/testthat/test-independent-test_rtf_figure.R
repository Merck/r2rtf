context("Independent testing for rtf_figure.R")

#create temporary plots for testing
options(bitmapType='cairo')
png(filename =  file.path(tempdir(), "plot1.png"))
df <- rnorm(300, 1, 2)
plot(df)
dev.off()

png(filename = file.path(tempdir(), "plot2.png"))
x <- seq(-10,10,1)
options(bitmapType='cairo')
plot(x, (x*2))
dev.off()

list.files(tempdir())

df <- file.path(tempdir(), c("plot1.png", "plot2.png"))
df <- df %>% rtf_read_png()

df1 <- df %>% rtf_figure()  #to test defult values

#to check multiple values
df2 <- df %>% rtf_figure (fig_width = c(4.5 , 6.2) ,
                          fig_height = c(5.5, 6.1)
                          )


test_that("figure width and height attributes", {
  # check defult values
  expect_true(is.matrix(attr(df1, "fig_width")), TRUE)
  expect_true(is.matrix(attr(df1, "fig_height")), TRUE)
  expect_equal(attr(df1, "fig_width"), matrix(c(5,5) , nrow = 2, ncol = 1))
  expect_equal(attr(df1, "fig_height"), matrix(c(5,5) , nrow = 2, ncol = 1))


#check with non-defult values
  expect_equal(attr(df2, "fig_width") , matrix(c(4.5 , 6.2), nrow = 2 , ncol = 1))
  expect_equal(attr(df2, "fig_height") , matrix(c(5.5, 6.1), nrow= 2, ncol = 1))
  expect_error(df3 <- df %>% rtf_figure (fig_width = c(-4 , 6.2)), TRUE)
  expect_error(df3 <- df %>% rtf_figure (fig_height = c(-4 , -6)), TRUE)


})
