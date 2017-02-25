
material_x = 210;
material_y = 297;

text_string = "TEST";
text_font = "Liberation Serif:style=Bold";
text_size = 50;
fold_size = text_size * 0.90;

ligament_width = 1;
ligament_height = 1;
ligament_spacing = 1;
ligament_count = (material_x - ligament_width) / (ligament_width + ligament_spacing);

module paper_a4()
{
    translate([
        0,
        0,
        -1.5
        ])
    cube([
        material_x,
        material_y,
        1
        ]);
}

module planar_text()
{
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
        $fn = 200,
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

module fold_line_middle()
{
    fold_line(material_y / 2);
}

module fold_intersection_top()
{
    // move above text
    translate([
        0,
        material_y / 2,
        0
        ])
    // rotate back to A4 plane
    rotate([
        -90,
        0,
        0
        ])
    // extrude intersection to rectangles
    linear_extrude(
        height = fold_size
        )
    // generate projection of cut-out text-top
    projection()
    // rotate intersection into projection plane (xy)
    rotate([
        90,
        0,
        0
        ])
    // generate intersection of line and text-top
    intersection()
    {
        // text, aligned to top, extruded to 3d
        translate([
            material_x / 2,
            0,
            0
            ])
        linear_extrude(height=1)
        {
            text(
                text_string,
                font = text_font,
                size = text_size,
                valign = "top",
                halign = "center"
                );
        }

        // straight line (3d)
        cube([
            material_x,
            1,
            1
            ]);
    }
}

module fold_intersection_bottom()
{
    // move up, right below text
    translate([
        0,
        material_y / 2 - fold_size + 0.5,
        0
        ])
    linear_extrude(
        height = 1
        )
    // generate projection
    projection()
    // rotate into projection plane
    rotate([
        90,
        0,
        0
        ])
    // generate intersection of text and line
    intersection()
    {
        // text, aligned to bottom, extruded to 3d
        translate([
            material_x / 2,
            0,
            0
            ])
        linear_extrude(height=1)
        {
            text(
                text_string,
                font = text_font,
                size = text_size,
                valign = "bottom",
                halign = "center"
                );
        }
        // straight line (3d)
        cube([
            material_x,
            1,
            1
            ]);
    }
}

/*
color("lightgrey")
paper_a4();
*/

projection()
{

    // cut fold lines into ligament-text union
    difference()
    {
        // make a union of text and ligaments
        union()
        {
            color("green")
            planar_text();

            color("yellow")
            {
                fold_intersection_top();
                fold_intersection_bottom();
            }
        }

        fold_line_middle();
    }
}
