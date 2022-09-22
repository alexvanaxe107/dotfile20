local wezterm = require 'wezterm'

toReturn = {}

theme_name = "PaperColorLight (Gogh)"
if os.getenv("theme_name") == "day" then
    font_name = "JetBrains Mono"
elseif os.getenv("theme_name") == "night" then
    font_name = "Iosevka"
else
    font_name = "JetBrains Mono"
end

toReturn['color_scheme'] = theme_name
toReturn['font'] = wezterm.font(font_name)
toReturn['font_size'] = 11 
toReturn['window_decorations'] = "NONE"
toReturn['hide_tab_bar_if_only_one_tab'] = true

if os.getenv("theme_name") == "day" then
    toReturn['window_background_opacity'] = 0.9
elseif os.getenv("theme_name") == "night" then
    toReturn['window_background_opacity'] = 0.6
else
    toReturn['window_background_opacity'] = 1.0
end

return toReturn
