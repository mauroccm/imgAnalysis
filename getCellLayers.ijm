/*
 * This scripts returns the image of each cell layer from the melanoma cluster.
 * 
 * It requires the BinaryReconstruct function form the Morphology plugin:
 * https://beardatashare.bham.ac.uk/getlink/fiLUS55SmtWwJKijDRbwqv9p/morphology.zip
 * 
 * It also depends of the 'glasbey_on_dark.lut' available on Fiji.
 * 
 * Special thanks to G. Landini, Univ. of Birmingham;
 * Landini and Othman, 2003, J. of Microscopy, 
 * DOI: 10.1046/j.1365-2818.2003.01113.x
 * 
 * Mauro Morais, 2019-12-13
 * 
*/

setOption("BlackBackground", true);
title = getTitle();
i = 0;
getRawStatistics(nPixels, mean, min, max, std, histogram);
rename("reference");
//condition = "go";

run("Duplicate...", "title=ref"+i);

while(mean != 0){
//for (i = 0; i < 5; i++) {
	rename("ref"+i);

	// Calculate the ith layer line
	run("Duplicate...", "title=copy");
	run("Dilate");
	run("Duplicate...", "title=copy-1");
	run("Invert");
	run("Dilate");
	run("Dilate");
	imageCalculator("AND create", "copy","copy-1");
	close("copy");
	close("copy-1");

	// Calculate the ith cell line
	selectWindow("Result of copy");
	rename("line"+i); //this is the ith line image

	// Calculate the cell layer
	run("BinaryReconstruct ", "mask=ref"+i+" seed=line"+i+" create white");
	rename("rec"+i); //this is the ith cell layer image
	close("line"+i);

	// Subtract the ith the cell layer
	imageCalculator("Subtract create", "ref"+i,"rec"+i);
	close("ref"+i);
	close("rec"+i);
	selectWindow("Result of ref"+i);
	rename("ref"+i); //this is the reference minus the ith cell layer

	// Calculate the ith cell layer on the reference image
	imageCalculator("Add create 32-bit", "ref"+i, "reference");
	//close("rec"+i);
	close("reference");
	selectWindow("Result of ref"+i);
	rename("reference"); // this is the new reference image

	// Stop condition is a black (empty) image
	selectWindow("ref"+i);
	getRawStatistics(nPixels, mean, min, max, std, histogram);
	if(mean == 0) {
		close("ref"+i);
		i ++;
		break;
	//	condition = "stop";
	}
	i ++; // ith layers

}

run("8-bit");

x = 255 / i;

run("Divide...", "value="+x);

run("glasbey_on_dark");
//run("8-bit Color");

title = replace(title, ".tif", "_layers.tif");

rename(title);