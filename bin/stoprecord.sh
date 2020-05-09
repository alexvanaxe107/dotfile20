#!/bin/sh

pid=$(pidof ffmpeg)
kill -9 $pid
