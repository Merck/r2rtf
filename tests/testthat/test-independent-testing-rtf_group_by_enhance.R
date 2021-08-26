dt <- iris[c(1:5, 51:55, 101:105), ] %>% dplyr::arrange(Species)


# test_that("Test when data is not sorted by group_by variable", {
#   dt1 <- dt %>% dplyr::arrange(Sepal.Width)
#   expect_error(case1 <- rtf_group_by_enhance(dt1, "Species", 1))
#
# })

test_that("Test when data is sorted by group_by variable", {
  case2 <- rtf_group_by_enhance(dt, "Species", (1))
  dt2 <- dt
  ls <- c(1:dim(dt2)[1])
  keep <- c(1, 6, 11)
  for (val in ls) {
    if (!(val %in% keep)) (dt2[val, 5] <- NA)
  }
  expect_equal(case2, dt2)
})

test_that("Test if duplicated records are removed in returned dataset", {
  dt3 <- rbind(dt, dt[3, ])
  dt3 <- dplyr::arrange(dt3, Species)
  case3 <- rtf_group_by_enhance(dt3, "Species", (1))

  expect_equal(as.logical(case3[2, 5]), NA)
})

test_that("Test if no records will be deleted when there are no duplicated records", {
  dt4 <- iris[c(1, 51, 101), ] %>% dplyr::arrange(Species)
  case4 <- rtf_group_by_enhance(dt4, "Species", rep(1, 3))

  expect_equal(dt4, case4)
})
