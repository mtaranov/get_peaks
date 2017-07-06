#!/bin/bash

PROJDIR=/users/mtaranov/get_peaks/peaks_at_window

thres=5
mean_or_max=max

for day in d0 d3 d6; do

for contacts in PE PP PP_PE; do
dataDIR=$PROJDIR/${contacts}_output_thres${thres}_${mean_or_max}/

numpy_folder=$PROJDIR/np
numpy_subfolder=$numpy_folder/${contacts}_thres${thres}_${mean_or_max}
mkdir -p $numpy_folder $numpy_subfolder

for set in train valid test; do
numpy_name=$numpy_subfolder/${day}_X_${set}.npy
/users/mtaranov/local/anaconda2/bin/python convert_to_numpy.py  $numpy_name $dataDIR${day}_ $set

done
done
done
exit
