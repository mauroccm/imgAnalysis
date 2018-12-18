// AutoCellCounter_Global_v124.ijm
// Script para contagem de núcleos marcados com Hoechst em imagens de 
// fluorescência capturadas com filtro azul e separados os canais.
// As imagens devem ser 8-bit do canal azul e terem sido filtrdas
// com imgCleaner.ijm v1.2.

// Data: 2017-08-25; v1.2.4

A = getTime();
print("Initial time: "+A);

//k = 1; // Methods number. From 0 to 15.

dirIn = getDirectory("Input directory"); 
//dirIn = "/home/mauromorais/Pictures/Exp19/HaCaT_HOE_clean/";
list = getFileList(dirIn);	//get the file list
Methods = newArray("Default","Huang","Intermodes","IsoData",
	"IJ_IsoData","Li","MaxEntropy","Mean",
	"Minimum","Moments","Otsu","Percentile",
	"RenyiEntropy","Shanbhag","Triangle","Yen");
thresholdMinValue = newArray(list.length);
// thresholdMaxValue = newArray(list.length);
cellCount = newArray(list.length);
thresholdMethod = newArray(list.length);
dirOut = getDirectory("Output directory");
//dirOut = "/home/mauromorais/Pictures/Exp19/HaCaT_AutoCellCounter_"+Methods[k]+"/"; //File.separator
File.makeDirectory(dirOut);

//run("Set Measurements...", "area centroid shape limit display redirect=None decimal=4");
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction stack limit display nan redirect=None decimal=4");
run("Input/Output...", "jpeg=85 gif=-1 file=.txt use_file copy_column save_column");

setBatchMode(true);	//faster
//for (k=0; k<3; k++){ //testing purpose
for (k=0; k<Methods.length; k++){ //loop Methods
	for (i=0; i<list.length; i++) { //loop images
		open(dirIn+list[i]);
		run("Set Scale...", "distance=0"); //to remove scale
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
		close();
		selectWindow(Name+".tif");
		setThreshold(min, max);
		run("Restore Selection");
		// 'size: 1000-Infinity added' in v124
		run("Analyze Particles...", "size=1000-Infinity pixel show=Nothing display clear include");
		saveAs("Results", dirOut+list[i]+"_"+Methods[k]+".txt");
		cellCount[i] = getValue("results.count");
		selectWindow(list[i]);
		close();
		//selectWindow("Results");
		//close();
	}

	print(i+" Images DONE!");
	print("Method: "+Methods[k]);
	print("Results saved at:\n"+dirOut+"\n");

	Array.show("AutoCellCounter_"+Methods[k], list, thresholdMinValue, cellCount, thresholdMethod); //thresholMaxValue
	saveAs("Results", dirOut+Methods[k]+".txt");
	//
}

B = getTime();
C = B - A;
print("DONE all "+k+" methods!");
print("End time: "+B);
print("Total time (ms): "+C);