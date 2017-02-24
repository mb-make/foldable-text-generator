
text = "TEST";
font = "Liberation Serif:style=Bold";
size = 50;

material_x = 210;
material_y = 297;

ligament_width = 5;
ligament_height = 2;
ligament_spacing = 2;
ligament_count = (material_x - ligament_width) / (ligament_width + ligament_spacing);

// paper outline
color("red")
translate([
    0,
    0,
    -1
    ])
cube([
    material_x,
    material_y,
    1
    ]);

// text body
color("green")
translate([
    material_x/2,
    material_y/2,
    0
    ])
text(
    text,
    size = size,
    font = font,
    valign = "top",
    halign = "center"
);

// middle folding ligaments
for (i = [0:ligament_count])
{
    translate([
        i * (ligament_width+ligament_spacing),
        material_y / 2,
        0
        ])
    cube([
        ligament_width,
        ligament_height,
        1
        ]);
}