# RTF Examples for Tables with Sublineby, Pageby, and Groupby Features

``` r
library(r2rtf)
library(dplyr)
library(tidyr)
```

## Overview

In [`rtf_body()`](https://merck.github.io/r2rtf/reference/rtf_body.md),
`r2rtf` provided three advanced arguments to customize table layout.

- `page_by`: The variable is used as section header.  
- `group_by`: The variable only display when it is first appeared.
- `subline_by`: The variable is used as page subline header.

If one or more of the arguments are used, they need to be properly
ordered in `subline_by`, `page_by` and `group_by`.

For `page_by`, the argument `new_page` and `pageby_header` and
`pageby_row` further customize the table layout. Details can be found in
the [`rtf_body()`](https://merck.github.io/r2rtf/reference/rtf_body.md)
documentation.

We provided three examples below to illustrate the idea.

## Example 1: Pageby

We used `page_by` variable to illustrate how to create a simple
disposition table.

> Note: This example also illustrate how to avoid row header by setting
> corresponding value in `page_by` variable to `"-----"`.

### Step 1: Create data for RTF table

``` r
data(r2rtf_adsl)
adsl <- r2rtf_adsl

# randomized
row1 <- adsl %>%
  subset(ITTFL == "Y") %>%
  group_by(TRT01P) %>%
  count()

# treated
row2 <- adsl %>%
  subset(SAFFL == "Y") %>%
  group_by(TRT01P) %>%
  summarise(trtn = n())

# completed study
row3 <- adsl %>%
  subset(SAFFL == "Y" & DCREASCD == "Completed") %>%
  group_by(TRT01P) %>%
  summarise(cmpln = n())

# discontinued study
row4 <- adsl %>%
  subset(SAFFL == "Y" & DCREASCD != "Completed") %>%
  group_by(TRT01P) %>%
  summarise(dcn = n())

# discontinuation reason
reas <- adsl %>%
  subset(SAFFL == "Y" & DCREASCD != "Completed") %>%
  group_by(TRT01P, DCREASCD) %>%
  summarise(reasn = n())
```

    ## `summarise()` has grouped output by 'TRT01P'. You can override using the
    ## `.groups` argument.

``` r
ds <- rbind(
  row1 %>% merge(row2, by = "TRT01P") %>%
    merge(row3, by = "TRT01P") %>%
    merge(row4, by = "TRT01P") %>%
    pivot_longer(2:5, names_to = "DCREASCD", values_to = "n") %>%
    pivot_wider(names_from = TRT01P, values_from = "n"),
  reas %>% pivot_wider(names_from = TRT01P, values_from = c("reasn"))
) %>%
  mutate(
    DCREASCD = ifelse(DCREASCD == "n", "Participants randomized",
      ifelse(DCREASCD == "trtn", "Participants treated",
        ifelse(DCREASCD == "cmpln", "Participants completed",
          ifelse(DCREASCD == "dcn", "Participants discontinued", paste0("   ", DCREASCD))
        )
      )
    ),
    pagebyvar = ifelse(substr(DCREASCD, 1, 5) == "Parti", "-----", "Discontinued reason")
  ) %>%
  # pagebyvar will be assigned to page_by argument in rtf_body function later.
  # then table will be grouped by single cell row with pagebyvar's value in it.
  # if pagebyvar's value is "-----", the single cell row will be removed from table.

  select(pagebyvar, DCREASCD, "Xanomeline High Dose", "Xanomeline Low Dose", Placebo)

ds[is.na(ds)] <- 0
```

``` r
knitr::kable(head(ds))
```

| pagebyvar           | DCREASCD                  | Xanomeline High Dose | Xanomeline Low Dose | Placebo |
|:--------------------|:--------------------------|---------------------:|--------------------:|--------:|
| —–                  | Participants randomized   |                   84 |                  84 |      86 |
| —–                  | Participants treated      |                   84 |                  84 |      86 |
| —–                  | Participants completed    |                   27 |                  25 |      58 |
| —–                  | Participants discontinued |                   57 |                  59 |      28 |
| Discontinued reason | Adverse Event             |                   40 |                  44 |       8 |
| Discontinued reason | Death                     |                    0 |                   1 |       2 |

### Step 2: Define table format

``` r
ds_tbl <- ds %>%
  rtf_title("Disposition of Participants", "(ITT Population)") %>%
  rtf_colheader(" | Xanomeline High Dose |Xanomeline Low Dose | Placebo",
    col_rel_width = c(3, 2, 2, 2)
  ) %>%
  rtf_colheader(" | n | n | n ",
    border_top = c("", rep("single", 3)),
    col_rel_width = c(3, rep(2, 3))
  ) %>%
  # the table will be grouped by single cell row with pagebyvar's value in it.
  # if pagebyvar's value is "-----", the single cell row will be removed from table.
  rtf_body(
    page_by = "pagebyvar",
    col_rel_width = c(1, 3, 2, 2, 2),
    text_justification = c("l", "l", rep("c", 3)),
    text_format = c("b", rep("", 4)),
    border_top = c("single", rep("", 4)),
    border_bottom = c("single", rep("", 4)),
  ) %>%
  rtf_footnote(c("This is footnote")) %>%
  rtf_source("Source:  [Study CDISCPILOT01: adam-adsl]")
```

### Step 3: Output

``` r
# Output .rtf file
ds_tbl %>%
  rtf_encode() %>%
  write_rtf("rtf/pageby-disposition.rtf")
```

## Example 2: Pageby with `pageby_row = "first_row"`

We used `page_by` variable and `pageby_row = "first_row"` to illustrate
how to create a simple adverse events table.

### Step 1: Create data for RTF table

``` r
# Read in and merge r2rtf_adsl and r2rtf_adae data
data(r2rtf_adsl)
data(r2rtf_adae)

ana <- r2rtf_adsl %>%
  subset(SAFFL == "Y") %>%
  select(USUBJID, TRT01AN, TRT01A)

# inner join adsl to bring in TRT01AN
aedata <- inner_join(ana, r2rtf_adae, by = "USUBJID") %>%
  filter(AEDECOD != "" & SAFFL == "Y" & AESEV == "SEVERE") %>%
  mutate(
    AEDECOD = tolower(AEDECOD),
    AEBODSYS = tolower(AEBODSYS)
  )

# participants part
overall <- ana %>%
  group_by(TRT01AN) %>%
  summarise(n = n_distinct(USUBJID)) %>%
  mutate(AEDECOD = "Participants in population")

withAE <- aedata %>%
  group_by(TRT01AN) %>%
  summarise(withAE = n_distinct(USUBJID)) %>%
  mutate(AEDECOD = "  with one or more severe AE") %>%
  rename(n = withAE)

woAE <- left_join(overall, withAE, by = "TRT01AN", suffix = c(".x", ".y")) %>%
  mutate(
    woAE = n.x - n.y,
    AEDECOD = "  with no severe AE"
  ) %>%
  select(TRT01AN, AEDECOD, woAE) %>%
  rename(n = woAE)

part1 <- bind_rows(overall, withAE, woAE) %>%
  pivot_wider(names_from = TRT01AN, values_from = n) %>%
  mutate(AEBODSYS = "  a")

# AE part
bodsys <- aedata %>%
  group_by(TRT01AN, AEBODSYS) %>%
  summarise(n = n_distinct(USUBJID))

decod <- aedata %>%
  group_by(TRT01AN, AEBODSYS, AEDECOD) %>%
  summarise(n = n_distinct(USUBJID)) %>%
  arrange(AEBODSYS, AEDECOD)

part2 <- bind_rows(bodsys, decod) %>%
  pivot_wider(names_from = TRT01AN, values_from = n, values_fill = 0) %>%
  arrange(AEBODSYS, !is.na(AEDECOD)) %>%
  mutate(AEDECOD = ifelse(is.na(AEDECOD), AEBODSYS, paste("  ", AEDECOD)))

blank <- tibble(AEBODSYS = "  a")

apr0ae <- bind_rows(part1, blank, part2)
```

``` r
knitr::kable(head(apr0ae))
```

| AEDECOD                    |   0 |  54 |  81 | AEBODSYS          |
|:---------------------------|----:|----:|----:|:------------------|
| Participants in population |  86 |  84 |  84 | a                 |
| with one or more severe AE |   7 |  16 |   8 | a                 |
| with no severe AE          |  79 |  68 |  76 | a                 |
| NA                         |  NA |  NA |  NA | a                 |
| cardiac disorders          |   3 |   0 |   1 | cardiac disorders |
| atrial fibrillation        |   0 |   0 |   1 | cardiac disorders |

### Step 2: Define table format

``` r
apr0ae_rtf <- apr0ae %>%
  rtf_page(orientation = "landscape") %>%
  rtf_title(c("Participants with Severe Adverse Events", "(Incidence \\geq 0% in One or More Treatment Groups)"), "(ASaT Population)") %>%
  rtf_colheader(" | Placebo | Xanomeline Low Dose| Xanomeline High Dose  ",
    col_rel_width = c(5, 2, 2, 2),
    border_bottom = c("", rep("single", 3))
  ) %>%
  rtf_colheader(" | n |  n  | n  ",
    border_top    = c("", rep("single", 3)),
    border_bottom = "single",
    col_rel_width = c(5, rep(2, 3)),
  ) %>%
  rtf_body(
    col_rel_width = c(5, rep(2, 3), 1),
    text_justification = c("l", "c", "c", "c", "l"),
    border_first = "",
    page_by = "AEBODSYS",
    pageby_row = "first_row",
  ) %>%
  rtf_footnote(c("This is footnote")) %>%
  rtf_source("Source:  [Study CDISCPILOT01: adam-adae]")
```

### Step 3: Output

``` r
# Output .rtf file
apr0ae_rtf %>%
  rtf_encode() %>%
  write_rtf("rtf/pageby-firstrow-ae.rtf")
```

## Example 3: sublineby, pageby, and groupby features

We used `page_by`, `subline_by` and `group_by` to illustrate how to
create a simple adverse events listing.

### Step 1: Create data for RTF table

``` r
data(r2rtf_adae)

ae_t1 <- r2rtf_adae[200:260, ] %>%
  mutate(
    SUBLINEBY = paste0(
      "Trial Number: ", STUDYID,
      ", Site Number: ", SITEID
    ),
    SUBJLINE = paste0(
      "Subject ID = ", USUBJID,
      ", Gender = ", SEX,
      ", Race = ", RACE,
      ", AGE = ", AGE, " Years",
      ", TRT = ", TRTA
    ),
    # create a subject line with participant's demographic information.
    # this is for page_by argument in rtf_body function
    AEDECD1 = tools::toTitleCase(AEDECOD), # propcase the AEDECOD
    DUR = paste(ADURN, ADURU, sep = " ")
  ) %>% # AE duration with unit
  select(USUBJID, ASTDY, AEDECD1, DUR, AESEV, AESER, AEREL, AEACN, AEOUT, TRTA, SUBJLINE, SUBLINEBY) # display variable using this order
```

``` r
knitr::kable(head(ae_t1, 2))
```

|     | USUBJID     | ASTDY | AEDECD1                   | DUR | AESEV    | AESER | AEREL    | AEACN | AEOUT                      | TRTA                 | SUBJLINE                                                                                       | SUBLINEBY                                    |
|:----|:------------|------:|:--------------------------|:----|:---------|:------|:---------|:------|:---------------------------|:---------------------|:-----------------------------------------------------------------------------------------------|:---------------------------------------------|
| 200 | 01-701-1360 |     3 | APPLICATION SITE PRURITUS | NA  | MODERATE | N     | PROBABLE |       | NOT RECOVERED/NOT RESOLVED | Xanomeline High Dose | Subject ID = 01-701-1360, Gender = M, Race = WHITE, AGE = 67 Years, TRT = Xanomeline High Dose | Trial Number: CDISCPILOT01, Site Number: 701 |
| 201 | 01-701-1360 |     6 | APPLICATION SITE VESICLES | NA  | MODERATE | N     | PROBABLE |       | NOT RECOVERED/NOT RESOLVED | Xanomeline High Dose | Subject ID = 01-701-1360, Gender = M, Race = WHITE, AGE = 67 Years, TRT = Xanomeline High Dose | Trial Number: CDISCPILOT01, Site Number: 701 |

### Step 2: Define table format

``` r
ae_tbl <- ae_t1 %>%
  # It is important to order variable properly.
  arrange(SUBLINEBY, TRTA, SUBJLINE, USUBJID, ASTDY) %>%
  rtf_page(orientation = "landscape", col_width = 9) %>%
  rtf_page_header() %>%
  rtf_page_footer(text = "This is Page Footer Information") %>%
  rtf_title(
    "Listing of Subjects With Serious Adverse Events",
    "ASaT"
  ) %>%
  rtf_colheader("Subject| Rel Day | Adverse | | | | |Action| |",
    col_rel_width = c(2.5, 2, 4, 2, 3, 2, 3, 2, 5)
  ) %>%
  rtf_colheader("ID| of Onset | Event | Duration | Intensity | Serious |
                Related | Taken| Outcome",
    border_top = "",
    col_rel_width = c(2.5, 2, 4, 2, 3, 2, 3, 2, 5)
  ) %>%
  rtf_body(
    col_rel_width = c(2.5, 2, 4, 2, 3, 2, 3, 2, 5, 1, 1, 1),
    text_justification = c("l", rep("c", 8), "l", "l", "l"),
    text_format = c(rep("", 9), "b", "", "b"),
    border_top = c(rep("", 9), "single", "single", "single"),
    border_bottom = c(rep("", 9), "single", "single", "single"),
    subline_by = "SUBLINEBY",
    page_by = c("TRTA", "SUBJLINE"),
    group_by = c("USUBJID", "ASTDY")
  ) %>%
  rtf_footnote(c("This is footnote 1")) %>%
  rtf_source("Source:  [Study CDISCPILOT01: adam-adae]")
```

### Step 3: Output

``` r
# Output .rtf file
ae_tbl %>%
  rtf_encode() %>%
  write_rtf("rtf/pageby-ae-listing.rtf")
```
