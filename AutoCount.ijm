/*

	// AutoCount.ijm
	Script to count labeled nuclei in fluorescent images captured with the blue
	filter. Images are 8-bit format. This script was designed to be executed in
	the Fiji headless mode by calling the code from the command line. The 
	segmentation models are called each execution with the 
	computerPerformance_v2.sh script.

	USAGE:
	<Fiji folder>/ImageJ-linux64 --headless -macro <macro folder>/<macro file>.ijm

	// Mauro Morais, 2018-06-28, v 1.2.7

*/

initTime = getTime(); // start time

// Set the input directory with TIFF images
dirIn = getDirectory("Input directory"); 
//dirIn = "/home/mauromorais/Pictures/Exp19/hacat_HOE_clean_v15/";
//dirIn = "/home/mauromorais/Pictures/Exp27/HOE_clean_v14/";

imgList = getFileList(dirIn);	//get the image file list

// Set the output directory with text result tables of the counts
dirOut = getDirectory("Output directory");
//dirOut = "/home/mauromorais/Pictures/Exp19/AutoCount_fromCleanV13/";
//dirOut = "/home/mauromorais/R/imgAnalysis/results/2018-08-09_autoCount_analysis/AutoCount_fromCleanV15/autoCounts/";
//dirOut = "/home/mauromorais/R/imgAnalysis/results/2019-05-13_Exp27_autoCounts/cleanV14/autoCounts/";

// Global threshold methods
/*
Methods = newArray("Default","Huang","Intermodes","IsoData",
	"IJ_IsoData","Li","MaxEntropy","Mean", "MinError",
	"Minimum","Moments","Otsu","Percentile",
	"RenyiEntropy","Shanbhag","Triangle","Yen");
*/
//Methods = getList("threshold.methods");
//k = 1; // Methods number. From 0 to 16.

// Variables
Methods = getArgument(); // get the argument from the shell script
thresholdMinValue = newArray(imgList.length);
//thresholdMaxValue = newArray(imgList.length);
cellCount = newArray(imgList.length);
thresholdMethod = newArray(imgList.length);
methodInitTime = getTime(); // initial time
methodMemory = 0;

//for (k = 0; k < Methods.length; k++) {
	File.makeDirectory(dirOut + Methods);
//}

// Set the measurements and configuration
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction stack limit display nan redirect=None decimal=4");
run("Input/Output...", "jpeg=85 gif=-1 file=.txt use_file copy_column save_column");

call("java.lang.System.gc"); // run the garbage collector

setBatchMode(true);	//faster and hide details from user
//for (i = 0; i < 24; i++) { //loop 24 images to test
for (i = 0; i < imgList.length; i++) { //loop images

	//File.makeDirectory(dirOut+Methods+"/"); // output folder for individual files
	open(dirIn + imgList[i]);
	run("Set Scale...", "distance=0"); //to remove scale, if any
	Name = File.nameWithoutExtension();
	imgID = getImageID();

	run("Duplicate...", "title="+Name+"_copy");
	//imgCopyID = getImageID();

	setAutoThreshold(Methods+" dark");
	thresholdMethod[i] = Methods;
	getThreshold(min, max);
	thresholdMinValue[i] = min;
	//thresholdMaxValue[i] = max;
	run("Convert to Mask");
	run("Watershed");
	run("Create Selection");

	methodMemory = methodMemory + parseInt(IJ.currentMemory());
	close(); // to close copy image

	selectImage(imgID);
	setThreshold(min, max);
	run("Restore Selection");
	// 'size=980-Infinity added' in v124
	// 'circularity=0.562-1' added in v125
	run("Analyze Particles...", "circularity=0.562-1.000 size=980-Infinity pixel show=Nothing display clear include");
	saveAs("Results", dirOut+Methods+"/"+imgList[i]+"_"+Methods+".txt");
	cellCount[i] = getValue("results.count");

	methodMemory = methodMemory + parseInt(IJ.currentMemory());
	//run("Close"); // to close Results window

	selectImage(imgID);
	close(); // to close the analyzed image
		
}
	
run("Clear Results");

for(i=0;i<imgList.length; i++){
//for(i=0;i<24; i++){
	setResult("imgList", i, imgList[i]);
	setResult("thresholdMinValue", i, thresholdMinValue[i]);
	setResult("cellCount", i, cellCount[i]);
	setResult("thresholdMethod", i, thresholdMethod[i]);
	}
updateResults();
saveAs("Results", dirOut+"AutoCellCounter_"+Methods+".txt");
/* Whis did not work. :(
Array.show("AutoCellCounter", imgList, thresholdMinValue, cellCount, thresholdMethod);
save(dirOut + "AutoCellCounter_" + Methods + ".txt");
*/
methodMemory = methodMemory + parseInt(IJ.currentMemory());
methodEndTime = getTime(); // end time
methodTime = methodEndTime - methodInitTime; //method running time
endTime = getTime();
totalTime = endTime - initTime;

IJ.log(i+" Images DONE!");
IJ.log("Method: "+Methods);
IJ.log("Results saved at:\n"+dirOut+"\n");
IJ.log("Free Memory: "+IJ.freeMemory());
IJ.log("Current Memory (bytes): "+IJ.currentMemory());
IJ.log("Method memory (bytes): "+methodMemory);
IJ.log("Method time (ms): "+methodTime);
IJ.log("Total time (ms): "+totalTime);
IJ.log("________");

call("java.lang.System.gc"); // run the garbage collector
