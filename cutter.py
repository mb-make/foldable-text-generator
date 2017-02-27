#!/usr/bin/python
#
# Script to insert cuts into stereo-text SVG
# exported from OpenSCAD
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
before = len(svg.paths)
svg.break_apart()
print "Split "+str(before)+" path into "+str(len(svg.paths))+" paths."

# find short path, assume it to be a cut path
for path in svg.paths:
    if len(path) < 10:
        print "Rewriting short cut path: \n\t" + str(path.d)

        # extract relevant coordinates
        a = path.d.min_x()
        b = path.d.max_x()
        y = path.d.min_y()

        # rewrite path
        s = "M "+str(a)+","+str(y)+" L "+str(b)+","+str(y)
        print "\t"+s
        path.d = D(s)

# find the maximum and minimum y coordinates from all paths
min_y = None
max_y = None
for path in svg.paths:
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
for i in range(len(svg.paths)):
    path = svg.paths[i]
    previous_x = None
    previous_y = None
    for segment in path.d.segments:
        # replace 'z' in every path by L x,y to coordinates of the first segment
        if segment.type == 'z':
            segment.type = 'L'
            segment.x = path.d.segments[0].x
            segment.y = path.d.segments[0].y
            print "Replaced 'z' by '"+str(segment)+"'."

        if ("ML".find(segment.type) > -1):
            if (segment.y == previous_y):
                if (segment.y == min_y) or (segment.y == max_y):
                    print "Inserting replacement path..."
                    svg.paths.append( Path("", D("M "+str(previous_x)+","+str(previous_y)+" "+str(segment)), " stroke=\"red\" stroke-dasharray=\"0.5,0.5\"") )

                    print "Removing '"+str(segment)+"'..."
                    segment.type = "M"

            previous_x = segment.x
            previous_y = segment.y

# export SVG
svg.save_as(filename_save)
