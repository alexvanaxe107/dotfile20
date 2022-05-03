from theme import theme_name
from libqtile.config import Screen

screens = []

if theme_name == "day":
    from bar import myBar, myOtherBar
    screens.append(Screen(top=myBar))
    screens.append(Screen(top=myOtherBar))
elif theme_name == "light":
    screens.append(Screen())
    screens.append(Screen())
else:
    from bar import myBar, myOtherBar
    screens.append(Screen(bottom=myBar))
    screens.append(Screen(bottom=myOtherBar))

