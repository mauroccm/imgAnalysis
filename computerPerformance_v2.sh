#!/bin/sh
#
# Scrip to evaluate the computer performance when calling. AutoCount.ijm macro
# script.
# The script calls the Fiji macro AutoCounter.ijm to perform the count.
# (Original script version is AutoCellCounter_Global_v127.ijm)
#
# Mauro Morais, 2019-01-30

# Set the input directory wit the script
INDIR=/home/mauromorais/R/imgAnalysis/scripts

# Set the output directory with the time performance analysis
OUTDIR=/home/mauromorais/R/imgAnalysis/results/2018-08-09_autoCount_analysis/AutoCount_fromCleanV15/performance
# OUTDIR=/home/mauromorais/R/imgAnalysis/results/2019-05-13_Exp27_autoCounts/cleanV14/performance

# Loop the number of executions
for runs in run01 run02 run03 run04 run05
do
	# loop for each 17 threhsolding models
	for model in Default Huang Intermodes IsoData IJ_IsoData Li MaxEntropy Mean MinError Minimum Moments Otsu Percentile RenyiEntropy Shanbhag Triangle Yen
	do
		/usr/bin/time -v --output=${OUTDIR}/time_results_${runs}_${model}.txt ${HOME}/Fiji.app/ImageJ-linux64 --headless -macro ${INDIR}/AutoCounter.ijm ${model} > ${OUTDIR}/performance_${model}.txt
		echo "-----------"
		echo "$runs $model DONE!"
		echo "-----------"
	done
	
	echo "--------"
	echo "$runs DONE!"
	echo "--------"
done
	
echo "-------"
echo "Finish!"
echo "-------"