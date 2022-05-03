#---- Generated by tint2conf 6bba ----
# See https://gitlab.com/o9000/tint2/wikis/Configure for 
# full documentation of the configuration options.
#-------------------------------------
# Gradients
#-------------------------------------
# Backgrounds
# Background 1: Panel, Separator
rounded = 5
border_width = 1
border_sides = TBLR
border_content_tint_weight = 0
background_content_tint_weight = 0
background_color = #000001 75
border_color = #555555 80
background_color_hover = #000001 80
border_color_hover = #555555 80
background_color_pressed = #000000 80
border_color_pressed = #555555 80

# Background 2: Default task, Iconified task
rounded = 5
border_width = 1
border_sides = TBLR
border_content_tint_weight = 0
background_content_tint_weight = 0
background_color = #777777 0
border_color = #777777 10
background_color_hover = #777777 4
border_color_hover = #cccccc 30
background_color_pressed = #333333 4
border_color_pressed = #777777 30

# Background 3: Active task
rounded = 5
border_width = 1
border_sides = TBLR
border_content_tint_weight = 0
background_content_tint_weight = 0
background_color = #000002 75
border_color = #ffffff 60
background_color_hover = #000001 10
border_color_hover = #ffffff 60
background_color_pressed = #555555 10
border_color_pressed = #ffffff 60

# Background 4: Urgent task
rounded = 5
border_width = 1
border_sides = TBLR
border_content_tint_weight = 0
background_content_tint_weight = 0
background_color = #aa4400 100
border_color = #aa7733 100
background_color_hover = #aa4400 100
border_color_hover = #aa7733 100
background_color_pressed = #aa4400 100
border_color_pressed = #aa7733 100

# Background 5: Tooltip
rounded = 2
border_width = 1
border_sides = TBLR
border_content_tint_weight = 0
background_content_tint_weight = 0
background_color = #ffffaa 100
border_color = #999999 100
background_color_hover = #ffffaa 100
border_color_hover = #999999 100
background_color_pressed = #ffffaa 100
border_color_pressed = #999999 100

# Background 6: Inactive desktop name
rounded = 2
border_width = 1
border_sides = TBLR
border_content_tint_weight = 0
background_content_tint_weight = 0
background_color = #000005 75
border_color = #777777 30
background_color_hover = #777777 4
border_color_hover = #cccccc 30
background_color_pressed = #777777 0
border_color_pressed = #777777 30

# Background 7: Active desktop name
rounded = 2
border_width = 1
border_sides = TB
border_content_tint_weight = 0
background_content_tint_weight = 0
background_color = #000003 75
border_color = #ffffff 60
background_color_hover = #000003 10
border_color_hover = #ffffff 60
background_color_pressed = #555555 10
border_color_pressed = #ffffff 60

# Background 8: Executor
rounded = 2
border_width = 0
border_sides = 
border_content_tint_weight = 0
background_content_tint_weight = 0
background_color = #000004 75
border_color = #ffffff 60
background_color_hover = #000003 10
border_color_hover = #ffffff 60
background_color_pressed = #555555 10
border_color_pressed = #ffffff 60

#-------------------------------------
# Panel
panel_items = C:EEEEEEEEE:T:S
panel_size = 99% 8%
panel_margin = 0 0
panel_padding = 2 2 2
panel_background_id = 1
wm_menu = 1
panel_dock = 0
panel_pivot_struts = 0
panel_position = center left vertical
panel_layer = normal
panel_monitor = 1
primary_monitor_first = 1
panel_shrink = 0
autohide = 0
autohide_show_timeout = 0
autohide_hide_timeout = 0.5
autohide_height = 2
strut_policy = follow_size
panel_window_name = tint2
disable_transparency = 0
mouse_effects = 1
font_shadow = 0
mouse_hover_icon_asb = 100 0 10
mouse_pressed_icon_asb = 100 1 0
scale_relative_to_dpi = 0
scale_relative_to_screen_height = 0

#-------------------------------------
# Taskbar
taskbar_mode = multi_desktop
taskbar_hide_if_empty = 0
taskbar_padding = 0 0 2
taskbar_background_id = 1
taskbar_active_background_id = 0
taskbar_name = 1
taskbar_hide_inactive_tasks = 0
taskbar_hide_different_monitor = 0
taskbar_hide_different_desktop = 0
taskbar_always_show_all_desktop_tasks = 0
taskbar_name_padding = 6 3
taskbar_name_background_id = 6
taskbar_name_active_background_id = 7
taskbar_name_font = Erica Type bold 9
taskbar_name_font_color = #000006 100
taskbar_name_active_font_color = #000006 100
taskbar_distribute_size = 0
taskbar_sort_order = none
task_align = center

