/*
// AutoCellCounter_Global_v125.ijm
// Script para contagem de núcleos marcados com Hoechst em imagens de 
// fluorescência capturadas com filtro azul (DAPI).
// As imagens devem ser 8-bit do canal azul após terem sido limpadas
// com imgCleaner.ijm. Este script foi desenhado para ser executado no modo
// headless.

// Data: 2018-06-26; v1.2.6
*/

initTime = getTime(); // start time

// The imput directory with TIFF images
//dirIn = getDirectory("Input directory"); 
dirIn = "/home/mauromorais/Pictures/Exp19/hacat_HOE_clean_v10/";
imgList = getFileList(dirIn);	//get the image file list

// The output directory with text result tables
//dirOut = getDirectory("Output directory");
dirOut = "/home/mauromorais/Pictures/Exp19/AutoCount_fromCleanV10/";


// Global threshold methods
/*
Methods = newArray("Default","Huang","Intermodes","IsoData",
	"IJ_IsoData","Li","MaxEntropy","Mean", "MinError",
	"Minimum","Moments","Otsu","Percentile",
	"RenyiEntropy","Shanbhag","Triangle","Yen");
*/
//k = 1; // Methods number. From 0 to 16.

Methods = getList("threshold.methods");

// Variables
thresholdMinValue = newArray(imgList.length);
//thresholdMaxValue = newArray(imgList.length);
cellCount = newArray(imgList.length);
thresholdMethod = newArray(imgList.length);

methodTime = newArray(Methods.length);
methodMemory = newArray(Methods.length);

// Set the measurements and configuration
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction stack limit display nan redirect=None decimal=4");
run("Input/Output...", "jpeg=85 gif=-1 file=.txt use_file copy_column save_column");

setBatchMode(true);	//faster and hide details from user
//for (k=0; k<4; k++){ //testing purpose
for (k=0; k<Methods.length; k++){ //loop Methods

	methodInitTime = getTime(); // initial time
	call("java.lang.System.gc"); // run the garbage collector
	methodMemory[k] = 0;

	File.makeDirectory(dirOut+Methods[k]);
	//for (i=0; i<24; i++) { //loop 24 images to test
	for (i=0; i<imgList.length; i++) { //loop images

		File.makeDirectory(dirOut+Methods[k]+"/"); // output folder for individual files
		open(dirIn+imgList[i]);
		run("Set Scale...", "distance=0"); //to remove scale, if any
		Name = File.nameWithoutExtension();
		imgID = getImageID();

		run("Duplicate...", "title="+Name+"_copy");
		//imgCopyID = getImageID();

		setAutoThreshold(Methods[k]+" dark");
		thresholdMethod[i] = Methods[k];
		getThreshold(min, max);
		thresholdMinValue[i] = min;
		//thresholdMaxValue[i] = max;
		run("Convert to Mask");
		run("Watershed");
		run("Create Selection");

		methodMemory[k] = methodMemory[k] + parseInt(IJ.currentMemory());
		close(); // to close copy image

		//selectWindow(Name+".tif");
		selectImage(imgID);

		setThreshold(min, max);
		run("Restore Selection");
		// 'size=980-Infinity added' in v124
		// 'circularity=0.562-1' added in v125
		run("Analyze Particles...", "circularity=0.562-1.000 size=980-Infinity pixel show=Nothing display clear include");
		saveAs("Results", dirOut+Methods[k]+"/"+imgList[i]+"_"+Methods[k]+".txt");
		cellCount[i] = getValue("results.count");

		methodMemory[k] = methodMemory[k] + parseInt(IJ.currentMemory());
		//run("Close"); // to close Results window

		selectImage(imgID);
		close(); // to close last image
		
		//selectWindow(imgList[i]);
		//selectImage(imgID);

		//methodMemory[k] = methodMemory[k] + parseInt(IJ.currentMemory());
		//close();

	}
	
	//Array.show("AutoCellCounter_"+Methods[k]+" (indexes)", imgList, thresholdMinValue, cellCount, thresholdMethod); //thresholMaxValue

	// Anotate the counting results and save
	run("Clear Results");
	for(i=0;i<imgList.length; i++){
	//for(i=0;i<24; i++){
		setResult("imgList", i, imgList[i]);
		setResult("thresholdMinValue", i, thresholdMinValue[i]);
		setResult("cellCount", i, cellCount[i]);
		setResult("thresholdMethod", i, thresholdMethod[i]);
	}
	updateResults();
	saveAs("Results", dirOut+"AutoCellCounter_"+Methods[k]+".txt");

	methodMemory[k] = methodMemory[k] + parseInt(IJ.currentMemory());

	//run("Close"); // to close AutoCellCounter results window

	methodEndTime = getTime(); // end time
	methodTime[k] = methodEndTime - methodInitTime; //method running time

	IJ.log(i+" Images DONE!");
	IJ.log("Method: "+Methods[k]);
	IJ.log("Results saved at:\n"+dirOut+"\n");
	IJ.log("Free Memory: "+IJ.freeMemory());
	IJ.log("Current Memory (bytes): "+IJ.currentMemory());
	IJ.log("Method memory (bytes): "+methodMemory[k]);
	IJ.log("Method time (ms): "+methodTime[k]);
	IJ.log("________");

}


//Array.show("Performance", Methods, methodTime, methodMemory);
run("Clear Results");
for(i=0;i<Methods.length; i++){
//for(i=0;i<4; i++){
	setResult("Methods", i, Methods[i]);
	setResult("methodTime", i, methodTime[i]);
	setResult("methodMemory", i, methodMemory[i]);
}
updateResults();
saveAs("Results", dirOut+"AutoCellCounter_performance.txt");
//saveAs("text", dirOut+"AutoCellCounter_performance.txt");
//run("Close"); // to close AutoCellCounter performance window

endTime = getTime();
totalTime = endTime - initTime;

IJ.log("DONE all "+k+" methods!");
IJ.log("Total time (ms): "+totalTime);
IJ.log("________");
call("java.lang.System.gc"); // run the garbage collector
//selectWindow("Log");
//saveAs("text", dirOut+"AutoCellCounter_log.txt");