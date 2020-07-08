// Chek if the image is open
if(nImages == 0) {
	runMacro("ETT/warnings.ijm", 4);
	exit;
}

// Check if the image is RGB
if(bitDepth() != 24) {
	runMacro("ETT/warnings.ijm", 4);
	exit;
}

// Dialog box
items = newArray("Red", "Green", "Blue");

Dialog.create("Channel Select");
Dialog.addChoice("Channel?", items, "Blue");
Dialog.show();

choice = Dialog.getChoice();

// Options
if(choice != "-"){
	if(choice == "Red") {red();}
	if(choice == "Green") {green();}
	if(choice == "Blue") {blue();}
}

// Select the red channel
function red(){
	Name = getTitle();
	run("Split Channels");
	close(Name + " (green)");
	close(Name + " (blue)");
	selectWindow(Name + " (red)");
}

// Select the green channel
function green(){
	Name = getTitle();
	run("Split Channels");
	close(Name + " (red)");
	close(Name + " (blue)");
	selectWindow(Name + " (green)");
}

// Select the blue channel
function blue(){
	Name = getTitle();
	run("Split Channels");
	close(Name + " (red)");
	close(Name + " (green)");
	selectWindow(Name + " (blue)");
}