#-------------------------------------
# Task
task_text = 1
task_icon = 1
task_centered = 1
urgent_nb_of_blink = 100000
task_maximum_size = 152 35
task_padding = 4 3 4
task_font = Erica Type 8
task_tooltip = 1
task_thumbnail = 0
task_thumbnail_size = 210
task_font_color = #000006 100
task_icon_asb = 100 0 0
task_background_id = 2
task_active_background_id = 3
task_urgent_background_id = 4
task_iconified_background_id = 2
mouse_left = toggle_iconify
mouse_middle = none
mouse_right = close
mouse_scroll_up = prev_task
mouse_scroll_down = next_task

#-------------------------------------
# System tray (notification area)
systray_padding = 0 0 2
systray_background_id = 0
systray_sort = ascending
systray_icon_size = 22
systray_icon_asb = 100 0 0
systray_monitor = 1
systray_name_filter = 

#-------------------------------------
# Launcher
launcher_padding = 0 0 2
launcher_background_id = 0
launcher_icon_background_id = 0
launcher_icon_size = 22
launcher_icon_asb = 100 0 0
launcher_icon_theme_override = 0
startup_notifications = 1
launcher_tooltip = 1
launcher_item_app = tint2conf.desktop
launcher_item_app = firefox.desktop
launcher_item_app = iceweasel.desktop
launcher_item_app = chromium-browser.desktop
launcher_item_app = google-chrome.desktop
launcher_item_app = x-terminal-emulator.desktop

#-------------------------------------
# Clock
time1_format = %H:%M
time2_format = %A %d %B
time1_font = Erica Type 9
time1_timezone = 
time2_timezone = 
time2_font = Erica Type 9
clock_font_color = #000006 100
clock_padding = 1 0
clock_background_id = 0
clock_tooltip = 
clock_tooltip_timezone = 
clock_lclick_command = zenity --calendar --text ""
clock_rclick_command = orage
clock_mclick_command = 
clock_uwheel_command = 
clock_dwheel_command = 

#-------------------------------------
# Battery
battery_tooltip = 1
battery_low_status = 10
battery_low_cmd = xmessage 'tint2: Battery low!'
battery_full_cmd = 
bat1_font = sans 8
bat2_font = sans 6
battery_font_color = #eeeeee 100
bat1_format = 
bat2_format = 
battery_padding = 1 0
battery_background_id = 0
battery_hide = 101
battery_lclick_command = 
battery_rclick_command = 
battery_mclick_command = 
battery_uwheel_command = 
battery_dwheel_command = 
ac_connected_cmd = 
ac_disconnected_cmd = 

#-------------------------------------
# Separator 1
separator = new
separator_background_id = 1
separator_color = #777777 0
separator_style = line
separator_size = 3
separator_padding = 1 3

#-------------------------------------
# Separator 2
separator = new
separator_background_id = 1
separator_color = #777777 0
separator_style = line
separator_size = 3
separator_padding = 1 0

#-------------------------------------
# Separator 3
separator = new
separator_background_id = 1
separator_color = #777777 0
separator_style = line
separator_size = 3
separator_padding = 10 3

#-------------------------------------
# Executor 1
execp = new
execp_command = load
execp_interval = 5
execp_has_icon = 0
execp_cache_icon = 0
execp_continuous = 0
execp_markup = 1
execp_lclick_command = 
execp_rclick_command = 
execp_mclick_command = 
execp_uwheel_command = 
execp_dwheel_command = 
execp_font = Erica Type 10
execp_font_color = #000006 100
execp_padding = 0 0
execp_background_id = 8
execp_centered = 1
execp_icon_w = 0
execp_icon_h = 0

#-------------------------------------
# Executor 2
execp = new
execp_command = pomodoro_stats.sh
execp_interval = 1
execp_has_icon = 0
execp_cache_icon = 1
execp_continuous = 0
execp_markup = 1
execp_lclick_command = 
execp_rclick_command = 
execp_mclick_command = 
execp_uwheel_command = 
execp_dwheel_command = 
execp_font = Pomodoro 10
execp_font_color = #000006 100
execp_padding = 0 0
execp_background_id = 8
execp_centered = 1
execp_icon_w = 0
execp_icon_h = 0

