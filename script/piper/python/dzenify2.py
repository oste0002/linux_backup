#!/usr/bin/env python3
import dbus
import dbus.service
from dbus.mainloop.glib import DBusGMainLoop
import glib
import os
import sys
import subprocess
 
DZEN_ARGS = [
    "dzen2",
    "-p", "6",
    "-x", "735",
    "-y", "0",
    "-w", "390",
    "-h", "16",
    "-l", "1",
    "-sa", "c",
    "-ta", "c",
    "-bg", "#222222",
    "-fg", "#EEEEEE",
    "-fn", "terminus",
]
 
BG_URGENT = "#6e2222"
 
NF_SERVICE = "org.freedesktop.Notifications"
NF_OBJECT = "/org/freedesktop/Notifications"
NF_INTERFACE = "org.freedesktop.Notifications"
 
def trace(*args):
    if os.environ.get("DEBUG"):
        print("dzenify:", *args, file=sys.stderr)
 
class DzenifyService(dbus.service.Object):
    def __init__(self):
        self._bus = dbus.SessionBus()
        self._bus_name = None
        self._timer = None
        self._proc = None
 
        super().__init__(self._bus, NF_OBJECT)
 
        self.acquire_name()
 
    def acquire_name(self):
        self._bus_name = dbus.service.BusName(NF_SERVICE,
                                              bus=self._bus,
                                              allow_replacement=True,
                                              replace_existing=True)
 
    def dzen_feed(self, line, retry=True):
        trace("dzen_feed(%r)" % line)
        if not self._proc:
            self._proc = subprocess.Popen(DZEN_ARGS, stdin=subprocess.PIPE)
 
        try:
            self._proc.stdin.write(line.encode("utf-8"))
            self._proc.stdin.flush()
            return self._proc.pid
        except ValueError:
            # e.g. write to closed pipe
            if retry:
                self.dzen_kill()
                return self.dzen_feed(line, retry=False)
            else:
                raise
 
    def dzen_kill(self, id=0):
        if self._proc and (id == 0 or id == self._proc.pid):
            self._proc.stdin.close()
            self._proc.terminate()
            self._proc = None
 
    def set_timer(self, timeout):
        if self._timer:
            glib.source_remove(self._timer)
        trace("set_timer(%d)" % timeout)
        self._timer = glib.timeout_add(timeout, self.timer_callback)
 
    def timer_callback(self):
        trace("timer_callback()")
        self.dzen_kill()
        self._timer = None
        return False
 
    @dbus.service.method(NF_INTERFACE, out_signature="ssss")
    def GetServerInformation(self):
        return ("dzenify", "dzenify", "1.0", "1.2")
 
    @dbus.service.method(NF_INTERFACE, out_signature="as")
    def GetCapabilities(self):
        return ["body", "dzen-markup"]
 
    @dbus.service.method(NF_INTERFACE, in_signature="susssasa{sv}i", out_signature="u")
    def Notify(self, app_name, id, icon, title, body, actions, hints, timeout):
        trace(hints)
 
        # process hints
 
        urgency = int(hints.get("urgency", 1))
        raw_body = bool(hints.get("dzen-body", False))
        raw_title = bool(hints.get("dzen-title", False))
 
        title_bg = BG_URGENT if urgency >= 2 else ""
 
        if not raw_title:
            title = title.replace("^", "^^")
        if not raw_body:
            body = body.replace("^", "^^")
 
        # generate dzen input
 
        text = ""
        text += "^tw()^bg(%s)%s\n" % (title_bg, title)
        text += "^cs()\n"
        if body:
            text += "%s\n" % body
            text += "^uncollapse()\n"
        else:
            text += "^collapse()\n"
        id = self.dzen_feed(text)
 
        # set timeout for closing dzen
 
        if timeout <= 0:
            timeout = 3000
        self.set_timer(min(timeout, 10000))
 
        return id
 
    @dbus.service.method(NF_INTERFACE, in_signature="u")
    def CloseNotification(self, id):
        self.dzen_kill(id)
 
DBusGMainLoop(set_as_default=True)
 
service = DzenifyService()
 
glib.MainLoop().run()
