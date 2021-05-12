test_that("Case in defalut", {

  x <- iris[1:1,] %>%
       dplyr::select(1) %>%
       rtf_body() %>%
       as_rtf_table() %>%
       strsplit("\n")

  expect_snapshot_output(x[[1]])

})

test_that("Case for border_color_left and border_color_top", {
  x <- iris[1:1,] %>% dplyr::select(1) %>%
        rtf_body(border_color_left='red', border_color_top='blue') %>%
        as_rtf_table() %>%
        strsplit("\n")

  expect_snapshot_output(x[[1]])

})

test_that("Case for having group_by without page_by", {
  x <- iris[1:2, 4:5] %>%
    rtf_body(group_by = "Species") %>%
    as_rtf_table() %>%
    strsplit("\n")

  expect_snapshot_output(x[[1]])

})


# add additional test to increase coverage and for new feature
test_that("Test case when subline is not NULL", {
  x <- iris[c(1:4, 51:54), 3:5] %>%
    mutate(s2 = paste0(Species, 1:2), s3 = s2) %>%
    arrange(Species, s2)%>%
    rtf_body(
      subline_by = "Species",
      page_by = 's2',
    ) %>%
    as_rtf_table() %>%
    strsplit("\n")

  expect_snapshot_output(x[[1]])


  data(r2rtf_adae)
  ae <- r2rtf_adae[200:260,] %>%
    arrange(SITEID, TRTA, USUBJID, ASTDY)

  ae <- ae %>% mutate(AEDECODNUM = as.character(rownames(ae)),
      SUBLINEBY = paste0(
        "Trial Number: ", STUDYID,
        ", Site Number: ", SITEID
      ),
    ) %>%
    select(USUBJID, ASTDY, AEDECODNUM, TRTA,  SUBLINEBY) %>%
    arrange(SUBLINEBY, TRTA,  USUBJID, ASTDY) %>%
    rtf_colheader("Subject| Rel Day | Adverse Code|"
    ) %>%
    rtf_body(
      subline_by = 'SUBLINEBY',
      page_by = c("TRTA"),
      group_by = c("USUBJID", "ASTDY"),
    ) %>%
  as_rtf_table() %>%
    strsplit("\n")

  expect_snapshot_output(ae[[1]])

})


