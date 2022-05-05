from theme import theme_name
from libqtile.config import Screen
from bar import get_bars

from libqtile.log_utils import logger

screens = []

if theme_name == "day":
    bars = get_bars()
    for bar in get_bars():
        screens.append(Screen(top=bar))
elif theme_name == "light":
    screens.append(Screen())
    screens.append(Screen())
elif theme_name == "night":
    bars = get_bars()
    for bar in get_bars():
        screens.append(Screen(bottom=bar))
elif theme_name == "shabbat":
    for bar in get_bars():
        screens.append(Screen(top=bar))


else:
    screens.append(Screen())
