// imgCleaner.ijm v.1.1
// Script para selecionar canal azul
// 2017-03-06, Mauro Morais

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
	saveAs("Tiff", out+nome+".tif");
	run("Subtract Background...", "rolling=50 sliding")
	close();
}
print("DONE!");
