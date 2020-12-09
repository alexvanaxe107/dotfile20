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

class Config(object):
    pass


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

    def get_wallpaper(self, monitor, scene, config):
        downloaded = ""
        path = "alpha"

        monitor_info = None
        if monitor:
            monitor_info = _get_monitor_info(monitor)

        url = self.get_wallpapers_alpha_search(monitor_info, scene)

        if monitor_info:
            path += "/{}".format("{}x{}".format(monitor_info['width'],
                                             monitor_info['height']))

        filename = self.getFileName(url)
        downloaded = self.download(url, path, filename)
        return downloaded


    def get_wallpapers_alpha_search(self, monitor_info, scene):
        search="search"
         
        url="{}?auth={}".format(
            self.ALPHA_URL,
            self.ALPHA_KEY)

        if monitor_info:
            url+="&width={}&height={}".format(
            monitor_info['width'],
            monitor_info['height'])

        if scene:
            url+="&term={}&method={}".format(
                scene, "search")
        else:
            url+="&method={}".format(
                scene, "random")


        url+="&info_level=1"

        wallpapers = requests.get(url)
        json = wallpapers.json()

        indexes = self.get_random_from_return(json)
        if not indexes:
            return ""

        url+="&page={}".format(
            indexes['page'])

        wallpapers = requests.get(url)
        json = wallpapers.json()

        return json['wallpapers'][indexes['index_in_page']]['url_image']


    def get_random_from_return(self, json):
        total_match = 0
        try:
            total_match = json['total_match']
        except KeyError:
            result = {}
            result['index'] = 0
            result['index_in_page'] = 0
            result['page'] = 0
            return result


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
    def get_wallpaper(self, monitor, scene, config):
        resolution = None
        self.config = config
        if monitor:
            monitor_info = _get_monitor_info(monitor)

            if config.ratio:
                resolution="{}x{}".format(monitor_info['ratio_w'],
                                          monitor_info['ratio_h'])
            else:
                resolution="{}x{}".format(monitor_info['width'],
                                          monitor_info['height'])

        url = self.retrieve_url_wallapaper(resolution, scene)
        filename = self.getFileName(url)

        path = ""
        first = True

        if resolution:
            path += ("{}" if first else "\{}").format(resolution)
            first = False

        if (url):
            downloaded = self.download(url, path, filename)
        else:
            downloaded = ""

        return downloaded


    def retrieve_url_wallapaper(self, resolution, search):
        query="?sorting=random"
        if resolution:
            if self.config.ratio:
                query += "&ratio={}".format(resolution)
            else:
                query += "&resolutions={}".format(resolution)

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
    parser.add_argument('-r', '--ratio', action='store_true',
                        help='Use the ratio based on the dimensions provided')
    parser.add_argument('-m', '--monitor', type=str,
                        help='What monitor to download')
    parser.add_argument('-s', '--scene', type=str,
                        help='What is the scene')
    parser.add_argument('-e', '--engine', type=str,
                        help='Use a for alpha, h for haven')

    options = parser.parse_args()
    return options

def get_engine(engine):
    if engine:
        if engine == "a":
            return Alpha()
        if engine == "h":
            return WallHaven()

    return WallHaven()


def _main():
    options = _parse_arguments()
    resolution = options.dimension
    monitor = options.monitor
    scene = options.scene
    engine = options.engine
    ratio = options.ratio

    config = Config()
    config.ratio = False
    if ratio:
        config.ratio = True


    # wallservice = WallHaven()
    wallservice = get_engine(engine)
    downloaded = wallservice.get_wallpaper(monitor, scene, config)

    if  not downloaded and not engine:
        wallservice = get_engine('h')
        downloaded = wallservice.get_wallpaper(monitor, scene, config)

    print(downloaded)

if __name__ == '__main__':
    _main()
