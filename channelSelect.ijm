var myMenu = newMenu("Color Channel Select Menu Tool", 
 	newArray(
 		"Red",
 		"Green",
 		"Blue"));

macro "Color Channel Select Menu Tool - Cf00F005fC0f0F505fC00fFa05f" {

	cmd = getArgument();

	if(cmd != "-"){
		if(cmd == "Red") {red();}
 		if(cmd == "Green") {green();}
 		if(cmd == "Blue") {blue();}
	}
}

function red(){
	Name = getTitle();

	run("Split Channels");

	selectWindow(Name + " (green)");
	close();

	selectWindow(Name + " (blue)");
	close();

	selectWindow(Name + " (red)");
	//saveAs("Tiff", Name + "_redChannel.tif");
	//close();

}

function green(){
	Name = getTitle();

	run("Split Channels");

	selectWindow(Name + " (red)");
	close();

	selectWindow(Name + " (blue)");
	close();

	selectWindow(Name + " (green)");
	//saveAs("Tiff", Name + "_greenChannel.tif");
	//close();

}

function blue(){
	Name = getTitle();

	run("Split Channels");

	selectWindow(Name + " (red)");
	close();

	selectWindow(Name + " (green)");
	close();

	selectWindow(Name + " (blue)");
	//saveAs("Tiff", Name + "_blueChannel.tif");
	//close();

}