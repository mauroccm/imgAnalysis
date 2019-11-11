/*
 * adjMatrix2mesh function draws the edges of the cell network over the area
 * segment image.
 * 
 * INPUT: Cell area segments image and the binary adjMatrix image.
 * OUTPUT: ROI manager with topology edges as ROIs and the edges
 * results table.
 */

macro "adjMatrix2mesh" {
//function adjMatrix2mesh(){ // RCC2mesh.ijm

	// Set Measurements
	// edgeCol = "red";
	run("Set Measurements...", "area centroid center perimeter bounding nan redirect=None decimal=4");
	run("Overlay Options...", "stroke=red width=4 fill=none apply set");

	imgID = getImageID();
	imgName = File.nameWithoutExtension;
	run("Clear Results");

	// Get edges positions coordinates
	selectWindow("adjMatrix");
	//run();
	run("Points from Mask"); // This is a Fiji command
	getSelectionCoordinates(cellA, cellB); // the cell pairs indexes
	
	// Cell pairs positions
	x0 = newArray(cellA.length);
	y0 = newArray(cellA.length);

	x1 = newArray(cellA.length);
	y1 = newArray(cellA.length);

	selectImage(imgID);
	// to exclude edge particles
	run("Analyze Particles...", " show=Masks display exclude clear include record in_situ");

	// Get particles positions
	for (j = 0; j < cellA.length; j++) {

		//cell1 = cellA[j];
		//cell2 = cellB[j];

		x0[j] = getResult("XM", cellA[j]);
		y0[j] = getResult("YM", cellA[j]);

		x1[j] = getResult("XM", cellB[j]);
		y1[j] = getResult("YM", cellB[j]);
	}

	// Draw topology edges
	selectImage(imgID);
	run("Clear Results");
	
	for(j = 0; j < cellA.length; j ++) {
		makeLine(x0[j], y0[j], x1[j], y1[j]);
		run("Measure");
		run("Add Selection..."); // add to overlay
		run("Select None");
		
	}

}