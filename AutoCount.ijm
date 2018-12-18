/*

// AutoCount.ijm
// Script para contagem de núcleos marcados com Hoechst em imagens de 
// fluorescência capturadas com filtro azul (DAPI).
// As imagens devem ser 8-bit do canal azul.
// Este script foi desenhado para ser executado no modo
// headless com apenas um método através de um script do terminal. Os métodos
// são chamados, um de cada vez, no computerPerformance_v2.sh.
//
// Mauro Morais, 2018-12-13

*/

// The input directory with TIFF images
inDir = "/home/mauromorais/Pictures/Exp19/hacat_HOE_blue/";
imgList = getFileList(inDir);	//get the image file list

// The output directory with text result tables
outDir = "/home/mauromorais/R/imgAnalysis/results/2018-12-13/AutoCount/counts/";

// Variables
subtractBackground = newArray(false, true);
rollingBallRadius = newArray("rolling=20", "rolling=40", "rolling=80", "rolling=160", "rolling=320");
enhanceContrast = newArray(false, true);
despeckel = newArray(false, true);
gaussianBlur = newArray(false, true);
sigmaBlur = newArray("sigma=1", "sigma=2");

thresholdModel = newArray();

thresholdMinValue = newArray(imgList.length);
//thresholdMaxValue = newArray(imgList.length);
cellCount = newArray(imgList.length);


File.makeDirectory(outDir + thresholdModel);

// Set the measurements and configuration
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction stack limit display nan redirect=None decimal=4");
run("Input/Output...", "jpeg=85 gif=-1 file=.txt use_file copy_column save_column");

call("java.lang.System.gc"); // run the garbage collector

setBatchMode(true);	//faster and hide details from user
//for (i=0; i<24; i++) { //loop 24 images to test
for (i=0; i<imgList.length; i++) { //loop images

	File.makeDirectory(dirOut+models+"/"); // output folder for individual files
	open(dirIn+imgList[i]);
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
