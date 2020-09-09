// About this Epithelial Topology Toolbox
//

macro "about" {
//function about() {
	
	text = ""
		+"Epithelial Topology Toolbox\n"
		+" \n"
		+"This macro toolset contains a set of ImageJ's macro functions designed to: \n"
		+" \n"
		+"    1. process 8-bit images (to make it more \"segmentable\" for thresholding models);\n"
		+"    2. estimate the cell area projection (Voronoi tesselation);\n"
		+"    3. draw epithelial topology mesh over the cells based on adjacency matrix (Region connection calculus);\n"
		+" 	  4. estimate the cell layer with respect to the melanoma distance;\n"
		+"    5. calculate the local cell orientation angle with respect to its first and second neighbors;\n"
		+"    6. calculate image segmentation metrics.\n"
		+" \n"
		+"For the most recent version and instructions please visit the GitHub page."
		+" \n"
		+" \n"
		+"LICENSE: These macro codes are free software; you can redistribute it and/or modify it under the terms of\n"
		+"the GNU General Public License as published by the Free Software Foundation (GNU General Public License v3.0).\n"
		+"It is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY and LIABILITY; without even\n"
		+"the implied warranty of fitness for a particular purpose. See the GNU General Public License for more details.\n";

	url = "https://github.com/mauroccm/imgAnalysis";

	Dialog.create("About");
		Dialog.addMessage(text);
		Dialog.addMessage(url);
		Dialog.addMessage("Created by Mauro Morais, 2019-04-30.");
		Dialog.addHelp(url);
	Dialog.show();

	//return 0;
}