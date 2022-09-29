import requests
import os
import re
import pathlib
import random
import math
import json
from datetime import datetime
from google_images_search import GoogleImagesSearch

from Xlib import display
from Xlib.ext import randr

user = os.environ['HOME']

CONFIG_PATH = "%s/%s" % (user, ".config/wallfinder")

class Config(object):
    def __init__(self, ratio=False) -> None:
        self.ratio = ratio



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

    resolution = monitor_plugged['resolution']

    return resolution


def _get_monitor_info(monitor):
    monitors = get_display_info()

    if monitor:
        monitor_plugged = monitors[monitor]
    else:
        if len(monitors) == 1:
            monitor_plugged = list(monitors.values())[0]
        else:
            raise BaseException("Multiple monitors connected. Please inform\
                                monitor with -m")

    return monitor_plugged


def get_display_info():
    d = display.Display(':0')
    result = {}
    screen = 0
    info = d.screen(screen)
    window = info.root

    res = randr.get_screen_resources(window)
    for output in res.outputs:
        orientation = "landscape"
        params = d.xrandr_get_output_info(output, res.config_timestamp)
        if not params.crtc:
            continue
        crtc = d.xrandr_get_crtc_info(params.crtc, res.config_timestamp)

        kind = ""
        ratio_w = ""
        ratio_h = ""
        if crtc.width >= 2560:
            kind = "ultra"
        else:
            kind = "normal"

        if kind == "normal":
            ratio_w = "16"
            ratio_h = "9"
        else:
            ratio_w = "21"
            ratio_h = "9"

        if crtc.width < crtc.height:
            orientation = "portrait"
        elif crtc.width == crtc.height:
            orientation = "squarish"

        result[params.name] = {
            'name': params.name,
            'kind': kind,
            'resolution': "{}x{}".format(crtc.width, crtc.height),
            'width': crtc.width,
            'height': crtc.height,
            'ratio_w': ratio_w,
            'ratio_h': ratio_h,
            'orientation' : orientation
        }

    return result


class Bing():
    BING_URL = "https://bing.biturl.top/"

    def get_wallpaper(self, monitor, scene, config):
        url = self.retrieve_url()

        return self.download(url)
        
    def download(self, url):
        file_to_save = self.file_name(url)
        r = requests.get(url, allow_redirects=True)
        open(file_to_save, 'wb').write(r.content)

        return file_to_save

    def retrieve_url(self):
        json_resp = requests.get(self.BING_URL)
        if json_resp.status_code == 200:
            return json_resp.json()['url']

    def file_name(self, url):
        path = "bing"
        suffix = pathlib.PurePath(url).suffix
        today = datetime.today().strftime('%Y%m%d')

        filename = "{}{}".format(today, suffix)
        filepath = "{}/{}".format(CONFIG_PATH, path)
        pathlib.Path(filepath).mkdir(parents=True, exist_ok=True)

        path = "{}/{}".format(filepath, filename)

        return path


class Chromecast():
    """ Get a wallpaper from the chromecast, unfurtunelly cant use monitor and
    scene since it is totally random. """
    CHROME_URL = "https://raw.githubusercontent.com/dconnolly/chromecast-backgrounds/master/README.md"

    def get_wallpaper(self, monitor, scene, config):
        wallpapers = requests.get(self.CHROME_URL)
        imagens = wallpapers.text.splitlines()

        image_index = random.randint(1, len(imagens))
        url = re.search('\((.*)\)', imagens[image_index]).group(1)

        return self.download(url)

    def download(self, url):
        file_to_save = self.get_file_name(url)
        r = requests.get(url, allow_redirects=True)
        open(file_to_save, 'wb').write(r.content)

        return file_to_save

    def get_file_name(self, url):
        path = "googlechrome"
        filename = pathlib.PurePath(url)
        savename = "{}/{}/{}".format(CONFIG_PATH, path, filename.name)
        file_path = "{}/{}".format(CONFIG_PATH, path)
        pathlib.Path(file_path).mkdir(parents=True, exist_ok=True)
        return savename


