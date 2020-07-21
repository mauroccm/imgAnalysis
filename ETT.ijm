/* Epithelial Topology Toolbox
 * 
 * Scripts in ImageJ's macro language for image analysis. R scripts are for 
 * data analysis and figures plots. These scripts were developed for the image 
 * analysis of the "Stochastic Model" project written by Mauro C. C. Morais at 
 * the Mathematical Modeling Group, Institute of Cancer of the State of São 
 * Paulo (ICESP), Department of Radiology and Oncology, Faculty of Medicine, 
 * University of São Paulo (FMUSP), São Paulo, Brazil. If you have any further 
 * questions, please see the README.md file and get in contact with us. 
 * 
 * Please cite our paper :)
 * Morais et al., Scientific Reports, 2017, 7(1):8026.
 * http://www.nature.com/articles/s41598-017-07553-6
 * 
 * These macro codes are free software; you can redistribute it and/or modify 
 * it under the terms of the GNU General Public License as published by the 
 * Free Software Foundation (GNU General Public License v3.0). It is 
 * distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY 
 * and LIABILITY; without even the implied warranty of fitness for a particular 
 * purpose. See the GNU General Public License for more details.
 * 
 * Mauro Morais, 2019-04-30
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
 		"adjMatrix2mesh", "getCellLayers", "getBorder",
 		"-",
 		"Local Orientation", "Local Orientation (Layers)",
 		"-",
 		"Jaccard Index",
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
 		//if(MCmd == "Channel Select") {run("Install...", "install=" + imagej + "macros/ETT/channelSelect.ijm");}
 		if(MCmd == "Channel Select") {runMacro("ETT/channelSelect.ijm");}
 		if(MCmd == "imgProcessor (v16)") {runMacro("ETT/imgProcessor.ijm");}//{imgProcessor();}
 		if(MCmd == "Count Cells") {runMacro("ETT/CountCells.ijm");}
 		if(MCmd == "cellPosition2areaSegment") {runMacro("ETT/cellPosition2areaSegment.ijm");}//{cellPosition2areaSegment();}
 		if(MCmd == "adjMatrix2mesh") {runMacro("ETT/adjMatrix2mesh.ijm");}//{adjMatrix2mesh();}
 		if(MCmd == "NFN_count") {runMacro("ETT/NFN_count.ijm");}//{NFN_count();}
 		if(MCmd == "adjMatrix (RCC)") {runMacro("ETT/adjMatrix.ijm");} //{adjMatrix();}
 		if(MCmd == "Local Orientation") {runMacro("ETT/localOrientation_.ijm");}
 		if(MCmd == "Local Orientation (Layers)") {runMacro("ETT/localOrientationLayer.ijm");}
 		if(MCmd == "Jaccard Index"){runMacro("ETT/jaccardIndex.ijm");}
 		if(MCmd == "getCellLayers") {runMacro("ETT/getCellLayers.ijm");}
 		if(MCmd == "About") {runMacro("ETT/about.ijm");} //{about();}
 		if(MCmd == "getBorder") {runMacro("ETT/getBorder.ijm");}
 	}
 }


