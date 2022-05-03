import sys
from libqtile.config import Screen
from libqtile.command.client import InteractiveCommandClient as Client
from libqtile import bar, layout, widget
from libqtile.lazy import lazy

c = Client()
print(c.screen[0])


