/*
 * This scripts returns the line between keratinocytes and melanoma cluster.
 * The input image must be binary and cell cros section area (Voronoi) of the
 * keratinocytes surrounding the melanoma domain.
 * 
 * Special thanks to G. Landini, Univ. of Birmingham;
 * Landini and Othman, 2003, J. of Microscopy, 
 * DOI: 10.1046/j.1365-2818.2003.01113.x
 * 
 * Mauro Morais, 2019-12-13
 * 
*/

id = getImageID();
title = getTitle();
name = replace(title, "_layers.tif", "_border.png");
setThreshold(1, 255);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Dilate");
run("Dilate");
run("Duplicate...", "title=copy");
run("Invert");
run("Dilate");
imageCalculator("AND", title, "copy");
//saveAs("png", outputDir + "/" + name);
close(id);
close("copy");