require 'yaml'
require_relative 'lambdas'

COLOR = YAML.load_file('lib/color_names.yml')

def determine_fg(bg_color)
  get_luminance(bg_color).round(1) >= 0.5 ? '#000' : '#FFF'
end

def get_luminance(color)
  color      = to_hex(color)
  r, g, b, a = HEX[:parts].call(color).map{|h| h.length < 2 ? "#{h}#{h}" : h}.map{|p| HEX[:from].call(p)}

  [ r*LUMA[:r] + g*LUMA[:g] + b*LUMA[:b] ].sum / 255.0
end

def hex_to_rgb(hex)
  "rgb(#{HEX[:parts].call(hex).map{|p| HEX[:from].call(p)}.join(', ')})"
end

def hex_to_rgba(hex)
  parts   = HEX[:parts].call(hex)
  opacity = parts[3] || 'FF'

  if opacity.length == 1
    unless opacity == '0' 
      opacity = "#{opacity}E"
    end
  end

  "rgba(#{(parts.first(3).map{|p| HEX[:from].call(p)} + [RGBA[:to].call(opacity)]).join(', ')})"
end

def name_to_hex(color)
  color.downcase!

  ckey = COLOR.keys.select{|n| n.downcase.match?(/^#{color}$/)}.first
  "##{COLOR[ckey]}"
end

def name_to_rgb(color)
  hex_to_rgb(name_to_hex(color))
end

def rgb_to_hex(rgb)
  '#' + RGB[:parts].call(rgb).map{|p| HEX[:to].call(p)}.join.upcase
end

def rgba_to_hex(rgba)
  parts = RGBA[:parts].call(rgba)

  '#' + parts.first(3).map{|p| HEX[:to].call(p)}.join.upcase + RGBA[:from].call(parts.last.to_f).upcase
end

def sort_luminance(c1, c2)
  l1, l2 = get_luminance(c1), get_luminance(c2)

  case
  when l1 < l2
    return -1
  when l1 == l2
    return 0
  when l1 > l2
    return 1
  end
end

def to_hex(color)
  case color
  when /^rgba/
    return rgba_to_hex(color)
  when /^rgb/
    return rgb_to_hex(color)
  when /^#/
    return color.upcase
  else 
    return name_to_hex(color)
  end
end
