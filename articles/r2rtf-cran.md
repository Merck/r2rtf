# An Introduction to the r2rtf Package

Please see <https://merck.github.io/r2rtf/articles/index.html> for the
full documentation. Here is only a minimal example:

``` r
library(dplyr)
library(r2rtf)

head(iris) %>%
  rtf_body() %>% # Step 1 Add attributes
  rtf_encode() %>% # Step 2 Convert attributes to RTF encode
  write_rtf(file = "ex-tbl.rtf") # Step 3 Write to a .rtf file
```
