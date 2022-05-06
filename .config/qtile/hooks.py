import os
import subprocess
from libqtile import hook

from theme import theme_name
from bar import get_bars


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~')
    subprocess.Popen([home + '/.config/qtile/autostart.sh'])

@hook.subscribe.startup
def setBarProperty():
    if theme_name == "night":
        bars = get_bars()
        for bar in bars:
            bar.window.window.set_property("_QTILEBAR", 1, "CARDINAL", 32)
            bar.window.window.set_property("_QTILEBAR_BLUR", 1, "CARDINAL", 32)
    if theme_name == "shabbat":
        bars = get_bars()
        for bar in bars:
            bar.window.window.set_property("_QTILEBAR_BLUR", 1, "CARDINAL", 32)
