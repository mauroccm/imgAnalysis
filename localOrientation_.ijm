/* 
 * Code for cells local orientation.
 *
 * Landini and Othman, Estimation of tissue layer level by sequential 
 * morphological reconstruction. Journal of Microscopy, 2003, 209(2):118.
 * 
 * INPUT: Cell area projection (profile)
 * OUTPUT: CSV table at the log window with cell oritentation segment coordinates and
 * angle.
 * 
 * Mauro Morais, 2020-03-13.
*/

macro "localOrientation" {
  // Set batch mode
  setBatchMode(true);
  // Store cell image in buffer (F)
  original = getTitle();
  selectImage(original);
  run("Duplicate...", "title=F");

  // Get image info
  getStatistics(area, mean, min, max, std, histogram);
  getDimensions(width, height, channels, slices, frames);

  // Set a cell counter
  counter = 0;

  // Print the results header
  print(" ,X1,Y1,X2,Y2,cellAngle");

// Loop for layers
//for(i = 1; i <= layers; i ++){
  
  // Copy F as working image (WI) to exclude cells at the border
  selectImage("F");
  run("Duplicate...", "title=WI");
  
  // Extract the elements P of layer i and get their centers of mass (XM, YM)
  run("Analyze Particles...", "  show=Masks display clear include exclude record in_situ");
  XM = newArray(nResults);
  YM = newArray(nResults);
  major = newArray(nResults);

  for (p = 0; p < nResults; p ++) {
  	XM[p] = getResult("XM", p);
  	YM[p] = getResult("YM", p);
  	major[p] = getResult("Major", p);
  }

  // Loop for each element (cell) in layer i
  for(j = 0; j < XM.length; j ++) {
    
    // Set pixel at coodinates (XM, YM) to 255 in the E image (Seed)
    //selectImage("E");
    newImage("E", "8-bit black", width, height, 1);
    setPixel(XM[j], YM[j], 255);
    rename("Seed");
    
    // Reconstruct LM based on Seed
    run("BinaryReconstruct ", "mask=F seed=Seed create white");
    
    // Apply two 3x3 morphological dilatations
	  run("Dilate");
	  run("Dilate");
    
    // AND with LayerMask (to find overlap with neighbouring cell profiles in 
    // the layer)(Seed2)
    imageCalculator("AND create", "Reconstructed","F");
    rename("Seed2");
    
    // Reconstruct LayerMask based on Seed2 (reconstructs P and P_nearest)
    run("BinaryReconstruct ", "mask=F seed=Seed2 create white");
    rename("Reconstructed2");
        
    // Apply two 3x3 morphological dilatations
    run("Dilate");
    run("Dilate");
    
    // AND with LayerMask (to find overlap with next neighbouring cell profiles 
    // in the layer)(Seed3)
    imageCalculator("AND create", "Reconstructed2", "F");
    rename("Seed3");
    
    // Reconstruct LayerMask based on Seed3 
    // (reconstructs P, P_nearest and P_nextToNearest)
    run("BinaryReconstruct ", "mask=F seed=Seed3 create white");
    rename("Reconstructed3");
    
    // Get the centres of mass of the reconstructed cell profiles
    run("Analyze Particles...", "  show=Masks display clear include record in_situ");

    xpoints = newArray(nResults);
	  ypoints = newArray(nResults);

	  // Loop for each neighbouring element (cell)
    for (k = 0; k < nResults; k ++) {
    	xpoints[k] = getResult("XM", k);
    	ypoints[k] = getResult("YM", k);
    }
    
    // Find the best fitting line passing through the centres of mass
    Fit.doFit("y = a + b * x", xpoints, ypoints);
    a = Fit.p(0); // the y0
    b = Fit.p(1); // the slope
    // y = a;
    // x = a / -b;
    
    // Calculate the local orientation as the arc-tangent of the slope of 
    // the fitted line
	cellAngleRad = atan(b);
    //cellAngleRad = atan2(y, x);
    cellAngle = cellAngleRad  * (180/PI);

    // Calculate the segment line coordinates of the orientation vector
    dX = cos(cellAngleRad) * major[j]/4;
    dY = sin(cellAngleRad) * major[j]/4;

    x1 = XM[j] - dX;
    y1 = YM[j] - dY;
    x2 = XM[j] + dX;
    y2 = YM[j] + dY;

    // Print results
    counter ++;
    print(counter + "," +x1+ "," +y1+ "," +x2+ "," +y2+ "," + cellAngle);

    close("Recon*");
    close("See*");
    
  }
  close("WI");
  
//}
close("F");
close("Results");
}