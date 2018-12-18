/*
// AutoCellCounter_Global_v125.ijm
// Script para contagem de núcleos marcados com Hoechst em imagens de 
// fluorescência capturadas com filtro azul (DAPI).
// As imagens devem ser 8-bit do canal azul após terem sido limpadas
// com imgCleaner.ijm.

// Data: 2018-06-20; v1.2.5
*/

initTime = getTime(); // start time

//k = 1; // Methods number. From 0 to 16.

// The imput directory with TIFF images
//dirIn = getDirectory("Input directory"); 
dirIn = "/home/mauromorais/Pictures/Exp19/hacat_HOE_clean_v13/";
imgList = getFileList(dirIn);	//get the image file list

// Global threshold methods
/*
Methods = newArray("Default","Huang","Intermodes","IsoData",
	"IJ_IsoData","Li","MaxEntropy","Mean", "MinError",
	"Minimum","Moments","Otsu","Percentile",
	"RenyiEntropy","Shanbhag","Triangle","Yen");
*/
Methods = getList("threshold.methods");

// Variables
thresholdMinValue = newArray(imgList.length);
//thresholdMaxValue = newArray(imgList.length);
cellCount = newArray(imgList.length);
thresholdMethod = newArray(imgList.length);

methodTime = newArray(Methods.length);
methodMemory = newArray(Methods.length);

// The output directory with text result tables
//dirOut = getDirectory("Output directory");
dirOut = "/home/mauromorais/Pictures/Exp19/tmp/";

// Set the measurements and configuration
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction stack limit display nan redirect=None decimal=4");
run("Input/Output...", "jpeg=85 gif=-1 file=.txt use_file copy_column save_column");

setBatchMode(true);	//faster and hide details from user
for (k=0; k<4; k++){ //testing purpose
//for (k=0; k<Methods.length; k++){ //loop Methods

	methodInitTime = getTime(); // initial time
	methodMemory[k] = 0;

	File.makeDirectory(dirOut+Methods[k]);
	for (i=0; i<24; i++) { //loop 24 images to test
	//for (i=0; i<imgList.length; i++) { //loop images

		File.makeDirectory(dirOut+Methods[k]+"/"); // output folder for individual files
		open(dirIn+imgList[i]);
		run("Set Scale...", "distance=0"); //to remove scale, if any
		Name = File.nameWithoutExtension();
		run("Duplicate...", "title="+Name+"_copy");
		setAutoThreshold(Methods[k]+" dark");
		thresholdMethod[i] = Methods[k];
		getThreshold(min, max);
		thresholdMinValue[i] = min;
		//thresholdMaxValue[i] = max;
		run("Convert to Mask");
		run("Watershed");
		run("Create Selection");

		methodMemory[k] = methodMemory[k] + parseInt(IJ.currentMemory());
		close();

		selectWindow(Name+".tif");
		setThreshold(min, max);
		run("Restore Selection");
		// 'size=980-Infinity added' in v124
		// 'circularity=0.562-1' added in v125
		run("Analyze Particles...", "circularity=0.562-1.000 size=980-Infinity pixel show=Nothing display clear include");
		saveAs("Results", dirOut+Methods[k]+"/"+imgList[i]+"_"+Methods[k]+".txt");
		cellCount[i] = getValue("results.count");

		methodMemory[k] = methodMemory[k] + parseInt(IJ.currentMemory());
		run("Close"); // to close Results window

		selectWindow(imgList[i]);

		methodMemory[k] = methodMemory[k] + parseInt(IJ.currentMemory());
		close();

	}
	
	Array.show("AutoCellCounter_"+Methods[k]+" (indexes)", imgList, thresholdMinValue, cellCount, thresholdMethod); //thresholMaxValue
	//saveAs("AutoCellCounter_"+Methods[k], dirOut+"AutoCellCounter_"+Methods[k]+".txt");
	saveAs("text", dirOut+"AutoCellCounter_"+Methods[k]+".txt");

	methodMemory[k] = methodMemory[k] + parseInt(IJ.currentMemory());

	run("Close"); // to close AutoCellCounter results window

	methodEndTime = getTime(); // end time
	methodTime[k] = methodEndTime - methodInitTime; //method running time

	print(i+" Images DONE!");
	print("Method: "+Methods[k]);
	print("Results saved at:\n"+dirOut+"\n");
	print("Free Memory: "+IJ.freeMemory());
	print("Current Memory (bytes): "+IJ.currentMemory());
	print("Method memory (bytes): "+methodMemory[k]);
	print("Method time (ms): "+methodTime[k]);
	print("________");

}

endTime = getTime();
totalTime = endTime - initTime;

Array.show("Performance", Methods, methodTime, methodMemory);
saveAs("text", dirOut+"AutoCellCounter_performance.txt");

print("DONE all "+k+" methods!");
print("Total time (ms): "+totalTime);
print("________");
selectWindow("Log");
saveAs("text", dirOut+"AutoCellCounter_log.txt");