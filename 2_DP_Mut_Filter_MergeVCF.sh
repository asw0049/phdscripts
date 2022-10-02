#!/bin/bash
##Script Variables
input_file=brain.sample.list.txt
#path1=/home/aubasw/DoctoralChp4/220114_A00405_0515_AH7W23DSX3/raw_reads_fq/
####plate1_11_103
#path2=/home/aubasw/DoctoralChp4/fastq_mouseHouse/MouseHouse_fastq_2022_Williams/220223_A00405_0533_BHJMJFDSX3/plate1/
####plate2_104_176
#path3=/home/aubasw/DoctoralChp4/fastq_mouseHouse/MouseHouse_fastq_2022_Williams/220304_A00405_0537_BHLLTCDSX3/plate2/
####plate1_11_103
#path4=/home/aubasw/DoctoralChp4/fastq_mouseHouse/MouseHouse_fastq_2022_Williams/220304_A00405_0537_BHLLTCDSX3/plate1/
#refGen2=GCF_000001635.27_GRCm39_genomic2.fasta.gz
#pathRef=/home/aubasw/DoctoralChp4/ref_genome
#57_S42_L003.paired.sorted.dup.mito.filt.vcf.gz

##Setup Environment
###Commands
ls -al *.vcf.gz | awk -F '.' '{print $1}'| awk -F ' ' '{print $9}'| awk -F '_' '{print $1 "_" $2 "_"$3}' | uniq | sort -n> brain.sample.list.txt

if test -f "$input_file"; then
    while read F  ; do
        echo $F
        declare -a sample_list=($F)
        for sample in ${sample_list[@]}; do
             zcat ${sample}.paired.sorted.dup.mito.filt.vcf.gz | grep '^NC_005089.1'|awk -F"\t" '{print $1";"$2";"$4";"$5";"$8}' | awk -F";" '{print $1"\t"$2"\t"$3"\t"$4"\t"$6"\t"$(NF)}' | sed 's/DP=//g' | sed 's/TLOD=//g' | awk -F"\t" '{if($5>10)print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6}'> ${sample}.snpSum.txt 
             awk -f mtgeneList.awk ${sample}.snpSum.txt | sed "s/SampleName/${sample}/g">${sample}.snpGenType.txt
             cat ${sample}.snpGenType.txt | awk -F';' '{print $1";"$2";"$3"-"$4";"$5";"$6";"$7";"$8";"$9}'| gawk -F";" -f tstvList.awk > ${sample}.snpTypesID.txt
       done
    done <$input_file
else
    echo "$input_file not found. Aborting!!!!"
fi
exit
