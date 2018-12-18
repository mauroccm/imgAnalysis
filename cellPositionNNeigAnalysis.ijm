/*
 * Este script abre uma tabela com a posição de cada célula (X e Y), 
 * Cria uma nova imagem com as posições de cada uma (não salva),
 * Gera a imagem segmetada (Voronoi) para a análise de primeiros vizinhos.
 * 
 * Mauro Morais, 2018-09-06
 */

inDir = getDirectory("Input a Directory");
outDir = getDirectory("Output a Directory");
inFiles = getFileList(inDir);

// Image size
imgWidth = 1920;
imgHeight = 1536;

// Import results table
lineseparator = "\n";
cellseparator = "\t";

setBatchMode(true);
for(img = 0; img < inFiles.length; img ++){ // loop
	
	// copies the whole table to an array of lines
	lines=split(File.openAsString(inDir + inFiles[img]), lineseparator);

	// recreates the columns headers
	labels=split(lines[0], cellseparator);
	if (labels[0]==" "){
 	  	k=1; // it is an ImageJ Results table, skip first column
	} else {
		k=0; // it is not a Results table, load all columns
	}
        
	for (j=k; j<labels.length; j++){
		setResult(labels[j],0,0);
	}

	// dispatches the data into the new results table
	run("Clear Results");
	for (i=1; i<lines.length; i++) {
		items=split(lines[i], cellseparator);
	
		for (j=k; j<items.length; j++) {
			setResult(labels[j],i-1,items[j]);
		}
	}
	updateResults();

	// get the cell positions
	X = newArray(nResults);
	Y = newArray(nResults);

	for (l = 0; l < nResults; l++) {
		X[l] = getResult("X", l);
		Y[l] = getResult("Y", l);
	}
	//run("Close");

	// generate empty image
	setForegroundColor(255, 255, 255);
	setBackgroundColor(0, 0, 0);
	newImage(inFiles[img], "8-bit black", imgWidth, imgHeight, 1);
	
	// mark cell positions
	for(l = 0; l < nResults; l++) {
		makePoint(X[l], Y[l]);
		fill();
	}
	run("Select None");
	imgID = getImageID();
	imgName = File.nameWithoutExtension;

	// generate the segmented particles
	run("Find Maxima...", "noise=1 output=[Segmented Particles]");

	saveAs("Tiff", outDir + inFiles[img] + ".tif");
	close();

	selectWindow("Results");
	run("Close");

	print((img+1) + " of " + inFiles.length);
}

print("JOB DONE!");