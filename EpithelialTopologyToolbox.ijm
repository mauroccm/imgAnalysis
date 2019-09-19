/*	Epithelial Topology Toolbox
 * 	This macro toolset contains a set of ImageJ's macro functions designed to 
 *	process 8-bit images (to make it more "segmentable" for thresholding 
 *	models); to estimate the cell area projection (Voronoi tesselation); and
 *  to draw epithelial topology mesh over the cells (Region connection calculus)
 *
 *	Functions: 
 * 		cellPosition2areaSegment(): get the nuclei postions (center of mass from 
 *		the Results table) and build the Voronoi diagram (the cell area 
 *		projection).
 * 		
 *		NFN_count(): get the cell area projections and count the number of
 *		nearest neigbor of each cell. Cells in the edge of the image are 
 *		counted as first neighbors, but excluded in the image (See the 
 *		markedNeighborArray). Other shape descrioptors are also obtained to 
 *		measure anisotropy of each cell area projection.
 *		
 *		adjMatrix(): get the cell area projections and calculates the RCC table.
 *		The RCC table is the adjacency table of each cell and it depends on the
 *		RCC8D plugin 
 *		(https://blog.bham.ac.uk/intellimic/spatial-reasoning-with-imagej-using-the-region-connection-calculus/).
 *
 *		adjMatrix2mesh(): draws the edges of the cell network over the area 
 *		segment	image. Need some improvements...
 *		
 *		imgProcessing_v??(): apply processing filter to the image. Each version
 *		adds a different processing step. v10, only selects the blue channel.
 *		v11, subtract background. v12, enhance contrast. v13, apply Gaussian
 *		filter with sigma=2; v14, subtract the background with radius=160;
 *		v16 was built using the SNR criteria; v17 is the three major processing
 *		steps. These functions will be deprected in the future and only the 
 *		imgProcessor() will be used.
 *
 * Mauro Morais, 2019-04-30
 *
 * DISCLAIMER: Original content from this work may be used under the terms of 
 * the Creative Commons Attribution 3.0 licence 
 * (http://creativecommons.org/licenses/by/3.0). Any further distribution of 
 * this work must maintain attribution to the author(s).
 *
 * WARRANTIES: None. Use at your own risk.
 * 
 */

 var myMenu = newMenu("Epithelial Topology Menu Tool", 
 	newArray(
 		//"imgProcessing_v10", "imgProcessing_v11", "imgProcessing_v12", 
 		//"imgProcessing_v13", "imgProcessing_v14", "imgProcessing_v16", 
 		//"imgProcessing_v17", 
 		"-", 
 		"imgProcessor (v16)", 
 		"-", 
 		"cellPosition2areaSegment",	"NFN_count", "adjMatrix (RCC)",	
 		"adjMatrix2mesh"));

 macro "Epithelial Topology Menu Tool - C606F00ffCff0T1b08ET6b08TTbb08T" {

 	MCmd = getArgument();

 	if(MCmd != "-") {
 		//if(MCmd == "imgProcessing_v10") {imgProcessing_v10();}
 		//if(MCmd == "imgProcessing_v11") {imgProcessing_v11();}
 		//if(MCmd == "imgProcessing_v12") {imgProcessing_v12();}
 		//if(MCmd == "imgProcessing_v13") {imgProcessing_v13();}
 		//if(MCmd == "imgProcessing_v14") {imgProcessing_v14();}
 		//if(MCmd == "imgProcessing_v16") {imgProcessing_v16();}
 		//if(MCmd == "imgProcessing_v17") {imgProcessing_v17();}
 		if(MCmd == "imgProcessor (v16)") {imgProcessor();}
 		if(MCmd == "cellPosition2areaSegment") {cellPosition2areaSegment();}
 		if(MCmd == "adjMatrix2mesh") {adjMatrix2mesh();}
 		if(MCmd == "NFN_count") {NFN_count();}
 		if(MCmd == "adjMatrix (RCC)") {adjMatrix();}
 	}
 }

