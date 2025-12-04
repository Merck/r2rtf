# RTF Examples for AE Summary Count Tables

``` r
library(r2rtf)
library(dplyr)
library(tidyr)
```

## Example

This example shows how to create a simplified adverse events summary
table as below.

### Step 1: Create data for RTF table

``` r
data(r2rtf_adae)
ae_t1 <- r2rtf_adae %>%
  group_by(TRTA) %>%
  mutate(n_subj = n_distinct(USUBJID)) %>%
  group_by(TRTA, AEDECOD) %>%
  summarise(
    n_ae = n_distinct(USUBJID),
    pct = round(n_ae / unique(n_subj) * 100, 2)
  ) %>%
  dplyr::filter(n_ae > 5) %>%
  # only show AE terms with at least 5 subjects in one treatment group.
  pivot_longer(cols = c(n_ae, pct), names_to = "var", values_to = "value") %>%
  unite(temp, TRTA, var) %>%
  pivot_wider(names_from = temp, values_from = value, values_fill = 0)
```

    ## `summarise()` has grouped output by 'TRTA'. You can override using the
    ## `.groups` argument.

``` r
knitr::kable(ae_t1)
```

| AEDECOD                           | Placebo_n_ae | Placebo_pct | Xanomeline High Dose_n_ae | Xanomeline High Dose_pct | Xanomeline Low Dose_n_ae | Xanomeline Low Dose_pct |
|:----------------------------------|-------------:|------------:|--------------------------:|-------------------------:|-------------------------:|------------------------:|
| APPLICATION SITE PRURITUS         |            6 |        8.70 |                        22 |                    27.85 |                       22 |                   28.57 |
| DIARRHOEA                         |            9 |       13.04 |                         0 |                     0.00 |                        0 |                    0.00 |
| ERYTHEMA                          |            9 |       13.04 |                        14 |                    17.72 |                       15 |                   19.48 |
| HEADACHE                          |            7 |       10.14 |                         6 |                     7.59 |                        0 |                    0.00 |
| PRURITUS                          |            8 |       11.59 |                        26 |                    32.91 |                       23 |                   29.87 |
| UPPER RESPIRATORY TRACT INFECTION |            6 |        8.70 |                         0 |                     0.00 |                        0 |                    0.00 |
| APPLICATION SITE DERMATITIS       |            0 |        0.00 |                         7 |                     8.86 |                        9 |                   11.69 |
| APPLICATION SITE ERYTHEMA         |            0 |        0.00 |                        15 |                    18.99 |                       12 |                   15.58 |
| APPLICATION SITE IRRITATION       |            0 |        0.00 |                         9 |                    11.39 |                        9 |                   11.69 |
| APPLICATION SITE VESICLES         |            0 |        0.00 |                         6 |                     7.59 |                        0 |                    0.00 |
| DIZZINESS                         |            0 |        0.00 |                        12 |                    15.19 |                        8 |                   10.39 |
| HYPERHIDROSIS                     |            0 |        0.00 |                         8 |                    10.13 |                        0 |                    0.00 |
| NASOPHARYNGITIS                   |            0 |        0.00 |                         6 |                     7.59 |                        0 |                    0.00 |
| NAUSEA                            |            0 |        0.00 |                         6 |                     7.59 |                        0 |                    0.00 |
| RASH                              |            0 |        0.00 |                        11 |                    13.92 |                       13 |                   16.88 |
| SINUS BRADYCARDIA                 |            0 |        0.00 |                         8 |                    10.13 |                        7 |                    9.09 |
| VOMITING                          |            0 |        0.00 |                         7 |                     8.86 |                        0 |                    0.00 |
| COUGH                             |            0 |        0.00 |                         0 |                     0.00 |                        6 |                    7.79 |
| SKIN IRRITATION                   |            0 |        0.00 |                         0 |                     0.00 |                        6 |                    7.79 |

### Step 2: Define table format

``` r
ae_tbl <- ae_t1 %>%
  rtf_title(
    "Analysis of Subjects With Specific Adverse Events",
    c(
      "(Incidence > 5 Subjects in One or More Treatment Groups)",
      "ASaT"
    )
  ) %>%
  rtf_colheader(" | Placebo | Drug High Dose | Drug Low Dose",
    col_rel_width = c(4, rep(2, 3))
  ) %>%
  rtf_colheader(" | n | (%) | n | (%) | n | (%)",
    col_rel_width = c(4, rep(1, 6)),
    border_top = c("", rep("single", 6)),
    border_left = c("single", rep(c("single", ""), 3))
  ) %>%
  rtf_body(
    col_rel_width = c(4, rep(1, 6)),
    text_justification = c("l", rep("c", 6)),
    border_left = c("single", rep(c("single", ""), 3))
  ) %>%
  rtf_footnote(c("{^\\dagger}This is footnote 1", "This is footnote 2"), ) %>%
  rtf_source("Source: xxx")
```

### Step 3: Output

``` r
# Output .rtf file
ae_tbl %>%
  rtf_encode() %>%
  write_rtf("rtf/ae_example.rtf")
```