class Alpha():
    ALPHA_URL = "https://wall.alphacoders.com/api2.0/get.php"
    ALPHA_KEY = "e33fa5bbf58d48763cee4c57258e0749"

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
        url = "{}?auth={}".format(
            self.ALPHA_URL,
            self.ALPHA_KEY)

        if monitor_info:
            url = url + "&width={}&height={}".format(
                monitor_info['width'],
                monitor_info['height'])

        if scene:
            url = url + "&term={}&method={}".format(
                scene, "search")
        else:
            url = url + "&method={}".format("random")

        url = url + "&info_level=1"

        wallpapers = requests.get(url)
        json = wallpapers.json()

        indexes = self.get_random_from_return(json)
        if not indexes:
            return ""

        url = url + "&page={}".format(
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
        savename = "{}/{}/{}".format(CONFIG_PATH, dirname, filename)
        pathlib.Path("{}/{}".format(CONFIG_PATH, dirname)).\
            mkdir(parents=True, exist_ok=True)
        open(savename, 'wb').write(r.content)
        return savename

    def getFileName(self, url):
        filename = pathlib.PurePath(url)
        return filename.name


class GImages():
    def get_wallpaper(self, monitor, scene, config):
        """ Basic interface implementation"""
        resolution = {}
        if monitor:
            monitor_info = _get_monitor_info(monitor)
            resolution = monitor_info

        return self.retrieve_url_wallapaper(resolution, scene)

    def retrieve_url_wallapaper(self, resolution, scene):
        gis = GoogleImagesSearch('AIzaSyDkO6Yitk9x_22eNmyB5MTcEYA7PQBPMaM',
                                 '46a14224dfb4f74bd')

        theme_name = os.environ['theme_name']

        img_size = 20

        color = ""
        if theme_name == "night":
            color = random.choice(['black', 'purple'])

        _search_params = {
            'q': scene,
            'num': img_size,
            # 'safe': 'high|medium|off',
            # 'fileType': 'jpg|gif|png',
            # 'imgType': 'clipart|face|lineart|news|photo',
            # 'imgSize': 'huge|icon|large|medium|small|xlarge|xxlarge',
            'imgSize': 'XLARGE',
            # 'imgDominantColor': 'black|blue|brown|gray|green|orange|pink|purple|red|teal|white|yellow',
            'imgDominantColor': color,
            # 'imgColorType': 'color|gray|mono|trans',
            # 'rights': 'cc_publicdomain|cc_attribute|cc_sharealike|cc_noncommercial|cc_nonderived'
        }

        path_to_save = self.get_path("gimages")

        if resolution:
            gis.search(search_params=_search_params, path_to_dir=path_to_save,
                       width=resolution['width'], height=resolution['height'])

        image_index = random.randint(1, img_size)

        if gis.results():
            return gis.results()[image_index].path
        else:
            return ""

    def get_path(self, dirname):
        savename = "{}/{}/{}/".format(CONFIG_PATH, "gimages", dirname)
        pathlib.Path(savename).mkdir(parents=True, exist_ok=True)
        return savename


class WallHaven():
    WALLHAVEN_URL = "https://wallhaven.cc/api/v1/search"

    def get_wallpaper(self, monitor, scene, config):
        resolution = None
        self.config = config
        if monitor:
            monitor_info = _get_monitor_info(monitor)

            if config.ratio:
                resolution = "{}x{}".format(monitor_info['ratio_w'],
                                            monitor_info['ratio_h'])
            else:
                resolution = "{}x{}".format(monitor_info['width'],
                                            monitor_info['height'])

        url = self.retrieve_url_wallapaper(resolution, scene)
        filename = self.getFileName(url)

        path = ""
        first = True

        if resolution:
            path += ("{}" if first else "{}").format(resolution)
            first = False

        if (url):
            downloaded = self.download(url, path, filename)
        else:
            downloaded = ""

        return downloaded

    def retrieve_url_wallapaper(self, resolution, search):
        query = "?sorting=random&categories=100"
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
            query = "?"
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
        savename = "{}/{}/{}/{}".format(CONFIG_PATH,
                                        "haven",
                                        dirname,
                                        filename)
        pathlib.Path("{}/{}/{}".format(CONFIG_PATH,
                                       "haven",
                                       dirname)).mkdir(parents=True,
                                                       exist_ok=True)
        open(savename, 'wb').write(r.content)
        return savename

    def getFileName(self, url):
        filename = pathlib.PurePath(url)
        return filename.name

class Unsplash():
    SERVICE_URL = 'https://api.unsplash.com/'
    CLIENT_ID = '_xacj1gjFWlFq7fBuGVwQ5DyFLkZQXOwo5n4oGg7toc'
    ACCESS_KEY = 'N13vTby_fBE3bLrvzmTqT6cmkBhmX6ehODyFh4tuUCs'

    def get_wallpaper(self, monitor, scene, config):
        monitor_info = _get_monitor_info(monitor)
        request = self.mount_request(monitor_info, scene)
        response = self.get_json(request)

        url = self.get_url(response)
        file_name = self.get_file_name(response)

        wallpaper = self.download(url, monitor_info['orientation'], file_name)

        return wallpaper

    def mount_request(self, monitor_info, scene):
        request = self.SERVICE_URL
        # Request base
        request += ("{}").format("photos/random?")

        # set the query parametter
        request += ("orientation={}").format(monitor_info['orientation'])
        if scene:
            request += ("&query={}").format(scene)

        return request

    def get_json(self, request):
        response = requests.get(request, headers={'Authorization': 'Client-ID ' + self.ACCESS_KEY})

        return response.json()

    def get_url(self, response):
        url = response['urls']['raw']
        return url

    def get_file_name(self, response):
        file_name = "{}{}".format(response["id"], ".jpg")
        return file_name

    def download(self, url, dirname, filename):
        url_int = url
        r = requests.get(url_int, allow_redirects=True)
        savename = "{}/{}/{}/{}".format(CONFIG_PATH,
                                        "usplash",
                                        dirname,
                                        filename)
        pathlib.Path("{}/{}/{}".format(CONFIG_PATH,
                                       "usplash",
                                       dirname)).mkdir(parents=True,
                                                       exist_ok=True)
        open(savename, 'wb').write(r.content)
        return savename

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
                        help='Use a for alpha, h for haven, c for\
                        chromecast\
                        , b for Bing and i for Google Images.\
                        Skipping will search between alpha\
                        and\
                        haven')

    options = parser.parse_args()
    return options


def get_engine(engine):
    if engine:
        if engine == "a":
            return Alpha()
        if engine == "h":
            return WallHaven()
        if engine == "i":
            return GImages()
        if engine == "c":
            return Chromecast()
        if engine == "b":
            return Bing()
        if engine == "u":
            return Unsplash()

    choice = random.choice(['haven'])

    if choice == 'haven':
        return WallHaven()

    if choice == 'alpha':
        return Alpha()

    return WallHaven()


def _main():
    options = _parse_arguments()
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

    if not downloaded and not engine:
        wallservice = get_engine('h')
        downloaded = wallservice.get_wallpaper(monitor, scene, config)

    print(downloaded)


if __name__ == '__main__':
    _main()
