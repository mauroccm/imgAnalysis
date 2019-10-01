/* The warning function */
//
// This function is called if something is missing from the user.

n = getArgument();
return warnings(n);
exit;

function warnings(n) {
	
	if (n == 0){ // If there's no table.

		msg = "Results table with cells center of mass required";
	
		exit(msg);
	}

	if (n == 1){ // If there's no image.

		msg = "Cell area projections image required.";
	
		exit(msg);

	}

	if (n == 2) { // If the image is not binary

		msg = "8-bit binary image (0 and 255) required.";

		exit(msg);

	}

	if (n == 3) { // If there is no image open

		msg = "8-bit image required.";

		exit(msg);

	}

	if (n == 4) { //If there is no RGB image open

		msg = "RGB image required.";

		exit(msg);

	}

	return 0;
}