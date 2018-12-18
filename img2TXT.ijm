// Convert images to text images
//
// Mauro Morais, 2018-08-13

inDir = getDirectory("Input Directory");
outDir = getDirectory("Output Directory");

fileList = getFileList(inDir);

setBatchMode(true);
for(i = 0; i<fileList.length; i++){
	
	open(inDir+fileList[i]);

	imgName = File.nameWithoutExtension();

	saveAs("Text Image", outDir+imgName+".txt");

	close();


	
}
print("DONE!");