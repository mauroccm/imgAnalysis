
newImage("Calibration_Bar", "8-bit", 30, 360, 1);
getDimensions(width, height, channels, slices, frames);
step=0;
stepsize=30;

for(c=0; c<12; c++) {
	makeRectangle(0, step, 30, step+stepsize);
	setForegroundColor(c+1, c+1, c+1);
	run("Fill");
	step=step+stepsize;
}

run("Select None");
run("glasbey");
run("RGB Color");
setForegroundColor(255, 255, 255);
setBackgroundColor(0, 0, 0);
/*
doWand(35, 35);
run("Fill");
run("Select None");
*/
setJustification("center");
setFont("SansSerif", 21);
drawString("1", 15, 30);
drawString("6", 15, 180);
drawString("12", 15, 360);
