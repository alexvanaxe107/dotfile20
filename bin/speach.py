#! /home/alexvanaxe/.pyenv/versions/wm/bin/python

import pyttsx3
import configparser

CONFIG_FILE='/home/alexvanaxe/.config/wm/speach.conf'
config = configparser.RawConfigParser()
config.read(CONFIG_FILE)

def _parse_arguments():
    import argparse

    parser = argparse.ArgumentParser(description='Speach a text')
    parser.add_argument('-t', '--text', type=str,
                        help='The the to speach')

    options = parser.parse_args()
    return options

def _speach_text_(text):
    engine = pyttsx3.init()
    engine.setProperty('rate', int(_get_rate()))

    engine.setProperty('voice', _get_voice())
    engine.say(text)
    engine.runAndWait()

def _is_enabled_():
    return config.get('General', 'enabled')

def _get_voice():
    return config.get('General', 'voice')

def _get_rate():
    return config.get('General', 'rate')

def __main__():
    options = _parse_arguments()
    text = options.text

    if _is_enabled_() == "true":
        _speach_text_(text)

if __name__ == '__main__':
    __main__()
