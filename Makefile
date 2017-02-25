
all: projection.svg

projection.svg: projection.scad stereo-text.scad
	openscad $< -o $@

#%.svg: %.scad
#	openscad $< -o $@

clean:
	rm -f *.svg

