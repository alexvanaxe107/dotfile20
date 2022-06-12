import subprocess

from libqtile import bar, widget
from theme import colors, bar_configs, theme_name


def get_separator(ending=None):
    if not ending:
        return widget.TextBox(fmt='', font='Symbols Nerd Font',
                       fontsize=40,
                       foreground=colors['bar_background_fill'],
                       background=colors['bar_background'])
    else:
        return widget.TextBox(fmt='', font='Symbols Nerd Font',
                       fontsize=40,
                       foreground=colors['bar_background_fill'],
                       background=colors['bar_background'])

def get_bars():
    if theme_name == "night":
        from night import get_bars
        return get_bars()

    elif theme_name == "day":
        from day import get_bars
        return get_bars()

    elif theme_name == "shabbat":
        from shabbat import get_bars
        return get_bars()
    else:
        return []
