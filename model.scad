
include <settings.scad>;

module paper_a4_landscape()
{
    translate([
        0,
        0,
        -1.5
        ])
    cube([
        a4_landscape_x,
        a4_landscape_y,
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
        material_y / 2 - fold_size - 1,
        0
        ])
    // rotate back into paper plane
    rotate([
        -90,
        0,
        0
        ])
    // make 3d again
    linear_extrude(
        height = 2
        )
    // get rid of font character curves
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

module text_model()
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
}

color("lightgrey")
paper_a4_landscape();

text_model();
