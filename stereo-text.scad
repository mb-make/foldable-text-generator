
text_string = "TEST";
text_font = "Liberation Serif:style=Bold";
text_size = 50;
fold_size = text_size * 0.90;

material_x = 210;
material_y = 297;

ligament_width = 5;
ligament_height = 4;
ligament_spacing = 2;
ligament_count = (material_x - ligament_width) / (ligament_width + ligament_spacing);

module paper_a4()
{
    color("lightgrey")
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
}

module planar_text()
{
    color("red")
    translate([
        material_x/2,
        material_y/2,
        0
        ])
    linear_extrude(height=1)
    text(
        text_string,
        size = text_size,
        font = text_font,
        valign = "top",
        halign = "center"
    );
}

module fold_line(y)
{
    // middle folding ligaments
    for (i = [0:ligament_count])
    {
        translate([
            i * (ligament_width+ligament_spacing),
            y - ligament_height/2,
            0
            ])
        cube([
            ligament_width,
            ligament_height,
            1
            ]);
    }
}

module fold_line_top()
{
    fold_line(material_y / 2 + fold_size);
}

module fold_line_middle()
{
    fold_line(material_y / 2);
}

module fold_line_bottom()
{
    fold_line(material_y / 2 - fold_size);
}

paper_a4();
planar_text();
color("blue")
{
    fold_line_top();
    fold_line_middle();
    fold_line_bottom();
}

color("yellow")
intersection()
{
    planar_text();
    fold_line_bottom();
}
