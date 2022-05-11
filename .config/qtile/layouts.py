from libqtile import layout
from libqtile.config import Match

from theme import *

# DEFAULT THEME SETTINGS FOR LAYOUTS #
layout_theme = {"border_width": 3,
                "border_focus": colors['active_border'],
                "border_normal": colors['border_normal'],
                }

use_slice = layout.Max(**layout_theme, margin=values['gap_size'])

layouts = [
    layout.MonadTall(**layout_theme, margin=values['gap_size'], single_border_width=0, ratio=0.6),
    # layout.MonadTall(**layout_theme, single_border_width=0, ratio=0.6),
    # layout.Stack(num_stacks=2, **layout_theme, margin=values['gap_size']),
    # layout.Max(**layout_theme, margin=values['gap_size']),
    # layout.MonadThreeCol(**layout_theme, margin=values['gap_size'], single_border_width=0, ratio=0.6, new_client_position='bottom'),
    # Try more layouts by unleashing below layouts.
    # layout.Bsp(**layout_theme),
    # layout.Columns(**layout_theme),
    # layout.Floating(float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        # *layout.Floating.default_float_rules,
        # Match(title='Quit and close tabs?'),
        # Match(wm_type='utility'),
        # Match(wm_type='notification'),
        # Match(wm_type='toolbar'),
        # Match(wm_type='splash'),
        # Match(wm_type='dialog'),
        # Match(wm_class='gimp-2.99'),
        # Match(wm_class='Firefox'),
        # Match(wm_class='file_progress'),
        # Match(wm_class='confirm'),
        # Match(wm_class='dialog'),
        # Match(wm_class='download'),
        # Match(wm_class='error'),
        # Match(wm_class='notification'),
        # Match(wm_class='splash'),
        # Match(wm_class='toolbar'),
        # Match(title='About LibreOffice'),
        # Match(wm_class='confirmreset'),  # gitk
        # Match(wm_class='makebranch'),  # gitk
        # Match(wm_class='maketag'),  # gitk
        # Match(wm_class='ssh-askpass'),  # ssh-askpass
        # Match(title='branchdialog'),  # gitk
        # Match(title='pinentry'),  # GPG key password entry
    # ], **layout_theme),
   # layout.Matrix(**layout_theme, columns=3, margin=values['gap_size']),
    layout.VerticalTile(**layout_theme, margin=values['gap_size']),
    layout.MonadWide(**layout_theme, margin=values['gap_size'], ratio=0.6),
    # layout.RatioTile(),
    layout.Zoomy(**layout_theme, margin=values['gap_size']),
    layout.Slice(**layout_theme, margin=values['gap_size'], side="right",
                 fallback=use_slice, width=756),
    #layout.Tile(),
    # layout.TreeTab(),
]

floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    # *layout.Floating.default_float_rules,
    Match(title='Quit and close tabs?'),
    Match(wm_type='utility'),
    Match(wm_type='notification'),
    Match(wm_type='toolbar'),
    Match(wm_type='splash'),
    Match(wm_type='dialog'),
    Match(wm_class='file_progress'),
    Match(wm_class='confirm'),
    Match(wm_class='dialog'),
    Match(wm_class='download'),
    Match(wm_class='error'),
    Match(wm_class='conky'),
    Match(wm_class='notification'),
    Match(wm_class='splash'),
    Match(wm_class='toolbar'),
    Match(title='About LibreOffice'),
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
], **layout_theme)
