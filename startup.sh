#!/bin/sh
setxkbmap -option ctrl:nocaps

echo "remap" >> /tmp/remap
date >> /tmp/remap
xmodmap -e "keycode 133 = Pointer_Button1"
xmodmap -e "keycode 108 = Pointer_Button1"
xmodmap -e "keycode 135 = Pointer_Button3"
xkbset m
