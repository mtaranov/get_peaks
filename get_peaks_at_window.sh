#!/bin/bash

#module load bedtools/2.21.0

thres=5 # threshold on -log10pvalue
mean_or_max=max # take mean or max of -log10pvalue in each REsite

dataDIR=/mnt/lab_data/kundaje/projects/skin/data/peaks/
PROJDIR=/users/mtaranov/get_peaks/peaks_at_window
datatypes=(tf histone atac)
#tf=(CTCF LSD1 PolII TP63)
tf=(CTCF PolII TP63) # there is no LSD1 for d6
histone=(H3K27ac H3K27me3 H3K4me1 H3K4me3 H3K9ac)
atac=(atac)

for day in d0 d3 d6; do
for contacts in PE PP PP_PE;do

for set in train valid test; do
window_coor=/users/mtaranov/datasets_3d/dist_matched_${contacts}/motifs/${contacts}_coor_btw_nodes_${set}.bed

output_folder=$PROJDIR/${contacts}_output_thres${thres}_${mean_or_max}
temp_folder=$output_folder/temp

#window_coor_sorted=$output_folder/temp/sorted_${contacts}_coor_btw_nodes_${set}.bed
#cat $window_coor | sort > $window_coor_sorted

mkdir -p $output_folder $temp_folder

for (( i=0; i<${#datatypes[@]}; i++ )); do
       datatype_all=${datatypes[$i]}
       if [[ $datatype_all == "tf" ]]; then
           sub_folder=""
       else
           sub_folder="narrow"
        fi
       
       eval datatype=\( \${${datatype_all}[@]} \) # iterate over a array using inderect reference
       for (( j=0; j<${#datatype[@]}; j++ )); do
           data=${datatype[$j]}
 
        if [[ $datatype_all == "atac" ]]; then
        #narrowPeakFile=$dataDIR/$datatype_all/$sub_folder/khavari_hg19_primarykeratinocyte_all_ATAC_merged_r1.bed_p1e-2_peaks.narrowPeak
        narrowPeakFile=$dataDIR/$datatype_all/$sub_folder/khavari_hg19_primarykeratinocyte_${day}_ATAC_merged_r1.bed_p1e-2_peaks.narrowPeak
        elif [[ $data == "H3K27ac" ]]; then       
        #narrowPeakFile=$dataDIR/$datatype_all/$sub_folder/khavari_hg19_primarykeratinocyte_d0_${data}_chipseq_r2_p1e-2_peaks.narrowPeak # rep 2
        narrowPeakFile=$dataDIR/$datatype_all/$sub_folder/khavari_hg19_primarykeratinocyte_${day}_${data}_chipseq_r2_p1e-2_peaks.narrowPeak # rep 2
        else
        #narrowPeakFile=$dataDIR/$datatype_all/$sub_folder/khavari_hg19_primarykeratinocyte_d0_${data}_chipseq_r1_p1e-2_peaks.narrowPeak
        narrowPeakFile=$dataDIR/$datatype_all/$sub_folder/khavari_hg19_primarykeratinocyte_${day}_${data}_chipseq_r1_p1e-2_peaks.narrowPeak
        fi 
        temp=$temp_folder/${day}_temp_${data}
        output=$output_folder/${day}_${data}_${set}
        output2=$output_folder/${day}_${data}_${set}_2
        output3=$output_folder/${day}_${data}_${set}_3

 
cat $narrowPeakFile | awk '{if ($8 > thres) print $1, $2, $3, $8}' thres=$thres | /usr/bin/perl -p -e 's/ /\t/g' > $temp

if [[ $mean_or_max == "mean" ]]; then
bedtools intersect -wao -a $window_coor -b $temp |awk '{if ($5 != -1) print $1, $2, $3, $7; else print $1, $2, $3, '0'}' | sort -k 1,1 -k 2,2 -k 3,3| awk 'END{printf(" ")}1'| gawk '($1==key1 && $2==key2 && $3==key3) { sum+=$4; n++} ($1 != key1 || $2 != key2 || $3 != key3) {if (NR>1){print key1, key2, key3, sum/n} key1=$1; key2=$2; key3=$3; sum=$4; n=1}' >  $output

elif [[ $mean_or_max == "max" ]]; then
bedtools intersect -wao -a $window_coor -b $temp |awk '{if ($5 != -1) print $1, $2, $3, $7; else print $1, $2, $3, '0'}' | sort -k 1,1 -k 2,2 -k 3,3| awk 'END{printf(" ")}1' | gawk '($1==key1 && $2==key2 && $3==key3) { if(($4)>max)  max=($4)} ($1 != key1 || $2 != key2 || $3 != key3) {if (NR>1){print key1, key2, key3, max} key1=$1; key2=$2; key3=$3; max=$4}' >  $output
fi

done
done
done
done
done
#rm  -r $temp_folder
exit
