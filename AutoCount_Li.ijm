/* AutoCount_Li.ijm
*/

// Inputs
inDir = "/home/mauromorais/R/imgAnalysis/results/2018-09-14/sk147_HOE_clean_v13/";
imgList = getFileList(inDir);	//get the image file list
outDir = "/home/mauromorais/R/imgAnalysis/results/2018-09-14/AutoCount/";

// variables
thresholdMinValue = newArray(imgList.length);
//thresholdMaxValue = newArray(imgList.length);
cellCount = newArray(imgList.length);
thresholdMethod = newArray(imgList.length);
// nuclei Area and Circularity
// to be estimated
nucArea = "0.00-Infinity";
nucCirc = "0.00-1.00";

// Set the measurements and configuration
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction stack limit display nan redirect=None decimal=4");
run("Input/Output...", "jpeg=85 gif=-1 file=.txt use_file copy_column save_column");

call("java.lang.System.gc"); // run the garbage collector

setBatchMode(true);	//faster and hide details from user
for (i=0; i<imgList.length; i++) { //loop images

	open(inDir+imgList[i]);
	run("Set Scale...", "distance=0"); //to remove scale, if any
	Name = File.nameWithoutExtension();
	imgID = getImageID();
	run("Duplicate...", "title="+Name+"_copy");

	setAutoThreshold("Li dark");
	getThreshold(min, max);
	thresholdMinValue[i] = min;
	//thresholdMaxValue[i] = max;
	run("Convert to Mask");
	run("Watershed");
	run("Create Selection");
	saveAs("Tiff", outDir + Name + "_LiMasks.tif");

	close(); // to close copy image

	selectImage(imgID);
	setThreshold(min, max);
	run("Restore Selection");
	// 'size=980-Infinity added' in v124
	// 'circularity=0.562-1' added in v125
	run("Analyze Particles...", "circularity="+ nucCirc +" size="+ nucArea +" pixel show=Nothing display clear include");
	saveAs("Results", outDir + Name + "_LiResults.txt");
	cellCount[i] = nResults;

	selectImage(imgID);
	close(); // to close the analyzed image
		
}
	
run("Clear Results");
for(i=0;i<imgList.length; i++){
	setResult("imgList", i, imgList[i]);
	setResult("thresholdMinValue", i, thresholdMinValue[i]);
	setResult("cellCount", i, cellCount[i]);
}

updateResults();
saveAs("Results", outDir+"AutoCounter_Li.txt");

call("java.lang.System.gc"); // run the garbage collector
