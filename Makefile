
all: projection.svg

projection.svg: projection.scad model.scad
	openscad $< -o $@

#%.svg: %.scad
#	openscad $< -o $@

clean:
	rm -f *.svg *.pyc

