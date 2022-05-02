import sys
from libqtile.config import Screen
from libqtile.command.client import InteractiveCommandClient as Client
from libqtile import bar, layout, widget
from libqtile.lazy import lazy

c = Client()
print(c.layout[0].info())
c.layout[0].border_focus = "#ffffff"


