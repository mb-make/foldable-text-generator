#
# Makefile for automated lasercut file generation
#
# Author: Matthias Bock <mail@matthiasbock.net>
# License: GNU GPLv3
#

all: cutfile

cutfile: cuts
cuts: cuts-hairline.svg

projection: projection.svg
projection.svg: projection.scad model.scad settings.scad
	openscad $< -o $@

cuts-dashed.svg: projection.svg
	./cutter.py $< $@

cuts-red.svg: cuts-dashed.svg
	cat $< | replace "stroke=\"black\" fill=\"lightgray\"" "stroke=\"red\" fill=\"none\"" > $@

cuts-hairline.svg: cuts-red.svg
	cat $< | sed -e "s/stroke-width=\"\([0-9]*\.[0-9]*\)\"//g" -e "s/stroke=\"red\"/stroke=\"red\" stroke-width=\"0.1\"/g" > $@

clean:
	rm -f *.svg *.pyc *~

