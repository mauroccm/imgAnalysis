/*
Script transformar as máscaras dos núcleos em distâncias euclidiana, encontrar
o máximo local e aplicar expanção para estimar os pontos de "contato"
célula-célula.

Mauro Morais, 2018-08-27
*/

inDir = getDirectory("Input a Directory"); // contém as mascaras dos núcleos
outDir = getDirectory("Output a Directory"); // imgs de saída são as projeções das células

noise = 0.1; // the intensity tolerance for 'Find Maxima...'
imgList = getFileList(inDir);	//get the image file list
cellCount = newArray(imgList.length);
 // count in each image

run("Set Measurements...", "area mean standard centroid center perimeter bounding fit shape nan redirect=None decimal=2");
//run("Input/Output...", "jpeg=85 gif=-1 file=.txt use_file copy_column save_column");

setBatchMode(true);	//faster and hide details from user
for(i = 0; i < imgList.length; i++){

	open(inDir+imgList[i]);
	run("Set Scale...", "distance=0"); //to remove scale, if any
	Name = File.nameWithoutExtension();
	imgID = getImageID();

	run("Find Maxima...", "noise="+ noise +" output=[Segmented Particles]");
	saveAs("png", outDir + Name + "_segments.png");

	// count the number of cells in each image
	run("Analyze Particles...", "  show=Masks display clear record in_situ");
	cellCount[i] = nResults;
	run("Close"); // close results table
	close(); // close the segments image


	selectImage(imgID);
	close(); // to close the analyzed image

	print((i+1) + " of " + imgList.length);

}

Array.show("cellCount", imgList, cellCount);
print("JOB DONE!");
