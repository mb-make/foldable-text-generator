
include <settings.scad>;
use <model.scad>;

// folded paper with text and ligament cutout
color("lightgrey")
{
    // front half of the paper
    translate([
        0,
        0,
        -1
        ])
    difference()
    {
        cube([
            material_x,
            material_y/2,
            1
            ]);

        translate([
            0,
            material_y/2,
            0
            ])
        planar_text();

        translate([
            0,
            material_y / 2 - fold_size - 1,
            0
            ])
        fold_intersection_bottom();
    }

    // folded back half of the paper
    translate([
        0,
        material_y/2,
        0
        ])
    rotate([
        90,
        0,
        0
        ])
    difference()
    {
        cube([
            material_x,
            material_y/2,
            1
            ]);
        fold_intersection_top();
    }
}

// move text to foldout edge
translate([
    0,
    material_y/2 - fold_size,
    fold_size
    ])
// rotate upright
rotate([
    90,
    0,
    0
    ])
// text
planar_text();

// insert ligaments
translate([
    0,
    material_y/2 - fold_size,
    fold_size
    ])
fold_intersection_top();
