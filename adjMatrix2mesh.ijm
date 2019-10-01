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
	edgeCol = "red";
	imgID = getImageID();
	imgName = File.nameWithoutExtension;
	run("Clear Results");

	// Get edges positions coordinates
	selectWindow("adjMatrix");
	//run();
	run("Points from Mask"); // This is a Fiji command
	getSelectionCoordinates(cellA, cellB); // the cell pairs indexes
	
	x0 = newArray(cellA.length);
	y0 = newArray(cellA.length);

	x1 = newArray(cellA.length);
	y1 = newArray(cellA.length);

	selectImage(imgID);
	run("Analyze Particles...", " show=Masks display exclude clear include record in_situ");

	for (j = 0; j < cellA.length; j++) {

		//cell1 = cellA[j];
		//cell2 = cellB[j];

		x0[j] = getResult("XM", cellA[j]);
		y0[j] = getResult("YM", cellA[j]);

		x1[j] = getResult("XM", cellB[j]);
		y1[j] = getResult("YM", cellB[j]);

		selectImage(imgID);
		makeLine(x0[j], y0[j], x1[j], y1[j]);
		// drawLine(x0[j], y0[j], x1[j], y1[j]);
		// roiManager("add & draw");
		roiManager("add"); // Add edges to ROI manager to generate edges list
		
		
	}

	run("Clear Results");
	roiManager("Show All without labels");
	roiManager("Set Color", edgeCol);
	roiManager("Set Line Width", 4);
	//roiManager("Save", edgesDir + segmentsFiles[i] + "_edgesRois.zip");
	roiManager("multi-measure measure_all");
	//saveAs("Results", edgesDir + segmentsFiles[i] + "_edgesResults.txt");
	//run("Clear Results");
}