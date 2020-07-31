/*
 * Calculate the adjacency matrix (adjMatrix) based on the RCC table from the 
 * RCC Multi8+ plugin.
 *
 * INPUT: cell area segments image.
 * OUTPUT: The adjacency matrix image.
 *
 * https://blog.bham.ac.uk/intellimic/spatial-reasoning-with-imagej-using-the-region-connection-calculus/
 *
 * Acknowledgements to Gabriel Landini, University of Birmingham;
 * for providing the RCC8+ plugin.
*/


macro "adjMatrix" {
//function adjMatrix(){

	// Set measurements
	run("Set Measurements...", "area centroid center perimeter bounding shape feret's fit nan redirect=None decimal=4");


	// Check if the cell area segments image is open.
	if (nImages == 0) { 

		imagej = getDirectory("imagej");
		runMacro(imagej + "macros/ETT/warnings.ijm", 1)
		//warnings(1);

	} else {

		setOption("BlackBackground", true);

		setBackgroundColor(0, 0, 0);

		//name = replace(getTitle(), "areaSegments.tif", "adjMatrix.tif");
		imgName = File.nameWithoutExtension;
		
		id = getImageID();

		// Cells touching the image borders are included
		run("Analyze Particles...", "  show=Masks display clear include record in_situ");

		run("Duplicate...", "title=copy");

		/* The latest version of RCC8D plugin is much faster v.2.5 is much faster */
		run("RCC8D UF Multi", "x=copy y=copy show=RCC8D+");

		close("copy");

		selectWindow("RCC");

		/* convert to binary */
		run("8-bit");
		setThreshold(167, 255); // the NC relationship is numbr 13
		run("Convert to Mask");

		/* clear the upper triangle */
		getDimensions(width, height, channels, slices, frames);
		makePolygon(0, 0, width, 0, width, height); // to clear the upper triangle
		run("Clear", "slice");
		run("Select None");

		rename("adjMatrix");

		//rename(imgName + "_adjMatrix");
		//saveAs("tiff", imgName + "_adjMatrix.tif");

	}

	//return 0;
}