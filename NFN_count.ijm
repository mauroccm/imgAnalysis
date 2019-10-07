/*
 * Function to count the number of first nightbors. Particles on the edge are 
 * counted as first neighbors, but excluded from the count.
 * 
 * INPUT: cell area segments binary image.
 * OUTPUT: cell area segments with number of first neighbors highligted and
 * array of first neighbors of each cell.
 */

 macro "NFN_count" {
 //function NFN_count() {

 	 //Check if the cell area segment image is open.
 	if(nImages == 0) {
 		
 		imagej = getDirectory("imagej");
		runMacro(imagej + "macros/ETT/warnings.ijm", 1);
 		//warnings(1);

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

		//saveAs("tiff", imgName + "_NFNcount.tif");

		// to show all particles count.
		Array.show(imgName + "_NFN", cellID, XMass, YMass, neighborArray, markedNeighborArray, 
			Major, Minor, AR, Circ, Angle, Feret, FeretAngle, Aniso);

	}
}