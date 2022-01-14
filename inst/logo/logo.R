sysfonts::font_add("Invention", regular = "Invention_Lt.ttf")

hexSticker::sticker(
  subplot = ~ plot.new(), s_x = 1, s_y = 1, s_width = 0.1, s_height = 0.1,
  package = "r2rtf", p_family = "Invention",
  p_color = "#ffffff", p_x = 1, p_y = 1.05, p_size = 40,
  h_fill = "#00857c", h_color = "#005c55", h_size = 1.2,
  filename = "man/figures/logo.png", dpi = 320
)

magick::image_read("man/figures/logo.png")

rstudioapi::restartSession()
