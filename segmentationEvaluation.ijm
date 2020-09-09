/*
 * Threshold Assessment
 *
 * INPUT: Two binary images. Ground truth and segmented with white objects in black
 * backgound.
 * OUTPUT: Sensibility, specifity and accuracy values of the segmentation.
 *
 * https://en.wikipedia.org/wiki/Receiver_operating_characteristic
 *
 * Mauro Morais, 2020-03-17
*/

// Get the ground truth (GT) and segmented (S) images with dialog parameters
items = getList("image.titles");

Dialog.create("Threshold Assessment");
	Dialog.addMessage("Compare two binary images");
	Dialog.addChoice("Ground truth:", items);
	Dialog.addChoice("Segmented:", items);
	Dialog.addHelp("https://github.com/mauroccm/imgAnalysis");
Dialog.show();

GT = Dialog.getChoice();
S = Dialog.getChoice();;

// Check if images are binary
if(!is("binary")) {exit("Please, input binary images.");}

// Calculate the contigency table values (TP, FP, FN, TN) from the images

// TP = GT AND Segmented
imageCalculator("AND create", GT, S);
//selectWindow("Result of " + GT);
rename("TP");
getStatistics(area, mean, min, max, std, histogram);
TP = histogram[255];

// FP = Segmented - TP
imageCalculator("Subtract create", S, "TP");
//selectWindow("Result of " + S);
rename("FP");
getStatistics(area, mean, min, max, std, histogram);
FP = histogram[255];

// FN = GT - TP
imageCalculator("Subtract create", GT,"TP");
//selectWindow("Result of " + GT);
rename("FN");
getStatistics(area, mean, min, max, std, histogram);
FN = histogram[255];

// TN = invert(GT or S)
imageCalculator("OR create", GT, S);
//selectWindow("Result of " + GT);
run("Invert");
rename("TN");
getStatistics(area, mean, min, max, std, histogram);
TN = histogram[255];

// Calculate the Sensitivity (Recall), Specificity, Precision, Accuracy and 
// F1 score (Dice Coeff.) from the results table

Sensitivity = TP / (TP + FN);

Specificity = TN / (TN + FP);

Precision = TP / (TP + FP);

Accuracy = (TP + TN) / (TP + TN + FP + FN);

F1 = 2 * (Precision * Sensitivity) / (Precision + Sensitivity);

FDR = FP / (FP + TP);

FNR = FN / (FN + TP);

JI = TP / (area - TN); // Jaccard Index;

//close("TP"); close("FP"); close("FN"); close("TN");

// Print the output
print("------------------------------------");
print("Ground truth image: " + GT);
print("Segmented image: " + S);
print("\n");
print("Sensitivity: " + Sensitivity);
print("Specificity: " + Specificity);
print("Precision: " + Precision);
print("Accuracy: " + Accuracy);
print("False Discovery Rate: " + FDR);
print("False Negative Rate: " + FNR);
print("F1 score: " + F1);
print("IoU: " + JI);
print("------------------------------------");