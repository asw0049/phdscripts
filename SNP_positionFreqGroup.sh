#!/bin/bash
###This script reports frequenct of mutations at certain positions by group.
##Dependencies: groupType3.awk, SNV_tstv_rosID.awk
tissue=muscle


cat ${tissue}MTsnps.txt | awk -F";" '{print $8}'| sed 's/_/;/g'| awk -F";" '{print ";"$1}'> ${tissue}_SampleTags.txt
paste -d'\0' ${tissue}MTsnps.txt ${tissue}_SampleTags.txt> ${tissue}MTsnps2.txt
cat ${tissue}MTsnps2.txt | awk -F";" -f groupType3.awk > ${tissue}MTsnps_labelled.txt
grep -w "Middle" ${tissue}MTsnps_labelled.txt | awk -F";" '{print $2";"$3";"$7";"$11}' | sort -n| uniq -c| sort -r | awk -F" " '{print $1";"$2}'| awk -F";" -f SNV_tstv_rosID.awk >${tissue}.MTsnpsPos.middle.txt
grep -w "Aged" ${tissue}MTsnps_labelled.txt | awk -F";" '{print $2";"$3";"$7";"$11}' | sort -n| uniq -c| sort -r | awk -F" " '{print $1";"$2}'| awk -F";" -f SNV_tstv_rosID.awk >${tissue}.MTsnpsPos.aged.txt
grep -w "NR" ${tissue}MTsnps_labelled.txt | awk -F";" '{print $2";"$3";"$7";"$11}' | sort -n| uniq -c| sort -r | awk -F" " '{print $1";"$2}'| awk -F";" -f SNV_tstv_rosID.awk > ${tissue}.MTsnpsPos.nr.txt
grep -w "R" ${tissue}MTsnps_labelled.txt | awk -F";" '{print $2";"$3";"$7";"$11}' | sort -n| uniq -c| sort -r | awk -F" " '{print $1";"$2}'| awk -F";" -f SNV_tstv_rosID.awk > ${tissue}.MTsnpsPos.r.txt

exit


