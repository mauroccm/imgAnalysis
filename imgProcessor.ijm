/* Image processor function to increase signal to noise ratio (SNR)
 * of the processed image.
 *
 * INPUT: processed 8-bit binary image.
 * 
 * run the processing steps:
 * GB -> DS -> SB -> EC
*/

macro "imgProcessor" {
//function imgProcessor(){
	if(nImages == 0) {

		imagej = getDirectory("imagej");
		runMacro(imagej + "macros/ETT/warnings.ijm", 3);
		//warnings(3);		

	} else {

		run("Gaussian Blur...", "sigma=2"); 

		run("Despeckle"); // the median filter
		run("Subtract...", "value=10");
	
		run("Subtract Background...", "rolling=160 sliding");
		
		// this increase the noise, but improves the segmentation
		run("Enhance Contrast", "saturated=0.35 normalize");
		
	}

	//return 0;

}