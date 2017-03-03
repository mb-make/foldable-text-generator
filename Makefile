#
# Makefile for automated lasercut file generation
#
# Author: Matthias Bock <mail@matthiasbock.net>
# License: GNU GPLv3
#

all: cutfile

cutfile: cuts
cuts: cuts-red.svg

projection: projection.svg
projection.svg: projection.scad model.scad settings.scad
	openscad $< -o $@

cuts-dashed.svg: projection.svg
	./cutter.py $< $@

cuts-red.svg: cuts-dashed.svg
	cat $< | replace "stroke=\"black\" fill=\"lightgray\"" "stroke=\"red\" fill=\"none\"" > $@

clean:
	rm -f *.svg *.pyc *~

