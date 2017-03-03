/**
 * Script to create a 2-dimensional
 * projection of the foldable text model
 *
 * Author: Matthias Bock <mail@matthiasbock.net>
 * License: GNU GPLv3
 */

use <model.scad>;

difference()
{
        projection() paper_a4_landscape();
        projection() text_model();
}
