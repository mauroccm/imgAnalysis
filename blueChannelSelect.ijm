/*
 * Script to select the blue channel in the Exp19 image set
 * 
 * 2018-12-13, Mauro Morais
 */

inDir = getDirectory("Input files");
outDir = getDirectory("Output files"); // ~/Pictures/Exp19/
imgList = getFileList(inDir);	//get the images file list

setBatchMode(true);	//faster
for (i=0; i<imgList.length; i++) {
	
	open(inDir+imgList[i]);
	
	Name = File.nameWithoutExtension;
	run("Split Channels");
	
	selectWindow(imgList[i]+" (green)");
	close();
	
	selectWindow(imgList[i]+" (red)");
	close();
	
	selectWindow(imgList[i]+" (blue)");
	saveAs("Tiff", outDir+Name+".tif");
	close();
}

print("DONE!");
