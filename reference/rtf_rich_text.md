# Text to Formatted RTF Encode

Text to Formatted RTF Encode

## Usage

``` r
rtf_rich_text(
  text,
  theme = list(.emph = list(format = "i"), .strong = list(format = "b"))
)
```

## Arguments

- text:

  Plain text.

- theme:

  Named list defining themes for tags. See `rtf_text()` for details on
  possible formatting.

## Specification

The contents of this section are shown in PDF user manual only.

## Examples

``` r
rtf_rich_text(
  text = paste(
    "This is {.emph important}.",
    "This is {.strong relevant}.", "This is {.zebra ZEBRA}."
  ),
  theme = list(
    .emph = list(format = "i"),
    .strong = list(format = "b"),
    .zebra = list(color = "white", background_color = "black")
  )
)
#>      [,1]                                                                                                                                           
#> [1,] "\\fs24{\\f0 This is \\fs24{\\f0\\i important}. This is \\fs24{\\f0\\b relevant}. This is \\fs24{\\f0\\cf1\\chshdng0\\chcbpat24\\cb24 ZEBRA}.}"
```