#-------------------------------------
# Executor 3
execp = new
execp_command = psuinfo -Ia
execp_interval = 3
execp_has_icon = 1
execp_cache_icon = 1
execp_continuous = 0
execp_markup = 1
execp_lclick_command = 
execp_rclick_command = 
execp_mclick_command = 
execp_uwheel_command = 
execp_dwheel_command = 
execp_font = Erica Type 10
execp_font_color = #000006 100
execp_padding = 0 0
execp_background_id = 8
execp_centered = 1
execp_icon_w = 15
execp_icon_h = 15

#-------------------------------------
# Executor 4
execp = new
execp_command = psuinfo -Ic
execp_interval = 3
execp_has_icon = 1
execp_cache_icon = 1
execp_continuous = 0
execp_markup = 1
execp_lclick_command = 
execp_rclick_command = 
execp_mclick_command = 
execp_uwheel_command = 
execp_dwheel_command = 
execp_font = Erica Type 10
execp_font_color = #000006 100
execp_padding = 0 0
execp_background_id = 8
execp_centered = 1
execp_icon_w = 15
execp_icon_h = 15

#-------------------------------------
# Executor 5
execp = new
execp_command = torrent
execp_interval = 3600
execp_has_icon = 0
execp_cache_icon = 1
execp_continuous = 0
execp_markup = 1
execp_lclick_command = 
execp_rclick_command = 
execp_mclick_command = 
execp_uwheel_command = 
execp_dwheel_command = 
execp_font = Iosevka Bold 10
execp_font_color = #2A2C2E 100
execp_padding = 0 0
execp_background_id = 8
execp_centered = 1
execp_icon_w = 0
execp_icon_h = 0

#-------------------------------------
# Executor 6
execp = new
execp_command = weather.sh
execp_interval = 3600
execp_has_icon = 0
execp_cache_icon = 1
execp_continuous = 0
execp_markup = 1
execp_lclick_command = 
execp_rclick_command = 
execp_mclick_command = 
execp_uwheel_command = 
execp_dwheel_command = 
execp_font = Erica Type 10
execp_font_color = #000006 100
execp_padding = 0 0
execp_background_id = 8
execp_centered = 1
execp_icon_w = 0
execp_icon_h = 0

#-------------------------------------
# Executor 7
execp = new
execp_command = indicators.sh
execp_interval = 5
execp_has_icon = 0
execp_cache_icon = 0
execp_continuous = 0
execp_markup = 1
execp_lclick_command = 
execp_rclick_command = 
execp_mclick_command = 
execp_uwheel_command = 
execp_dwheel_command = 
execp_font = Erica Type 10
execp_font_color = #000006 100
execp_padding = 0 0
execp_background_id = 8
execp_centered = 1
execp_icon_w = 15
execp_icon_h = 15

#-------------------------------------
# Executor 8
execp = new
execp_command = t2ec --wifi
execp_interval = 5
execp_has_icon = 1
execp_cache_icon = 0
execp_continuous = 0
execp_markup = 1
execp_lclick_command = 
execp_rclick_command = 
execp_mclick_command = 
execp_uwheel_command = 
execp_dwheel_command = 
execp_font = Erica Type 10
execp_font_color = #000006 100
execp_padding = 0 0
execp_background_id = 8
execp_centered = 1
execp_icon_w = 15
execp_icon_h = 15

#-------------------------------------
# Executor 9
execp = new
execp_command = volume_display
execp_interval = 5
execp_has_icon = 0
execp_cache_icon = 0
execp_continuous = 0
execp_markup = 1
execp_lclick_command = 
execp_rclick_command = 
execp_mclick_command = 
execp_uwheel_command = 
execp_dwheel_command = 
execp_font = Erica Type 10
execp_font_color = #000006 100
execp_padding = 0 0
execp_background_id = 8
execp_centered = 1
execp_icon_w = 15
execp_icon_h = 15

#-------------------------------------
# Tooltip
tooltip_show_timeout = 0.5
tooltip_hide_timeout = 0.1
tooltip_padding = 2 2
tooltip_background_id = 5
tooltip_font_color = #222222 100
tooltip_font = Erica Type 9

