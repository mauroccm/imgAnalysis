/* 
 * Code for cells layer orientation.
 *
 * Landini and Othman, Estimation of tissue layer level by sequential 
 * morphological reconstruction. Journal of Microscopy, 2003, 209(2):118.
 * 
 * INPUT: Cell layer
 * 
 * Mauro Morais, 2020-03-13.
*/

macro "localOrientationLayer" {
  setBatchMode(true);
  // Store cell layers image in buffer (F)
  original = getTitle();
  //cellType = "hacat";
  Dialog.create("Select cell type");
  Dialog.addChoice("Cell type", newArray("hacat", "sk147"), "hacat");
  Dialog.show();
  cellType = Dialog.getChoice();
  
  /*
  run("Duplicate...", "title=O");
  setThreshold(1, 255);
  run("Convert to Mask");
  run("Analyze Particles...", "  show=Masks display clear include record");
  */
  selectImage(original);
  run("Duplicate...", "title=F");
  
  // Get the number of layers
  getStatistics(area, mean, min, max, std, histogram);
  layers = max;
  /* old code
  run("Find Maxima...", "prominence=150 output=[Point Selection]");
  getSelectionCoordinates(xpoints, ypoints);
  layers = getPixel(xpoints[0], ypoints[0]); // the numbr. of layers
  run("Select None"); */
  
  // Ceate empty image (E)
  getDimensions(width, height, channels, slices, frames);
  //newImage("E", "8-bit black", width, height, 1);
  
  // Set a cell counter
  counter = 0;
  
  // Print the results header
  print(" ,layer,X1,Y1,X2,Y2,cellAngle,cellType");
  
  // Loop for layers
  for(i = 1; i <= layers; i ++){
    
    // Copy F as working image (WI) for layer i
    selectImage("F");
    run("Duplicate...", "title=WI");
    
    // Threhsold WI for layer i
    setThreshold(i, i);
    run("Convert to Mask");
    
    // Store image into buffer as LayerMask image (LM)
    run("Duplicate...", "title=LM");
    
    // Extract the elements P of layer i and get their centers of mass (XM, YM)
    run("Analyze Particles...", "  show=Masks display clear include record in_situ");
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
      run("BinaryReconstruct ", "mask=LM seed=Seed create white");
      
      // Apply two 3x3 morphological dilatations
	 run("Dilate");
	 run("Dilate");
      
      // AND with LayerMask (to find overlap with neighbouring cell profiles in 
      // the layer)(Seed2)
      imageCalculator("AND create", "Reconstructed","LM");
      rename("Seed2");
      
      // Reconstruct LayerMask based on Seed2 (reconstructs P and P_nearest)
      run("BinaryReconstruct ", "mask=LM seed=Seed2 create white");
      rename("Reconstructed2");
          
      // Apply two 3x3 morphological dilatations
      run("Dilate");
      run("Dilate");
      
      // AND with LayerMask (to find overlap with next neighbouring cell profiles 
      // in the layer)(Seed3)
      imageCalculator("AND create", "Reconstructed2", "LM");
      rename("Seed3");
      
      // Reconstruct LayerMask based on Seed3 
      // (reconstructs P, P_nearest and P_nextToNearest)
      run("BinaryReconstruct ", "mask=LM seed=Seed3 create white");
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
      print(counter + "," +i+ "," +x1+ "," +y1+ "," +x2+ "," +y2+ "," + cellAngle + "," + cellType);
  
      close("Recon*");
      close("See*");
      
    }
    close("LM");
    close("WI");
    
  }
  close("F");
  close("Results");
}