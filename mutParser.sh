#!/bin/bash
##Script Variables
input_file=muscle.sample.list.txt
snp_file=muscleMTsnps.txt
tissue=muscle
##Setup Environment

###Commands

cat $snp_file | awk -F";" '{print $8}'|sort|uniq > ${tissue}.sample.list.txt

if test -f "$input_file"; then
    while read F  ; do
        echo $F
        declare -a sample_list=($F)
        for sample in ${sample_list[@]}; do
             cat $snp_file | grep ${sample} | grep "Transition" | awk -F";" '{if ($9 == "Transition" ) { TScount += 1; }} END { print $8";"$9";" TScount}' >> ${tissue}_mut_Count_individual.txt
             cat $snp_file | grep ${sample} | grep "Transversion" | awk -F";" '{if ($9 == "Transversion" ) { TVcount += 1; }} END { print $8";"$9";" TVcount}' >> ${tissue}_mut_Count_individual.txt
             cat $snp_file | grep ${sample} | grep "Insertion" | awk -F";" '{if ($9 == "Insertion" ) { Incount += 1; }} END { print $8";"$9";" Incount}' >> ${tissue}_mut_Count_individual.txt
             cat $snp_file | grep ${sample} | grep "Deletion" | awk -F";" '{if ($9 == "Deletion" ) { Delcount += 1; }} END { print $8";"$9";" Delcount}' >> ${tissue}_mut_Count_individual.txt
       done
    done <$input_file
    cat ${tissue}_mut_Count_individual.txt | grep -v ';;' | sed 's/_/;/g' | awk -F";" -f groupType.awk > ${tissue}_mut_Count_individual2.txt
else
    echo "$input_file not found. Aborting!!!!"
fi
exit

