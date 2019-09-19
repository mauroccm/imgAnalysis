# README Image Analysis Scripts
Scripts in ImageJ's macro language for image analysis. R scripts are for data analysis and figures plots. These scripts were developed for the image analysis of the "Stochastic Model" project. Please cite the [paper](http://www.nature.com/articles/s41598-017-07553-6) :)

***
### AutoCount.ijm
Script to count labeled nuclei in fluorescent images captured with the blue	filter. Images are 8-bit format. This script was designed to be executed in the Fiji headless mode by calling the code from the command line. The segmentation models are called each execution with the `computerPerformance_v2.sh` script.

USAGE:
`<Fiji folder>/ImageJ-linux64 --headless -macro <macro folder>/<macro file>.ijm`

***
### computerPerformance.sh
Scrip to evaluate the computer performance when calling `AutoCount.ijm` macro script. The script calls the Fiji macro `AutoCounter.ijm` to perform the count. (Original script version is `AutoCellCounter_Global_v127.ijm`)

***
### EpithelialTopologyToolbox.ijm
This macro toolset contains a set of ImageJ's macro functions designed to process 8-bit images (to make it more "segmentable" for thresholding models); to estimate the cell area projection (Voronoi tesselation); and to draw epithelial topology mesh over the cells (Region connection calculus).

#### Functions
`cellPosition2areaSegment()`: get the nuclei postions (center of mass from the Results table) and build the Voronoi diagram (the cell area projection).
		
`NFN_count()`: get the cell area projections and count the number of nearest neigbor of each cell. Cells in the edge of the image are counted as first neighbors, but excluded in the image (See the markedNeighborArray). Other shape descrioptors are also obtained to measure anisotropy of each cell area projection.
	
`adjMatrix()`: get the cell area projections and calculates the RCC table. The RCC table is the adjacency table of each cell and it depends on the RCC8D plugin 
(https://blog.bham.ac.uk/intellimic/spatial-reasoning-with-imagej-using-the-region-connection-calculus/).

`adjMatrix2mesh()`: draws the edges of the cell network over the area segment image. Need some improvements...
	
`imgProcessing_v??()`: apply processing filter to the image. Each version adds a different processing step. v10, only selects the blue channel. v11, subtract background. v12, enhance contrast. v13, apply Gaussian filter with sigma=2; v14, subtract the background with radius=160; v16 was built using the SNR criteria; v17 is the three major processing steps. These functions will be deprected in the future and only the imgProcessor() will be used.

#### Instalation
1. Place the `EpithelialTopologyToolbox.ijm` file in your `Fiji.app/macros/toosets/` folder.
2. Start Fiji.
3. Go to _Plugins > Macros > Install..._ and select the `EpithelialTopologyToolbox.ijm` file in your `toolsets` folder. Or click on the `>>` icon and select the toolset.

**DISCLAIMER**: Original content from this work may be used under the terms of the Creative Commons Attribution 3.0 licence (http://creativecommons.org/licenses/by/3.0). Any further distribution of this work must maintain attribution to the author(s).

**WARRANTIES**: None. Use at your own risk.
