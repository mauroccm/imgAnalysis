/*	Este script faz a contagem de número de primeiros vizinhos
 * 	de cada célula nas das imagens das áreas das células
 * 	(EDTMax).
 *
 *  Mauro Morais, 2018-09-06
 */

//inDir = "/home/mauromorais/R/imgAnalysis/results/2018-09-06/EDTMax/";
//outDir = "/home/mauromorais/R/imgAnalysis/results/2018-09-06/nNeig_results/";

inDir = getDirectory("Input a Directory"); // segments from EDT_findLocalMax.ijm
outDir = getDirectory("Output a Directory"); // output results, imgs and nNiegh

imgFiles = getFileList(inDir);

setBatchMode(true); //faster and hide details from user

for (k = 0; k < imgFiles.length; k++) {

	open(inDir + imgFiles[k]);
	
	imgName = File.nameWithoutExtension();
	original = getTitle();
	run("Set Measurements...", "area centroid center perimeter bounding shape fit nan redirect=None decimal=2");
	run("Analyze Particles...", "  show=Masks display clear include record in_situ");
	saveAs("Results", outDir + imgName + "_results.txt");

	// variables
	initialParticles=nResults; // numbr of particles in the image
	XStart=newArray(nResults); // particle top-left position
	YStart=newArray(nResults);

	XCenter=newArray(nResults); // centroid
	YCenter=newArray(nResults);

	neighborArray=newArray(nResults);
	neighbors=0;
	mostNeighbors=0;

	//get particle coordinates
	for(l=0; l<initialParticles; l++) {
		XStart[l]=getResult("XStart", l);
		YStart[l]=getResult("YStart", l);
		toUnscaled(XStart[l], YStart[l]);

		XCenter[l]=getResult("X", l);
		YCenter[l]=getResult("Y", l);
		toUnscaled(XCenter[l], YCenter[l]);
	}

	//set measurements
	run("Set Measurements...", " redirect=None decimal=3");
	
	// count neighbors
	for(i=0; i<initialParticles; i++) {
		doWand(XStart[i],YStart[i], 0, "8-connected");
		run("Enlarge...", "enlarge=2");
		run("Analyze Particles...", "size=0-Infinity circularity=0.00-1.00 show=Nothing clear record");
		neighbors = nResults-1;
		neighborArray[i]=neighbors;
}

	// Select (edge excluded) particles to be marked
	selectWindow(original);
	run("Select None");
	run("Duplicate...", "title=[" + original + "_display]");
	run("Set Measurements...", "area centroid nan redirect=None decimal=2");
	run("Analyze Particles...", "  show=Masks exclude clear include record in_situ");
	display = getTitle();
	run("Create Selection");
	run("Make Inverse");

	markedNeighborArray = newArray(initialParticles);
	Array.fill(markedNeighborArray, 0);
	
	// Color mark particles
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
	saveAs("Tiff", outDir + imgName + "_display.tif");
	close();

	// to show all particles count.
	Array.show("Sample", XCenter, YCenter, neighborArray, markedNeighborArray);
	saveAs("Results", outDir + imgName + "_numbrNeighborArray.txt");
	run("Close");

	selectWindow(original);
	close();

	print((k+1) + " of " + imgFiles.length);

}
print(k + " IMAGES DONE!");
