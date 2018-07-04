// imgCleaner.ijm v.1.2
// Script para selecionar canal azul e "limpar"
// 2017-08-13, Mauro Morais

in = getDirectory("Input files");
out = getDirectory("Output files");
list = getFileList(in);	//get the file list

setBatchMode(true);	//faster
for (i=0; i<list.length; i++) {
	open(in+list[i]);
	nome = File.nameWithoutExtension;
	run("Split Channels");
	selectWindow(list[i]+" (green)");
	close();
	selectWindow(list[i]+" (red)");
	close();
	selectWindow(list[i]+" (blue)");
	run("Enhance Contrast", "saturated=0.35");
	run("Apply LUT");
	run("Subtract Background...", "rolling=50 sliding");
	run("Despeckle");
	run("Subtract...", "value=10");
	saveAs("Tiff", out+nome+".tif");
	close();
}
print("DONE!");
