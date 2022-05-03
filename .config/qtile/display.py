from Xlib import display

def get_display_count():
    display_info = display.Display(':0')
    return display_info.screen_count()
