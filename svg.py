#!/usr/bin/python
#
# Library to work with SVGs exported from OpenSCAD
#

from path import *

class SVG:
    def __init__(this, filename):
        # parse from file
        this.svg = open(filename).read()

        first_occurence_of_a_path = this.svg.find("<path ")
        this.preamble = this.svg[:first_occurence_of_a_path]

        this.epilogue = "</svg>\n"

        this.parse_paths()

    def parse_paths(this):
        # begin with empty list
        this.paths = []

        p = this.svg.find("<path ")
        while (p > -1):
            e = this.svg.find("/>", p) + 2
            this.paths.append( Path(this.svg[p:e]) )

            # find next path
            q = p + 5
            p = this.svg.find("<path ", q)

    def __str__(this):
        return this.preamble + "\n".join([str(path) for path in this.paths]) + this.epilogue

    def save_as(this, filename):
        open(filename, "w").write(str(this))

    #
    # Split the one mega-path, which OpenSCAD exports,
    # into connected paths
    #
    def break_apart(this):
        # already several paths
        if (len(this.paths) > 1):
            return

        this.paths = this.paths[0].split()
