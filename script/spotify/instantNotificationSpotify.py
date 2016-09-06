#!/usr/bin/python

import dbus
from gi.repository import Playerctl, GLib

item              = "org.freedesktop.Notifications"
path              = "/org/freedesktop/Notifications"
interface         = "org.freedesktop.Notifications"
app_name          = "notifySpotify"
id_num_to_replace = 0
icon              = ""
actions_list      = ''
hint              = ''
time              = 10000   # Use seconds x 1000

player            = Playerctl.Player()

text              = '{artist} - {album}'.format(artist=player.get_artist(), album=player.get_album())
title             = player.get_title()
bus = dbus.SessionBus()
notif = bus.get_object(item, path)
notify = dbus.Interface(notif, interface)
notify.Notify(app_name, id_num_to_replace, icon, title, text, actions_list, hint, time)

