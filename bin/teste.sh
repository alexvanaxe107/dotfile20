#!/bin/bash
# A basic summary of my sales report


MONITOR=$(xrandr --query | grep "*" | nl | awk '{print $1}')

echo -e ${MONITOR}
