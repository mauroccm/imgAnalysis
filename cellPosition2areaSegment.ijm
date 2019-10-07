/*
 * Function to estimate the cell projection area with Voronoi tesselation.
 *
 * INPUT: nuclei position talbe.
 * OUTPUT: cell area segments binary image
 * 
 */
 
macro "cellPosition2areaSegment" {
//function cellPosition2areaSegment() {
	// Check if results table is open
	if(!isOpen("Results")) {

		imagej = getDirectory("imagej");
		runMacro(imagej + "macros/ETT/warnings.ijm", 0);
		//warnings(0);

	} else {

		// Image size
		width = 1280; height = 960; // width = 1920; height = 1536; 

		Dialog.create("Choose resolution");
		Dialog.addNumber("Width:", width);
		Dialog.addNumber("Height:", height);
		Dialog.show();
		width = Dialog.getNumber();
		height = Dialog.getNumber();;

		// get the cell positions
		X = newArray(nResults);
		Y = newArray(nResults);
		//cellType = newArray(nResults);

		// generate empty image
		newImage("temp", "8-bit black", width, height, 1);
		tempImg = getImageID();

		for (l = 0; l < nResults; l++) {
			X[l] = getResult("XM", l);
			Y[l] = getResult("YM", l);
			//cellType[l] = getResult("Type", l);

			setPixel(X[l], Y[l], 255);
		}

		// generate the segments of cell area
		run("Find Maxima...", "noise=1 output=[Segmented Particles]");
		rename("areaSegments");

		selectImage(tempImg);
		close();
		
	}

}