/*
 * Function to estimate the cell projection area with Voronoi tesselation.
 *
 * INPUT: nuclei position talbe.
 * OUTPUT: cell area segments binary image
 * 
 */
 function cellPosition2areaSegment() {
	// Check if results table is open
	if(!isOpen("Results")) {

		warnings(0);

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

/*
 * Function to count the number of first nightbors. Particles on the edge are 
 * counted as first neighbors, but excluded from the count.
 * 
 * INPUT: cell area segments binary image.
 * OUTPUT: cell area segments with number of first neighbors highligted and
 * array of first neighbors of each cell.
 */

 function NFN_count() {

 	 	//Check if the cell area segment image is open.
 	if(nImages == 0) {
 		
 		warnings(1);

 	// Check if the image is binary.
	} else if(!is("binary")) {

		warnings(2);

	} else {

		imgName = File.nameWithoutExtension();
		id = getImageID();

		// Generate cell positions table
		run("Set Measurements...", "area centroid center perimeter bounding shape feret's fit nan redirect=None decimal=2");
		run("Analyze Particles...", "  show=Masks display clear include record in_situ");

		// Variables
		initialParticles=nResults; // numbr. of cells in the image
		XStart=newArray(nResults); // cell top-left pixel
		YStart=newArray(nResults);

		cellID = newArray(nResults); // cell ID

		XMass=newArray(nResults); // center of mass
		YMass=newArray(nResults);

		neighborArray = newArray(nResults);
		neighbors = 0;
		mostNeighbors = 0; // to count

		// get cell area projection metrics
		Table.sort("YStart"); // so it matches with the final results
		Major = newArray(nResults);
		Minor = newArray(nResults);
		AR = newArray(nResults);
		Circ = newArray(nResults);
		Angle = newArray(nResults);
		Feret = newArray(nResults);
		FeretAngle = newArray(nResults);
		Aniso = newArray(nResults);

		for(l = 0; l < nResults; l++){
			Major[l] = getResult("Major", l);
			Minor[l] = getResult("Minor", l);
			AR[l] = getResult("AR", l);
			Circ[l] = getResult("Circ.", l);
			Angle[l] = getResult("Angle", l);
			Feret[l] = getResult("Feret", l);
			FeretAngle[l] = getResult("FeretAngle", l);

			// Calculate the cell anisotropy (Legoff, 2013, Development,  doi:10.1242/dev.090878)
			Aniso[l] = ((Major[l]/2) - (Minor[l]/2)) / ((Major[l]/2) + (Minor[l]/2));
		}

		// Get cell coordinates
		for(l = 0; l < initialParticles; l ++) {

			XStart[l]=getResult("XStart", l);
			YStart[l]=getResult("YStart", l);
			toUnscaled(XStart[l], YStart[l]);

			XMass[l]=getResult("XM", l);
			YMass[l]=getResult("YM", l);
			toUnscaled(XMass[l], YMass[l]);

			cellID[l] = l + 1;
		}

		// Set measurements
		run("Set Measurements...", " redirect=None decimal=4");

		// Count neighbors
		for(i = 0; i < initialParticles; i ++) {

			doWand(XStart[i],YStart[i], 0, "8-connected");		
			run("Enlarge...", "enlarge=2");		
			run("Analyze Particles...", "size=0-Infinity circularity=0.00-1.00 show=Nothing clear record");		
			neighbors = nResults-1;		
			neighborArray[i] = neighbors;
		}

		// Select cells to be marked (cells at the image edges are excluded)
		selectImage(id);
		run("Select None");
		run("Duplicate...", "title=[" + imgName + "_NFN]");
		run("Set Measurements...", "area centroid nan redirect=None decimal=2");
		run("Analyze Particles...", "  show=Masks exclude clear include record in_situ");
		display = getTitle();
		run("Create Selection");
		run("Make Inverse");

		// Excluding cells at the edges
		markedNeighborArray = newArray(initialParticles); // numbr. of first neighbors
		Array.fill(markedNeighborArray, 0);
		
		// Fill cells with color according to number of first neighbors
		for(mark=0; mark<initialParticles; mark++) {
			if (selectionContains(XStart[mark], YStart[mark])) {
				markValue=neighborArray[mark];
				setForegroundColor(markValue, markValue, markValue);
				floodFill(XStart[mark],YStart[mark], "8-connected");
				// to count the selected (edge-excluded) particles
				markedNeighborArray[mark] = markValue;
			}
		}

		run("Select None");
		run("glasbey");

		// to show all particles count.
		Array.show(imgName, cellID, XMass, YMass, neighborArray, markedNeighborArray, 
			Major, Minor, AR, Circ, Angle, Feret, FeretAngle, Aniso);

	}
}

// Calculate the adjacency matrix (adjMatrix) based on the RCC table from the 
// RCC Multi8+ plugin.
//
// INPUT: cell area segments image.
// OUTPUT: The adjacency matrix image.
//
// https://blog.bham.ac.uk/intellimic/spatial-reasoning-with-imagej-using-the-region-connection-calculus/

function adjMatrix(){

	// Set measurements
	run("Set Measurements...", "area centroid center perimeter bounding shape feret's fit nan redirect=None decimal=4");


	// Check if the cell area segments image is open.
	if (nImages == 0) { 

		warnings(1); 

	} else {

		setOption("BlackBackground", true);

		setBackgroundColor(0, 0, 0);

		imgName = getTitle();
		
		id = getImageID();

		run("Analyze Particles...", "  show=Masks display exclude clear include record in_situ");

		run("Duplicate...", "title=copy");

		run("RCC8D Multi", "x=" + imgName + " y=copy show=RCC8D+");

		close("copy");

		selectWindow("RCC");

		// convert to binary
		//run("8-bit");
		setThreshold(10, 14); // the NC relationship is numbr 13
		run("Convert to Mask");

		// clear the upper triangle
		getDimensions(width, height, channels, slices, frames);
		makePolygon(0, 0, width, 0, width, height);
		run("Clear", "slice");
		run("Select None");

		rename("adjMatrix");

	}

}

/*
 * adjMatrix2mesh function draws the edges of the cell network over the area
 * segment image.
 * 
 * INPUT: Cell area segments image and the binary adjMatrix image.
 * OUTPUT: ROI manager with topology edges as ROIs and the edges
 * results table.
 */

function adjMatrix2mesh(){ // RCC2mesh.ijm

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

/* Image processor function to increase signal to noise ratio (SNR)
 * 
 * run the processing steps:
 * GB -> DS -> SB -> EC
*/
function imgProcessor(){
	if(nImages == 0) {

		warnings(3);

		return;

	} else {

		run("Gaussian Blur...", "sigma=2"); 

		run("Despeckle"); // the median filter
		run("Subtract...", "value=10");
	
		run("Subtract Background...", "rolling=160 sliding");
		
		// this increase the noise, but improves the segmentation
		run("Enhance Contrast", "saturated=0.35 normalize");
		
	}

}

/* The warning function */
//
// This function is called if something is missing from the user.

function warnings(n) {
	
	if (n == 0){ // If there's no table.

		msg = "Results table with cells center of mass required";
	
		exit(msg);
	}

	if (n == 1){ // If there's no image.

		msg = "Cell area projections image required.";
	
		exit(msg);

	}

	if (n == 2) { // If the image is not binary

		msg = "8-bit binary image (0 and 255) required.";

		exit(msg);

	}

	if (n == 3) { // If there is no image open

		msg = "8-bit image required.";

		exit(msg);

	}

	if (n == 4) { //If there is no RGB image open

		msg = "RGB image required.";

		exit(msg);

	}

}

/* Deprecated functions */
// The image "cleaner" functions /
//
// These functions are use to "clean" the image, before binarization

function imgProcessing_v16() {
	// The processing steps for this function was based on maximizing the 
	// SNR  between the input (reference) and output (test) images

	if(nImages == 0) {

		warnings(3);

		return;

	} else {

		// to reduce noise
		run("Gaussian Blur...", "sigma=2"); 

		// to reduce noise
		run("Despeckle"); 
		run("Subtract...", "value=10");

		// even ilimunation
		run("Subtract Background...", "rolling=160 sliding");

		// to increase contrast, but increase noise too... :(
		run("Enhance Contrast", "saturated=0.35 normalize");		

	}
}


function imgProcessing_v17() {

	if(nImages == 0) {

		warnings(3);

		return;

	} else {

		// to make even illumination
		run("Subtract Background...", "rolling=160 sliding");

		// to increase the contrast, but it increases noise
		run("Enhance Contrast", "saturated=0.35 normalize");

		// to filter noise
		run("Median...", "radius=4");

	}
}


function imgProcessing_v14() {

	if(nImages == 0) {

		warnings(3);

		return;

	} else {

		// to increase signal to noise ratio
		run("Enhance Contrast", "saturated=0.35 normalize");
		
		// to make even illumination
		run("Subtract Background...", "rolling=160 sliding");
	
		// to reduce noise
		run("Despeckle"); 
	
		run("Subtract...", "value=10");
	
		// this improved the count
		// added in version 1.3
		run("Gaussian Blur...", "sigma=2"); 

	}
}


function imgProcessing_v13() {

	if(nImages == 0) {

		warnings(3);

		return;

	} else {

		// to increase signal to noise ratio
		run("Enhance Contrast", "saturated=0.35 normalize");
		
		// to make even illumination
		run("Subtract Background...", "rolling=50 sliding");
	
		// to reduce noise
		run("Despeckle"); 
	
		run("Subtract...", "value=10");
	
		// this improved the count
		// added in version 1.3
		run("Gaussian Blur...", "sigma=2"); 

	}
}

function imgProcessing_v12() {

	if(nImages == 0) {

		warnings(3);

		return;

	} else {

		// to increase signal to noise ratio
		run("Enhance Contrast", "saturated=0.35 normalize");
		
		// to make even illumination
		run("Subtract Background...", "rolling=50 sliding");
	
		// to reduce noise
		run("Despeckle"); 
	
		run("Subtract...", "value=10");	
		
	}
}

function imgProcessing_v11() {

	if(nImages == 0) {

		warnings(3);

		return;

	} else {

		// to make even illumination
		run("Subtract Background...", "rolling=50 sliding");	
			
	}
}

function imgProcessing_v10() {

	if(nImages == 0) {

		warnings(4);

		return;

	} else if (is("grayscale")){

		warnings(4);

		return;

	} else {
	
		// get the title
		imgName = File.nameWithoutExtension();

		// to select the blue channel
		run("Split Channels");
	
		selectWindow(imgName + ".tif (green)");
		close();
	
		selectWindow(imgName + ".tif (red)");
		close();
	
		selectWindow(imgName + ".tif (blue)");
		rename(imgName);
			
	}
}

