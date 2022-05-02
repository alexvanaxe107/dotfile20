from libqtile import bar, widget
from theme import colors, bar_configs, theme_name

if theme_name == "night":
    myBar = bar.Bar(
                [
                    widget.CurrentScreen(active_text='', inactive_text=''),
                    widget.CurrentLayoutIcon(scale=0.7, foreground=colors['bar_foreground']),
                    widget.CurrentLayout(foreground=colors['bar_foreground'], **bar_configs),
                    widget.GroupBox(**bar_configs, foreground=colors['bar_foreground'], inactive=colors['bar_foreground']),
                    widget.Prompt(foreground=colors['bar_foreground'], **bar_configs),
                    widget.WindowName(**bar_configs),
                    widget.Chord(
                        chords_colors={
                            "launch": ("#ff0000", "#ffffff"),
                        },
                        name_transform=lambda name: name.upper(),
                    ),
                    widget.CPU(format='🏿 {load_percent}%', foreground=colors['bar_foreground'], **bar_configs),
                    widget.CPUGraph(),
                    widget.Memory(format='👣 {MemUsed: .0f}{ms}/{MemTotal: .0f}{ms}', measure_mem='M', foreground=colors['bar_foreground'], **bar_configs),
                    widget.MemoryGraph(),
                    widget.Memory(format=' {SwapUsed: .0f}{ms}/{SwapTotal: .0f}{ms}', measure_swap='G', foreground=colors['bar_foreground'], **bar_configs),
                    # widget.Spacer(length=10, background='#000000'),
                    # widget.Systray(),
                    widget.Clock(format="%Y-%m-%d %a %I:%M %p", foreground=colors['bar_foreground'], **bar_configs),
                    widget.PulseVolume(foreground=colors['bar_foreground'], **bar_configs)
                ],
                24,
                background=colors['bar_background'],
                margin=[0, 16, 0, 16] # Margin = N E S W
                
                # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
                # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
            )
elif theme_name == "day":
    myBar = bar.Bar(
                [
                    widget.CurrentScreen(active_text='', inactive_text=''),
                    widget.CurrentLayoutIcon(scale=0.7, foreground=colors['bar_foreground']),
                    widget.CurrentLayout(foreground=colors['bar_foreground'], **bar_configs),
                    widget.GroupBox(**bar_configs, foreground=colors['bar_foreground'], inactive=colors['bar_foreground']),
                    widget.Prompt(foreground=colors['bar_foreground'], **bar_configs),
                    widget.WindowName(**bar_configs),
                    widget.Chord(
                        chords_colors={
                            "launch": ("#ff0000", "#ffffff"),
                        },
                        name_transform=lambda name: name.upper(),
                    ),
                    widget.CPU(format='🏿 {load_percent}%', foreground=colors['bar_foreground'], **bar_configs),
                    widget.CPUGraph(),
                    widget.Memory(format='👣 {MemUsed: .0f}{ms}/{MemTotal: .0f}{ms}', measure_mem='M', foreground=colors['bar_foreground'], **bar_configs),
                    widget.MemoryGraph(),
                    widget.Memory(format=' {SwapUsed: .0f}{ms}/{SwapTotal: .0f}{ms}', measure_swap='G', foreground=colors['bar_foreground'], **bar_configs),
                    # widget.Spacer(length=10, background='#000000'),
                    # widget.Systray(),
                    widget.Clock(format="%Y-%m-%d %a %I:%M %p", foreground=colors['bar_foreground'], **bar_configs),
                    widget.PulseVolume(foreground=colors['bar_foreground'], **bar_configs)
                ],
                24,
                background=colors['bar_background'],
                margin=[0, 16, 0, 16] # Margin = N E S W
                
                # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
                # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
            )
