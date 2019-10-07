/*	Epithelial Topology Toolbox
 *
 *	Functions: 
 * 		cellPosition2areaSegment(): get the nuclei postions (center of mass from 
 *		the Results table) and build the Voronoi diagram (the cell area 
 *		projection).
 * 		
 *		NFN_count(): get the cell area projections and count the number of
 *		nearest neigbor of each cell. Cells in the edge of the image are 
 *		counted as first neighbors, but excluded in the image (See the 
 *		markedNeighborArray). Other shape descrioptors are also obtained to 
 *		measure anisotropy of each cell area projection.
 *		
 *		adjMatrix(): get the cell area projections and calculates the RCC table.
 *		The RCC table is the adjacency table of each cell and it depends on the
 *		RCC8D plugin 
 *		(https://blog.bham.ac.uk/intellimic/spatial-reasoning-with-imagej-using-the-region-connection-calculus/).
 *
 *		adjMatrix2mesh(): draws the edges of the cell network over the area 
 *		segment	image. Need some improvements...
 *		
 *		imgProcessing_v??(): apply processing filter to the image. Each version
 *		adds a different processing step. v10, only selects the blue channel.
 *		v11, subtract background. v12, enhance contrast. v13, apply Gaussian
 *		filter with sigma=2; v14, subtract the background with radius=160;
 *		v16 was built using the SNR criteria; v17 is the three major processing
 *		steps. These functions will be deprected in the future and only the 
 *		imgProcessor() will be used.
 *
 * Mauro Morais, 2019-04-30
 *
 * DISCLAIMER: Original content from this work may be used under the terms of 
 * the Creative Commons Attribution 3.0 licence 
 * (http://creativecommons.org/licenses/by/3.0). Any further distribution of 
 * this work must maintain attribution to the author(s).
 *
 * WARRANTIES: None. Use at your own risk.
 * 
 */

 var myMenu = newMenu("Epithelial Topology Menu Tool", 
 	newArray(
 		//"imgProcessing_v10", "imgProcessing_v11", "imgProcessing_v12", 
 		//"imgProcessing_v13", "imgProcessing_v14", "imgProcessing_v16", 
 		//"imgProcessing_v17", 
 		"-",
 		"Channel Select",
 		"imgProcessor (v16)",
 		"Count Cells",
 		"-", 
 		"cellPosition2areaSegment",	"NFN_count", "adjMatrix (RCC)",	
 		"adjMatrix2mesh", 
 		"-", 
 		"About"
 	));

 macro "Epithelial Topology Menu Tool - C606F00ffCff0T1b08ET6b08TTbb08T" {

 	imagej = getDirectory("imagej");

 	MCmd = getArgument();

 	if(MCmd != "-") {
 		//if(MCmd == "imgProcessing_v10") {imgProcessing_v10();}
 		//if(MCmd == "imgProcessing_v11") {imgProcessing_v11();}
 		//if(MCmd == "imgProcessing_v12") {imgProcessing_v12();}
 		//if(MCmd == "imgProcessing_v13") {imgProcessing_v13();}
 		//if(MCmd == "imgProcessing_v14") {imgProcessing_v14();}
 		//if(MCmd == "imgProcessing_v16") {imgProcessing_v16();}
 		//if(MCmd == "imgProcessing_v17") {imgProcessing_v17();}
 		if(MCmd == "Channel Select") {run("Install...", "install=" + imagej + "macros/ETT/channelSelect.ijm");}
 		if(MCmd == "imgProcessor (v16)") {runMacro("ETT/imgProcessor.ijm");}//{imgProcessor();}
 		if(MCmd == "Count Cells") {runMacro("ETT/CountCells.ijm");}
 		if(MCmd == "cellPosition2areaSegment") {runMacro("ETT/cellPosition2areaSegment.ijm");}//{cellPosition2areaSegment();}
 		if(MCmd == "adjMatrix2mesh") {runMacro("ETT/adjMatrix2mesh.ijm");}//{adjMatrix2mesh();}
 		if(MCmd == "NFN_count") {runMacro("ETT/NFN_count.ijm");}//{NFN_count();}
 		if(MCmd == "adjMatrix (RCC)") {runMacro("ETT/adjMatrix.ijm");} //{adjMatrix();}
 		if(MCmd == "About") {runMacro("ETT/about.ijm");} //{about();}
 	}
 }


