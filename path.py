#!/usr/bin/python
#
# Library to handle paths from SVGs
# exported from OpenSCAD
#

class Path:
    def __init__(this, s):
        # parse from string
        a = s.find("d=\"") + 3
        b = s.find("\"", a)
        this.d = s[a:b]
        this.epilogue = s[b+1:]

    def __str__(this):
        # export as string
        return "<path d=\"" + this.d + "\"" + this.epilogue + "\n"
