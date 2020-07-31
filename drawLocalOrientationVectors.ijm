/*
 * Draw orientation vector lines over cell projection areas.
 * 
 * INPUT: Results table with vectors coordinates and respective
 * cell area projection image.
 * OUTPUT: Local orientation vectors over the images.
 * 
 * Mauro Morais, 2020-07-03
 */

macro "drawLocalOrientationVectors" {

	//Table.open(filePath);
	x1 = Table.getColumn("X1");
	y1 = Table.getColumn("Y1");
	x2 = Table.getColumn("X2");
	y2 = Table.getColumn("Y2");
	
	setColor("red");
	setLineWidth(4);
	
	for (i = 0; i < x1.length; i++) {
	
		drawLine(x1[i], y1[i], x2[i], y2[i]);
		
	}
}