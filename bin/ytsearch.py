#! /home/alexvanaxe/.pyenv/versions/wm/bin/python

from youtubesearchpython import VideosSearch, ChannelsSearch, CustomSearch, VideoSortOrder

import json

def _parse_arguments():
    import argparse

    parser = argparse.ArgumentParser(description='Search a youtube video')
    parser.add_argument('-s', '--search', type=str, help='The video seach query')
    parser.add_argument('-q', '--quantity',
                        type=int, default= 1,
                        help='The quantity of urls returned')
    parser.add_argument('-o', '--order', action='store_true',
                        help='Use the ratio based on the dimensions provided')
    parser.add_argument('-t', '--title', action='store_true',
                        help='Put the title in the output')


    options = parser.parse_args()
    return options

def _main():
    options = _parse_arguments()
    search = options.search
    time = options.order
    title = options.title
    quantity = options.quantity

    if time:
        allSearch = CustomSearch(search, VideoSortOrder.uploadDate)
    else:
        allSearch = VideosSearch(search)


    result = allSearch.result()
    result_json = json.loads(result)
    
    loop = range(0, quantity)
    for i in loop:
        if title: 
            print("%s;%s" % (result_json['result'][i]['link'], 
                                     result_json['result'][i]['title']))
        else:
            print(result_json['result'][i]['link'])


if __name__ == '__main__':
    _main()
