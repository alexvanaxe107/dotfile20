import os
from libqtile.config import Key, Group, KeyChord
from libqtile.config import Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile import hook
from libqtile import extension
from libqtile.log_utils import logger

from theme import theme_name, bar_configs
from layouts import layouts, floating_layout
from workspaces import workspaces
from bar import myBar
from display import get_display_count

mod = "mod4"
terminal = guess_terminal()

auto_fullscreen = False
cursor_warp = False  # could be nice. Testing out...

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),

    Key([mod, "control"], "Right", lazy.layout.grow_main(), desc="Grow window down"),
    Key([mod, "control"], "Left", lazy.layout.shrink_main(), desc="Grow window down"),
    Key([mod], "o", lazy.layout.maximize()),
    Key([mod, "control"], "f", lazy.layout.flip()),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key([mod], "u", lazy.window.toggle_floating(), desc="Toggle floating"),
    Key([mod], "p", lazy.run_extension(extension.WindowList(font=bar_configs['font'], item_format='{group}: {window}')), desc="Show the wl?"),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod, "shift"], "Tab", lazy.prev_layout(), desc="Go to previous layout"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),

    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),

    Key([mod], 'period', lazy.next_screen(), desc='Next monitor'),
    Key([mod], 'comma', lazy.prev_screen(), desc='Prev monitor'),

    # My personal mappings #
    Key([mod, "shift"], "r", lazy.spawn("play_radio.sh"), desc="Play some music"),
    Key([mod, "shift"], "s", lazy.spawn("player_ctl.sh"), desc="Control the player"),
    Key([mod, "shift"], "p", lazy.spawn("pomodoro-client.sh"), desc="Start a pomodoro"),
    Key([mod, "shift"], "y", lazy.spawn("theme_select.sh"), desc="Yay! Change the theme"),
    Key([mod, "shift"], "f", lazy.spawn("font_select.sh"), desc="Change the font"),
    Key([mod, "shift"], "w", lazy.spawn("wallpaper_changer.sh"), desc="Change the font"),
    Key([mod, "shift"], "u", lazy.spawn("configshortcut.sh"), desc="Change some configs"),
    Key([mod, "shift"], "d", lazy.spawn("configdisplay.sh"), desc="Config the display"),
    Key([mod, "shift"], "o", lazy.spawn("alacritty_theme.sh"), desc="Change the alacritty theme"),
    Key([mod, "shift"], "e", lazy.spawn("powercontrol.sh"), desc="Turn off, hibernate... etc"),
    Key([mod, "shift"], "b", lazy.hide_show_bar(), desc="Turn off/on polybars"),
    Key([mod, "shift"], "c", lazy.spawn(os.path.expanduser("~/.config/conky/conky.sh")), desc="Toggle conky"),
    Key([mod, "shift"], "i", lazy.spawn("avalight"), desc="Change the light"),
    Key([mod], "a", lazy.spawn("dmenulexia.sh"), desc="Change the alacritty theme"),
    Key([mod], "d", lazy.spawn("dmenu_run"), desc="Run the programs"),

        # Volume
    Key([], "XF86AudioMute",
        lazy.spawn("pulseaudio-ctl mute"),
        desc='Mute audio'
        ),
    Key([], "XF86AudioLowerVolume",
        lazy.spawn("pulseaudio-ctl down 2"),
        desc='Volume down'
        ),
    Key([], "XF86AudioRaiseVolume",
        lazy.spawn("pulseaudio-ctl up 2"),
        desc='Volume up'
        ),

    # Chords to start some programs
    KeyChord([mod], "g", [
        Key([], "k", lazy.spawn("setkmap"))
    ])
]

groups = []

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


for workspace in workspaces:
    groups.append(Group(workspace["name"]))
    keys.append(Key([mod], workspace["key"], lazy.group[workspace["name"]].toscreen()))
    keys.append(Key([mod, "shift"], workspace["key"], lazy.window.togroup(workspace["name"])))

for i in range(2):
    keys.extend([Key([mod, "control"], str(i+1), lazy.window.toscreen(i))])

if theme_name == "day":
    screens = [Screen(top=myBar)]
    if get_display_count() > 1:
        screens.append(Screen(top=myOtherBar))
elif theme_name == "light":
    screens = [Screen()]
    if get_display_count() > 1:
        screens.append(Screen())
else:
    screens = [Screen(bottom=myBar)]
    if get_display_count() > 1:
        screens.append(Screen(bottom=myOtherBar))

