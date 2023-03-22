local wezterm = require 'wezterm'
local extra = require 'extra'

local function isempty(s)
  return s == nil or s == ''
end

toReturn = {}

theme_name = ""
custom_term_font = ""
if os.getenv("theme_name") == "day" then
    font_name = "JetBrains Mono"
elseif os.getenv("theme_name") == "night" then
    font_name = "Iosevka"
else
    font_name = "JetBrains Mono"
end

if not isempty(custom_term_font) then
    font_name = custom_term_font
end
toReturn['front_end'] = "WebGpu"
toReturn['adjust_window_size_when_changing_font_size'] = false

toReturn['color_scheme'] = theme_name
toReturn['font'] = wezterm.font(font_name)
toReturn['font_size'] = 11 
toReturn['window_decorations'] = "NONE"
toReturn['hide_tab_bar_if_only_one_tab'] = true

if extra.custom_colors == true then
    toReturn['colors'] = extra.colors
end

if os.getenv("theme_name") == "day" then
    toReturn['window_background_opacity'] = 0.9
elseif os.getenv("theme_name") == "night" then
    toReturn['window_background_opacity'] = 0.78
elseif os.getenv("theme_name") == "shabbat" then
    toReturn['window_background_opacity'] = 0.95
else
    toReturn['window_background_opacity'] = 1.0
end

return toReturn
