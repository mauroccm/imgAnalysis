/* 
 * This script counts the number of cells (particles) in the image.
 * It opens the preprocessed 8-bit image, binarize with minimum cross-entropy
 * thresholding model and count the number of particles.
 * 
 * INPUT: 8-bit grayscale nuclei image.
 * OUTPUT: Results table with metrics of eacg nuclei, the number of 
 * nuclei and thresholding segmentation values.
 *
*/

macro "Count Cells" {
	// Count the number of cells/nuclei in an image.
	if(!is("grayscale")){

		runMacro("ETT/warnings.ijm", 3);

	} else {

		//run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction stack limit display nan redirect=None decimal=4");
		
		run("Set Scale...", "distance=0"); //to remove scale, if any

		// get image data
		getDimensions(width, height, channels, slices, frames);
		
		Name = File.nameWithoutExtension();
		imgID = getImageID();

		run("Duplicate...", "title=segmentation");

		setAutoThreshold("Li dark");

		getThreshold(min, max);
		thresholdMinValue = min;
		//thresholdMaxValue[i] = max;
		run("Convert to Mask");
		run("Watershed");
		run("Create Selection");
		//close(); // to close copy image

		selectImage(imgID);
		setThreshold(min, max);
		run("Restore Selection");

		// Count the particles
		run("Particles4 ", "white label morphology show=Particles filter minimum=10 maximum=9999999 display overwrite redirect=None");
		run("glasbey on dark");
		//run("Analyze Particles...", "circularity=0.500-1.000 size=10-Infinity pixel show=Nothing display clear include add");
		cellCount = nResults;

		selectImage(imgID);
		//close(); // to close the analyzed image

		// print report
		print("----------");
		print("Image: " + getTitle());
		print("Threshold value: " + thresholdMinValue);
		print("Cell count: " + cellCount);
		print("----------");
	
	}
	
}
