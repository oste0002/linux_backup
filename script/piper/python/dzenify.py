#!/usr/bin/env python3
import glib
import dbus
import dbus.service
from dbus.mainloop.glib import DBusGMainLoop
import subprocess

DZEN_ARGS = ["dzen2"]

NF_SERVICE = "org.freedesktop.Notifications"
NF_OBJECT = "/org/freedesktop/Notifications"
NF_INTERFACE = "org.freedesktop.Notifications"

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
        if not self._proc:
            self._proc = subprocess.Popen(DZEN_ARGS, stdin=subprocess.PIPE)

        try:
            self._proc.stdin.write(line.encode("utf-8") + b"\n")
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
        secs = int(timeout / 1000)
        if self._timer:
            glib.source_remove(self._timer)
        self._timer = glib.timeout_add_seconds(secs, self.timer_callback)

    def timer_callback(self):
        self.dzen_kill()
        self._timer = None
        return False

    @dbus.service.method(NF_INTERFACE, out_signature="ssss")
    def GetServerInformation(self):
        return ("dzenify", "dzenify", "1.0", "1.2")

    @dbus.service.method(NF_INTERFACE, out_signature="as")
    def GetCapabilities(self):
        return []

    @dbus.service.method(NF_INTERFACE, in_signature="susssasa{sv}i", out_signature="u")
    def Notify(self, app_name, id, icon, summary, body, actions, hints, timeout):
        id = self.dzen_feed(summary)
        self.set_timer(min(timeout or 3000, 10000))
        return id

    @dbus.service.method(NF_INTERFACE, in_signature="u")
    def CloseNotification(self, id):
        self.dzen_kill(id)

DBusGMainLoop(set_as_default=True)

service = DzenifyService()

glib.MainLoop().run()

