import os
import subprocess
from libqtile import hook

from theme import theme_name


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~')
    subprocess.Popen([home + '/.config/qtile/autostart.sh'])


@hook.subscribe.startup
def setBarProperty():
    if theme_name == "night":
        from bar import myBar, myOtherBar
        myBar.window.window.set_property("_QTILEBAR", 1, "CARDINAL", 32)
        myOtherBar.window.window.set_property("_QTILEBAR", 1, "CARDINAL", 32)
        return

    if theme_name == "day":
        from bar import myBar, myOtherBar
        myBar.window.window.set_property("_QTILEBAR_DAY", 1, "CARDINAL", 32)
        myOtherBar.window.window.set_property("_QTILEBAR_DAY", 1, "CARDINAL", 32)
        return
