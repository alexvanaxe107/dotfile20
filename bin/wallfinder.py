#!/usr/bin/env python3

import requests
import argparse
import re
import pathlib
import random
import math
from tabulate import tabulate

from Xlib import X, display
from Xlib.ext import randr

CONFIG_PATH="/home/alexvanaxe/.config/wallfinder"

""" Helo this is a coment """
def find_mode(id, modes):
   for mode in modes:
       if id == mode.id:
           return "{}x{}".format(mode.width, mode.height)

def _get_monitor_res(monitor):
    monitors = get_display_info()
    if monitor:
        monitor_plugged = monitors[monitor]
    else:
        if len(monitors) == 1:
            monitor_plugged = list(monitors.values())[0]
        else:
            return ""

    resolution=monitor_plugged['resolution']

    return resolution

def _get_monitor_info(monitor):
    monitors = get_display_info()
    if monitor:
        monitor_plugged = monitors[monitor]
    else:
        if len(monitors) == 1:
            monitor_plugged = list(monitors.values())[0]
        else:
            raise BaseException("Multiple monitors connected. Please inform monitor with -m")

    return monitor_plugged

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
        ratio_w=""
        ratio_h=""
        if crtc.width >= 2560:
            kind="ultra"
        else:
            kind="normal"

        if kind == "normal":
            ratio_w="16"
            ratio_h="9"
        else:
            ratio_w="21"
            ratio_h="9"

        result[params.name] = {
            'name': params.name,
            'kind': kind,
            'resolution': "{}x{}".format(crtc.width, crtc.height),
            'width': crtc.width,
            'height': crtc.height,
            'ratio_w': ratio_w,
            'ratio_h': ratio_h
        }

    return result

class Alpha():
    ALPHA_URL="https://wall.alphacoders.com/api2.0/get.php"
    ALPHA_KEY="e33fa5bbf58d48763cee4c57258e0749"

    def get_wallpaper(self, monitor, scene, theme):
        downloaded = ""

        if monitor and scene:
            monitor_info = _get_monitor_info(monitor)

            url = self.get_wallpapers_alpha_search(monitor_info, scene)

            path = ""
            if theme:
                path = "{}/{}/{}".format("alpha","{}x{}".format(monitor_info['width'],
                                                         monitor_info['height'],
                                                         theme))
            else:
                path = "{}/{}".format("alpha", "{}x{}".format(monitor_info['width'],
                                                         monitor_info['height']))

            filename = self.getFileName(url)
            downloaded = self.download(url, path, filename)
            return downloaded


        url = self.get_wallpapers_alpha_random()
        filename = self.getFileName(url)

        path = ""
        if theme:
            path = "{}/{}".format("alpha", theme)
        else:
            path = "{}".format("alpha")

        downloaded = self.download(url, path, filename)
        return downloaded

    def get_wallpapers_alpha_search(self, monitor_info, scene):
        search="search"
        url="{}?auth={}&method={}&term={}&width={}&height={}&info_level=1".format(
            self.ALPHA_URL,
            self.ALPHA_KEY,
            search,
            scene,
            monitor_info['width'],
            monitor_info['height'])

        wallpapers = requests.get(url)
        json = wallpapers.json()
        
        indexes = self.get_random_from_return(json)
        if not indexes:
            return ""

        url="{}?auth={}&method={}&term={}&width={}&height={}&page={}&info_level=1".format(
            self.ALPHA_URL,
            self.ALPHA_KEY,
            search,
            scene,
            monitor_info['width'],
            monitor_info['height'],
            indexes['page'])

        wallpapers = requests.get(url)
        json = wallpapers.json()

        return json['wallpapers'][indexes['index_in_page']]['url_image']


    def get_random_from_return(self, json):
        total_match = json['total_match']
        if int(total_match) == 0:
            return None

        index = random.randint(0, int(total_match) - 1)
        page = math.ceil(index/30)
        index_in_page = index % 30

        result = {}
        result['index'] = index
        result['index_in_page'] = index_in_page
        result['page'] = page

        return result


    def get_wallpapers_alpha_random(self):
        search="random"
        url="{}?auth={}&method={}&info_level=1".format(self.ALPHA_URL, self.ALPHA_KEY, search)
        wallpapers = requests.get(url)
        json = wallpapers.json()
        return json['wallpapers'][0]['url_image']

    def download(self, url, dirname, filename):
        url_int = url
        if not url:
            return ""
        r = requests.get(url_int, allow_redirects=True)
        savename="{}/{}/{}".format(CONFIG_PATH, dirname, filename)
        pathlib.Path("{}/{}".format(CONFIG_PATH, dirname)).mkdir(parents=True, exist_ok=True)
        open(savename, 'wb').write(r.content)
        return savename
    
    def getFileName(self, url):
        filename = pathlib.PurePath(url)
        return filename.name

class WallHaven():
    WALLHAVEN_URL="https://wallhaven.cc/api/v1/search"
    def get_wallpaper(self, monitor, scene, theme):
        monitor_info = _get_monitor_info(monitor)

        resolution="{}x{}".format(monitor_info['ratio_w'],
                                  monitor_info['ratio_h'])

        url = self.retrieve_url_wallapaper(resolution, scene)
        filename = self.getFileName(url)

        path = ""
        if theme:
            path = "{}/{}".format(theme, resolution)
        else:
            path = "{}".format(resolution)

        if (url):
            downloaded = self.download(url, path, filename)
        else:
            downloaded = ""
        
        return downloaded
        

    def retrieve_url_wallapaper(self, resolution, search):
        query="?"
        if resolution:
            query += "sorting=random&ratio={}".format(resolution)
        else:
            query += "sorting=random"

        if search:
            query += "&q={}".format(search)

        wallpapers = requests.get(self.WALLHAVEN_URL+query)

        if wallpapers.status_code != 200:
            print("Error! Error!")
        
        url = ''
        try:
            url = wallpapers.json()['data'][0]['path']
        except IndexError:
            query="?"
            query += "sorting=random"
            if search:
                query += "&q={}".format(search)
                wallpapers = requests.get(self.WALLHAVEN_URL+query)
                try:
                    url = wallpapers.json()['data'][0]['path']
                except(IndexError):
                    return ""

        return url

    def download(self, url, dirname, filename):
        url_int = url
        r = requests.get(url_int, allow_redirects=True)
        savename="{}/{}/{}/{}".format(CONFIG_PATH, "haven", dirname, filename)
        pathlib.Path("{}/{}/{}".format(CONFIG_PATH, "haven", dirname)).mkdir(parents=True, exist_ok=True)
        open(savename, 'wb').write(r.content)
        return savename

    def getFileName(self, url):
        filename = pathlib.PurePath(url)
        return filename.name

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
    parser.add_argument('-e', '--engine', type=str,
                        help='Use a for alpha, h for haven')

    options = parser.parse_args()
    return options

def get_engine(monitor, scene, engine):
    if engine:
        if engine == "a":
            return Alpha()
        if engine == "h":
            return WallHaven()

    return WallHaven()

    

def _main():
    options = _parse_arguments()
    resolution = options.dimension
    theme = options.theme
    monitor = options.monitor
    scene = options.scene
    engine = options.engine

    # wallservice = WallHaven()
    wallservice = get_engine(monitor, scene, engine)
    downloaded = wallservice.get_wallpaper(monitor, scene, theme)

    if  not downloaded and not engine:
        wallservice = get_engine(monitor, scene, 'h')
        downloaded = wallservice.get_wallpaper(monitor, scene, theme)

    print(downloaded)
        
if __name__ == '__main__':
    _main()
