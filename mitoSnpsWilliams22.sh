#!/bin/bash
##Script Variables
input_file=plate2.sample.list.cont.txt
#path1=/home/aubasw/DoctoralChp4/220114_A00405_0515_AH7W23DSX3/raw_reads_fq/
####plate1_11_103
#path2=/home/aubasw/DoctoralChp4/fastq_mouseHouse/MouseHouse_fastq_2022_Williams/220223_A00405_0533_BHJMJFDSX3/plate1/
####plate2_104_176
path3=/home/aubasw/DoctoralChp4/fastq_mouseHouse/MouseHouse_fastq_2022_Williams/220304_A00405_0537_BHLLTCDSX3/plate2/
####plate1_11_103
#path4=/home/aubasw/DoctoralChp4/fastq_mouseHouse/MouseHouse_fastq_2022_Williams/220304_A00405_0537_BHLLTCDSX3/plate1/
refGen2=GCF_000001635.27_GRCm39_genomic2.fasta.gz
pathRef=/home/aubasw/DoctoralChp4/ref_genome

##Setup Environment
module load fastqc/0.10.1
module load bwa
module load samtools/1.3.1
module load picard/1.79
module load gatk/4.1.4.0
module load bedtools
module load bcftools
###Commands

#ls -al $path3*.fastq.gz | awk -F '.' '{print $1}'| awk -F ' ' '{print $9}' | awk -F '/' '{print $9}' | awk -F '_' '{print $1 "_" $2 "_"$3}' | uniq | sort -n > plate2.sample.list.txt

if test -f "$input_file"; then
    while read F  ; do
        echo $F
        declare -a sample_list=($F)
        for sample in ${sample_list[@]}; do
            fastqc $path3${sample}_R1_001.fastq.gz
            fastqc $path3${sample}_R2_001.fastq.gz
            bwa mem -M -t 4 -R "@RG\tID:$sample\tSM:$sample\tPL:ILLUMINA" $pathRef/$refGen2 $path3${sample}_R1_001.fastq.gz $path3${sample}_R2_001.fastq.gz > ${sample}.paired.aln.sam
            samtools view -@ 4 -Sb ${sample}.paired.aln.sam > ${sample}.paired.aln.bam
            samtools sort -@ 4 -o ${sample}.paired.sorted.bam ${sample}.paired.aln.bam
            samtools index ${sample}.paired.sorted.bam
            java -Xmx4g -jar /opt/asn/apps/picard_1.79/picard-tools-1.79/ValidateSamFile.jar I=${sample}.paired.sorted.bam MODE=SUMMARY O=${sample}.paired.sorted.val.outputSummary
            java -Xmx4g -jar /opt/asn/apps/picard_1.79/picard-tools-1.79/MarkDuplicates.jar INPUT= ${sample}.paired.sorted.bam OUTPUT= ${sample}.paired.sorted.dup.bam METRICS_FILE= ${sample}.dup.metrics
            samtools index ${sample}.paired.sorted.dup.bam
            samtools view -b ${sample}.paired.sorted.dup.bam NC_005089.1 > ${sample}.paired.sorted.dup.mito.bam
            samtools index ${sample}.paired.sorted.dup.mito.bam
            samtools flagstat ${sample}.paired.sorted.dup.bam > ${sample}.paired.sorted.dup.flagstat
            samtools flagstat ${sample}.paired.sorted.dup.mito.bam > ${sample}.paired.sorted.dup.mito.flagstat
            java -Xmx4g -jar /opt/asn/apps/picard_1.79/picard-tools-1.79/ValidateSamFile.jar I=${sample}.paired.sorted.dup.bam MODE=SUMMARY O=${sample}.paired.sorted.dup.val.outputSummary
            java -Xmx4g -jar /opt/asn/apps/picard_1.79/picard-tools-1.79/ValidateSamFile.jar I=${sample}.paired.sorted.dup.mito.bam MODE=SUMMARY O=${sample}.paired.sorted.dup.mito.val.outputSummary
            gatk --java-options "-Xmx4g" Mutect2 -R $pathRef/$refGen2 --mitochondria-mode -I ${sample}.paired.sorted.dup.mito.bam -O ${sample}.paired.sorted.dup.mito.vcf.gz
            bedtools genomecov -ibam ${sample}.paired.sorted.dup.mito.bam -bga > ${sample}.paired.sorted.dup.mito.covdata.allPos.txt
            gatk --java-options "-Xmx4g" FilterMutectCalls -R $pathRef/$refGen2 -V ${sample}.paired.sorted.dup.mito.vcf.gz --autosomal-coverage 0 -O ${sample}.paired.sorted.dup.mito.filt.vcf.gz
            bcftools stats -F $pathRef/$refGen2 ${sample}.paired.sorted.dup.mito.filt.vcf.gz > ${sample}.snps_summary.txt
        done
    done <$input_file
else
    echo "$input_file not found. Aborting!!!!"
fi
exit
