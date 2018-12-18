#!/bin/sh
#
# scrip to evaluate the computer performance over the counting
#
# Mauro Morais, 2018-07-04
INDIR=/home/mauromorais/R/imgAnalysis/scripts
OUTDIR=/home/mauromorais/R/imgAnalysis/results/2018-12-13/AutoCount/performance

# loop para o n de vezes que o script será executado
for runs in run01 run02 run03 run04 run05
do
	# loop para os métodos de threhsolding
	for model in Default Huang Intermodes IsoData IJ_IsoData Li MaxEntropy Mean MinError Minimum Moments Otsu Percentile RenyiEntropy Shanbhag Triangle Yen
	do
		/usr/bin/time -v --output=${OUTDIR}/time_results_${runs}_${model}.txt ${HOME}/Fiji.app/ImageJ-linux64 --headless -macro ${INDIR}/AutoCellCounter_Global_v127.ijm ${model} > ${OUTDIR}/performance_${model}.txt
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