//Input = getDirectory("Input Directory");
//Output = getDirectory("Output Directory");

Input = "/home/mauromorais/R/imgAnalysis/results/2018-08-14/SIM/";
Output = "/home/mauromorais/R/imgAnalysis/results/2018-08-14/EDT/";

imgList = getFileList(Input);


maximaCount = newArray(imgList.length);

thresholdCount = newArray(imgList.length);

setBatchMode(true); // faster

for (i = 0; i < imgList.length; i++) {

	open(Input+imgList[i]);

	imgName = File.nameWithoutExtension();

	run("8-bit");

	id = getImageID();

	// The Find Maxima counting after Euclidean Distance Transformation (EDT)

	//run("Duplicate...", "title=EDT");

	run("Exact Euclidean Distance Transform (3D)");

	//selectWindow("EDT");

	idEDT = getImageID();
	
	run("Find Maxima...", "noise=0.01 output=[Point Selection]");
	
	run("Measure");

	saveAs("Results", Output+imgName+"_EDT.txt");

	maximaCount[i] = getValue("results.count");

	selectImage(idEDT);

	saveAs("png", Output+imgName+"_EDT.png");

	close();

	selectImage(id);

	setThreshold(29, 255);
	
	setOption("BlackBackground", true);
	
	run("Convert to Mask");

	run("Watershed");
	
	run("Analyze Particles...", "circularity=0-1.0 size=0-Infinity pixel show=Nothing display clear include");

	saveAs("Results", Output+imgName+"_TH.txt");

	thresholdCount[i] = getValue("results.count");

	run("Clear Results");

	selectImage(id);

	saveAs("png", Output+imgName+"_TH.png");

	close();

}

run("Clear Results");

// Save the results of the counts
for(i=0;i<imgList.length; i++){

	setResult("imgList", i, imgList[i]);
	//setResult("thresholdMinValue", i, thresholdMinValue[i]);
	setResult("findMaximaCount", i, maximaCount[i]);
	setResult("thresholdCount", i, thresholdCount[i]);
	//setResult("thresholdMethod", i, thresholdMethod[i]);

}
updateResults();
saveAs("Results", Output+"sphereCount.txt");