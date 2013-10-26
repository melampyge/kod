#!/bin/sh
# remaps windows key to left click, Alt Gr again to left click
# some key that was already right mouse click again to right mouse click
# the keycodes can be different on each computer, find out with xev.
xmodmap -e "keycode 133 = Pointer_Button1"
xmodmap -e "keycode 108 = Pointer_Button1"
xmodmap -e "keycode 135 = Pointer_Button3"
xkbset m
