/*
Script para criar as máscaras após o uso de um determinado método de contagem.
Mauro Morais, 2018-08-27
*/

inDir = "C:/Users/Mauro Morais/Pictures/Pictures/Exp19/hacat_HOE_clean_v13/";
outDir = "C:/Users/Mauro Morais/Pictures/Pictures/Exp19/hacat_HOE_clean_v13_masks/";

imgList = getFileList(inDir);	//get the image file list
//thresholdMinValue = newArray(imgList.length);
cellCount = newArray(imgList.length);

run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction stack limit display nan redirect=None decimal=4");
run("Input/Output...", "jpeg=85 gif=-1 file=.txt use_file copy_column save_column");

setBatchMode(true);	//faster and hide details from user
for(i = 210; i < 240; i++){

	open(inDir+imgList[i]);
	run("Set Scale...", "distance=0"); //to remove scale, if any
	Name = File.nameWithoutExtension();
	imgID = getImageID();

	run("Duplicate...", "title="+Name+"_mask");
	//imgCopyID = getImageID();

	setAutoThreshold("Li dark");
	
	//thresholdMethod[i] = Methods;
	getThreshold(min, max);
	//thresholdMinValue[i] = min;
	//thresholdMaxValue[i] = max;
	run("Convert to Mask");
	run("Watershed");
	run("Create Selection");

	//methodMemory = methodMemory + parseInt(IJ.currentMemory());
	close(); // to close copy image

	selectImage(imgID);
	setThreshold(min, max);
	run("Restore Selection");
	// 'size=980-Infinity added' in v124
	// 'circularity=0.562-1' added in v125
	run("Analyze Particles...", "circularity=0.562-1.000 size=980-Infinity pixel show=Masks display clear include");
	//saveAs("Results", dirOut+Methods+"/"+imgList[i]+"_"+Methods+".txt");
	cellCount[i] = getValue("results.count");

	saveAs("Tiff", outDir + Name + "_mask.tif");

	//methodMemory = methodMemory + parseInt(IJ.currentMemory());
	//run("Close"); // to close Results window

	selectImage(imgID);
	close(); // to close the analyzed image


}

Array.show(cellCount);
print("JOB DONE!");
print(i);