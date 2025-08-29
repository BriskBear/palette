HEX = {
  from: ->(hex) { hex.to_i(16) },
  parts: ->(hex) { hex.gsub!(/^#/, '') ; hex.length < 5 ? hex.chars.to_a : hex.chars.each_slice(2).map(&:join).to_a },
  to: ->(int) { int.to_i.to_s(16) }
}

LUMA = {
  b: 0.0722,
  g: 0.7152,
  r: 0.2126
}

RGB = {
  parts: ->(rgb) { rgb.gsub(/[(rgba?\()(\))]/, '').split(',').map{|h| h.gsub(/\s/,'')} }
}

RGBA = {
  from: ->(rgba) { (rgba * 255).round.to_s(16) },
  parts: ->(rgba) { RGB[:parts].call(rgba) },
  to: ->(hex) { (hex.to_i(16) / 255.0).round(2) }
}

