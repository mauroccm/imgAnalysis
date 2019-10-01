# Image Analysis Scripts
Scripts in ImageJ's macro language for image analysis. R scripts are for data analysis and figures plots. These scripts were developed for the image analysis of the "Stochastic Model" project. Please cite the [paper](http://www.nature.com/articles/s41598-017-07553-6) :)

***
## AutoCount.ijm
Script to count labeled nuclei in fluorescent images captured with the blue	filter. Images are 8-bit format. This script was designed to be executed in the Fiji headless mode by calling the code from the command line. The segmentation models are called each execution with the `computerPerformance_v2.sh` script.

USAGE:
`<Fiji folder>/ImageJ-linux64 --headless -macro <macro folder>/<macro file>.ijm`

***
## computerPerformance.sh
Scrip to evaluate the computer performance when calling `AutoCount.ijm` macro script. The script calls the Fiji macro `AutoCounter.ijm` in _headless_ mode to perform the count using the `\bin\time`. (Original script version is `AutoCellCounter_Global_v127.ijm`)

***
## ETT.ijm
This macro toolset contains a set of ImageJ's macro functions designed to process 8-bit images (to make it more "segmentable" for thresholding models); to estimate the cell area projection (Voronoi tesselation); and to draw epithelial topology mesh over the cells (Region connection calculus).

### Functions

#### `cellPosition2areaSegment()`
get the nuclei postions (center of mass from the Results table) and build the Voronoi diagram (the cell area projection).

#### `NFN_count()`
get the cell area projections and count the number of nearest neigbor of each cell. Cells in the edge of the image are counted as first neighbors, but excluded in the image (See the markedNeighborArray). Other shape descriptors are also obtained to measure anisotropy of each cell area projection. This function was dadpted from [Neighbor Analysis](https://imagej.net/BioVoxxel_Toolbox#Neighbor_Analysis) of the Biovoxxel Toolbox.
	
#### `adjMatrix()`
get the cell area projections and calculates the RCC table. The RCC table is the adjacency table of each cell and it depends on the RCC8D plugin 
(https://blog.bham.ac.uk/intellimic/spatial-reasoning-with-imagej-using-the-region-connection-calculus/).

#### `adjMatrix2mesh()`
draws the edges of the cell network over the area segment image. Need some improvements...
	
#### `imgProcessor()`
apply processing filter to the image. Each version adds a different processing step. The current version is (v0.16). We used the increase of the signal-to-noise ratio ([SNR](https://en.wikipedia.org/wiki/Signal-to-noise_ratio)) between the raw and processed images as selection criterion for processing steps. 

### Instalation
1. Unzip the [ETT.zip](./ETT.zip) file in your `Fiji.app/macros/` directory. This should create a new `./ETT/` folder in your macros directory.
2. Start Fiji.
3. Go to _Plugins > Macros > Install..._ and select the `ETT.ijm` file in your `toolsets` folder.

### DISCLAIMER
Original content from this work may be used under the terms of the Creative Commons Attribution 3.0 licence (http://creativecommons.org/licenses/by/3.0). Any further distribution of this work must maintain attribution to the author(s).

### WARRANTIES
None. Use at your own risk.
