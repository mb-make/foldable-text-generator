#!/usr/bin/python
#
# Script to insert cuts into foldable text
# graphic (SVG) exported from OpenSCAD
#
# Author: Matthias Bock <mail@matthiasbock.net>
# License: GNU GPLv3
#

from sys import argv
from utils.svg import *
from utils.path_d import *

# get filenames from console arguments
if len(argv) < 3:
    print "Usage: " + argv[0] + " <SVG in which to insert cuts> <save as filename>"
    exit()

filename_open = argv[1]
filename_save = argv[2]

# import SVG
svg = SVG(filename_open)

# split path into closed paths
before = len(svg.elements)
svg.break_apart()
print "Split "+str(before)+" path into "+str(len(svg.elements))+" paths."

# replace A4 page path by rect
# not to interfer with min/max code below
try:
    # detect A4 landscape
    if  svg.elements[0].d.segments[0].x == 297.0 \
    and svg.elements[0].d.segments[0].y == -210.0:
        print "A4 landscape detected"
        print "Replacing by rectangle..."
        r = Rect()
        r.x = 0
        r.y = -210
        r.width = 297
        r.height = 210
        r.style = "stroke:none;fill:white"
        svg.elements[0] = r
except:
    pass

# find the maximum and minimum y coordinates from all paths
min_y = None
max_y = None
for path in svg.elements:
    if path.__class__.__name__ == Path.__name__:
        # minimum y
        y = path.d.min_y()
        if (min_y == None) or (y < min_y):
            min_y = y

        # maximum y
        y = path.d.max_y()
        if (max_y == None) or (y > max_y):
            max_y = y

print "Minimum Y: " + str(min_y)
print "Maximum Y: " + str(max_y)

# in every path find and remove
# line segments from min_y to min_y
# and from max_y to max_y
for i in range(len(svg.elements)):
    path = svg.elements[i]
    if path.__class__.__name__ == Path.__name__:
        previous_x = None
        previous_y = None
        for segment in path.d.segments:
            # replace 'z' in every path by L x,y to coordinates of the first segment
            if "zZ".find(segment.type) > -1:
                segment.type = 'L'
                segment.x = path.d.segments[0].x
                segment.y = path.d.segments[0].y
                print "Replaced 'z' by '"+str(segment)+"'."

            if ("mMlL".find(segment.type) > -1):
                if (segment.y == previous_y):
                    if (segment.y == min_y) or (segment.y == max_y):
                        print "Inserting replacement path..."
                        svg.elements.append( Path("", D("M "+str(previous_x)+","+str(previous_y)+" "+str(segment)), " stroke=\"red\" stroke-dasharray=\"0.5,0.5\"") )

                        print "Removing '"+str(segment)+"'..."
                        segment.type = "M"

                previous_x = segment.x
                previous_y = segment.y

# export SVG
svg.save_as(filename_save)
