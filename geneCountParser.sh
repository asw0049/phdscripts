#!/bin/bash
##Script Variables
input_file=muscle.sample.list.txt
snp_file=muscleMTsnps.txt
gene_file=muscle.gene.list.txt
tissue=muscle
#####Setup Environment
#Dependency Scripts
##groupType2.awk
###Commands

#cat $snp_file | awk -F";" '{print $8}'|sort|uniq > ${tissue}.sample.list.txt

cat $snp_file | awk -F";" '{print $7}'|sort|uniq > ${tissue}.gene.list.txt

if test -f "$input_file"; then
    while read F  ; do
        echo $F
        declare -a sample_list=($F)
        for sample in ${sample_list[@]}; do
             cat $snp_file | grep ${sample}> ${sample}_${tissue}Muts.txt
             while read A ; do
                 echo $A
                 declare -a gene_list=($A)
                 for gene in ${gene_list[@]}; do
                     cat ${sample}_${tissue}Muts.txt| grep $gene | awk -F";" -v g=$gene '{if ($7 == g ) { count += 1; }} END { print $7";"$8";" count}' > ${sample}_${gene}.mut.txt
                 done
             done <$gene_file
        done
    done <$input_file
    cat *.mut.txt | grep -v ";;" | sed 's/_/;/g'| awk -F";" -f groupType2.awk >${tissue}GeneMutCount.txt
    rm *.mut.txt
else
    echo "$input_file not found. Aborting!!!!"
fi
exit

