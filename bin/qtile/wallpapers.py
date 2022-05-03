import sys
from libqtile.config import Screen
from libqtile.command.client import InteractiveCommandClient as Client
from libqtile import bar, layout, widget
from libqtile.lazy import lazy

wallpaper = sys.argv[1]
index = sys.argv[2]

c = Client()
c.screen[int(index)].set_wallpaper(wallpaper, 'fill')


