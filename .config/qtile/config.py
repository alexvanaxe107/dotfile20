from libqtile.log_utils import logger

import hooks
from layouts import layouts, floating_layout
from workspaces import workspaces
from key import mod, keys, groups
from screens import screens


auto_fullscreen = False
cursor_warp = False  # could be nice. Testing out...
