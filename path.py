#!/usr/bin/python
#
# Library to handle paths from SVGs
# exported from OpenSCAD
#

class Path:
    def __init__(this, s, d=None, epilogue=None):
        if d == None:
            # parse from string
            a = s.find("d=\"") + 3
            b = s.find("\"", a)
            this.d = s[a:b]
            this.epilogue = s[b+1:]
        else:
            this.d = d
            this.epilogue = epilogue

    def __str__(this):
        # export as string
        return "<path d=\"" + this.d + "\"" + this.epilogue + "\n"

    #
    # split all closed paths into separate paths
    #
    def split(this):
        paths = []

        p = this.d.find("M ")
        while (p > -1):
            q = this.d.find(" z", p) + 2
            print this.d[p:q]
            paths.append( Path(None, this.d[p:q], this.epilogue) )
            p = this.d.find("M ", q)

        return paths
