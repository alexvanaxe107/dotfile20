#!/usr/bin/env python3

import requests
import argparse
import re
import pathlib
from tabulate import tabulate

from Xlib import X, display
from Xlib.ext import randr

CONFIG_PATH="/home/alexvanaxe/.config/wallfinder"
WALLHAVEN_URL="https://wallhaven.cc/api/v1/search"

def get_wallpapers(search):
    wallpapers = requests.get(WALLHAVEN_URL+search)

    if wallpapers.status_code != 200:
        print("Error! Error!")

    return wallpapers.json()['data'][0]['path']

def download(url, dirname, filename):
    url_int = url
    r = requests.get(url_int, allow_redirects=True)
    savename="{}/{}/{}".format(CONFIG_PATH, dirname, filename)
    pathlib.Path("{}/{}".format(CONFIG_PATH, dirname)).mkdir(parents=True, exist_ok=True)
    open(savename, 'wb').write(r.content)
    return savename

def find_mode(id, modes):
   for mode in modes:
       if id == mode.id:
           return "{}x{}".format(mode.width, mode.height)

def get_display_info():
    d = display.Display(':0')
    screen_count = d.screen_count()
    default_screen = d.get_default_screen()
    result = {}
    screen = 0
    info = d.screen(screen)
    window = info.root

    res = randr.get_screen_resources(window)
    for output in res.outputs:
        params = d.xrandr_get_output_info(output, res.config_timestamp)
        if not params.crtc:
           continue
        crtc = d.xrandr_get_crtc_info(params.crtc, res.config_timestamp)
        modes = set()

        kind=""
        if crtc.width >= 2560:
            kind="ultra"
        else:
            kind="normal"

        result[params.name] = {
            'name': params.name,
            'kind': kind,
            'resolution': "{}x{}".format(crtc.width, crtc.height),
        }

    return result

def _parse_arguments():
    import argparse

    parser = argparse.ArgumentParser(description='Get desktop file address.')
    parser.add_argument('-d', '--dimension', type=str,
                        help='The dimension of the screen')
    parser.add_argument('-t', '--theme', type=str,
                        help='The theme name')
    parser.add_argument('-m', '--monitor', type=str,
                        help='What monitor to download')
    parser.add_argument('-s', '--scene', type=str,
                        help='What is the scene')

    options = parser.parse_args()
    return options

def _get_monitor_res(monitor):
    monitors = get_display_info()

    monitor = monitors[monitor]

    resolution=monitor['resolution']

    return resolution

def _main():
    options = _parse_arguments()
    resolution = options.dimension
    theme = options.theme
    monitor = options.monitor
    scene = options.scene

    search = "?"
    if monitor:
        resolution = _get_monitor_res(monitor)
        search += "sorting=random&resolutions={}".format(resolution) 

    if scene:
        search += "&q={}".format(scene)

    url = get_wallpapers(search)
    filename = re.findall("/(wall.*)", url)
    path = ""
    if theme:
        path = "{}/{}".format(theme, resolution)
    else:
        path = "{}".format(resolution)

    downloaded = download(url, path, filename[0])

    print(downloaded)
        
if __name__ == '__main__':
    _main()
