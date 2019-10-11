/* 
 * Jaccard index between two binary images. The Jaccard index is the 
 * Intersection Area / Union Area
 * 
 * INPUT: Two binary images.
 * OUTPUT: The Jaccard index in the "Log" window.
 * 
 * https://en.wikipedia.org/wiki/Jaccard_index
 * 
 * Mauro Morais, 2019-05-03
 * Acknowledgements to Robert Haase, Myers lab, MPICBG;
 * for providing the code.
 */

macro "Jaccard Index" {

	if(nImages < 2 ) {
	
		msg = "Need two binary images open.";
	
		exit(msg);
	}

	items = getList("image.titles");

	// Need to check if both images are binary.

	Dialog.create("Estimate Jaccard index between two binary images");
	Dialog.addChoice("Image A:", items);
	Dialog.addChoice("Image B:", items);
	Dialog.show();

	imgA = Dialog.getChoice();
	imgB = Dialog.getChoice();

	/* the 'mean' is included in the measurements to check the segments area */
	run("Set Measurements...", "area mean redirect=None decimal=4");

	// determine intersection area
	imageCalculator("AND create", imgA, imgB);
	rename("Intersection");
	run("Create Selection");
	run("Make Inverse");
	run("Measure");
	areaIntersection = getResult("Area", nResults - 1);

	// determine union area
	imageCalculator("OR create", imgA, imgB);
	rename("Union");
	run("Create Selection");
	run("Make Inverse");
	run("Measure");
	areaUnion = getResult("Area", nResults - 1);

	/* Return Jaccard index */
	jac = areaIntersection / areaUnion;

	setResult("Region", 0, "Intersection");
	setResult("Region", 1, "Union");
	updateResults();

	//print("\\Clear");
	print("Jaccard Index: " + jac);
}