
all: stereo-text.svg

%.svg: %.scad
	openscad $< -o $@

clean:
	rm -f *.svg

