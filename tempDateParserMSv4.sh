#!/bin/bash

#This script will be used to analyze temperature data taken from animals housed in semi-natural enclosures. Note the script requires
#a csv file and will generate a summary csv of average core body temperatures taken Sept 2019-July 2020. Several daily files will also
#be generated. Those can be referenced if values generated are out of range or can be discarded to save space.
#
#Below arrays were used to generate month variables consisting of dates to call daily scanned temperatures.
##########Make Sample List Array##
declare -a sept=("9_1_2019" "9_2_2019" "9_3_2019" "9_4_2019" "9_5_2019" "9_6_2019" "9_7_2019" "9_8_2019" "9_9_2019" "9_10_2019" "9_11_2019" "9_12_2019" "9_13_2019" "9_14_2019" "9_15_2019" "9_16_2019" "9_17_2019" "9_18_2019" "9_19_2019" "9_20_2019" "9_21_2019" "9_22_2019" "9_23_2019" "9_24_2019" "9_25_2019" "9_26_2019" "9_27_2019" "9_28_2019" "9_29_2019" "9_30_2019" "9_31_2019")

declare -a oct=("10_1_2019" "10_2_2019" "10_3_2019" "10_4_2019" "10_5_2019" "10_6_2019" "10_7_2019" "10_8_2019" "10_9_2019" "10_10_2019" "10_11_2019" "10_12_2019" "10_13_2019" "10_14_2019" "10_15_2019" "10_16_2019" "10_17_2019" "10_18_2019" "10_19_2019" "10_20_2019" "10_21_2019" "10_22_2019" "10_23_2019" "10_24_2019" "10_25_2019" "10_26_2019" "10_27_2019" "10_28_2019" "10_29_2019" "10_30_2019" "10_31_2019")

declare -a nov=("11_1_2019" "11_2_2019" "11_3_2019" "11_4_2019" "11_5_2019" "11_6_2019" "11_7_2019" "11_8_2019" "11_9_2019" "11_10_2019" "11_11_2019" "11_12_2019" "11_13_2019" "11_14_2019" "11_15_2019" "11_16_2019" "11_17_2019" "11_18_2019" "11_19_2019" "11_20_2019" "11_21_2019" "11_22_2019" "11_23_2019" "11_24_2019" "11_25_2019" "11_26_2019" "11_27_2019" "11_28_2019" "11_29_2019" "11_30_2019" "11_31_2019")

declare -a dec=("12_1_2019" "12_2_2019" "12_3_2019" "12_4_2019" "12_5_2019" "12_6_2019" "12_7_2019" "12_8_2019" "12_9_2019" "12_10_2019" "12_11_2019" "12_12_2019" "12_13_2019" "12_14_2019" "12_15_2019" "12_16_2019" "12_17_2019" "12_18_2019" "12_19_2019" "12_20_2019" "12_21_2019" "12_22_2019" "12_23_2019" "12_24_2019" "12_25_2019" "12_26_2019" "12_27_2019" "12_28_2019" "12_29_2019" "12_30_2019" "12_31_2019")

declare -a jan=("1_1_2020" "1_2_2020" "1_3_2020" "1_4_2020" "1_5_2020" "1_6_2020" "1_7_2020" "1_8_2020" "1_9_2020" "1_10_2020" "1_11_2020" "1_12_2020" "1_13_2020" "1_14_2020" "1_15_2020" "1_16_2020" "1_17_2020" "1_18_2020" "1_19_2020" "1_20_2020" "1_21_2020" "1_22_2020" "1_23_2020" "1_24_2020" "1_25_2020" "1_26_2020" "1_27_2020" "1_28_2020" "1_29_2020" "1_30_2020" "1_31_2020")

declare -a feb=("2_1_2020" "2_2_2020" "2_3_2020" "2_4_2020" "2_5_2020" "2_6_2020" "2_7_2020" "2_8_2020" "2_9_2020" "2_10_2020" "2_11_2020" "2_12_2020" "2_13_2020" "2_14_2020" "2_15_2020" "2_16_2020" "2_17_2020" "2_18_2020" "2_19_2020" "2_20_2020" "2_21_2020" "2_22_2020" "2_23_2020" "2_24_2020" "2_25_2020" "2_26_2020" "2_27_2020" "2_28_2020" "2_29_2020")

declare -a mar=("3_1_2020" "3_2_2020" "3_3_2020" "3_4_2020" "3_5_2020" "3_6_2020" "3_7_2020" "3_8_2020" "3_9_2020" "3_10_2020" "3_11_2020" "3_12_2020" "3_13_2020" "3_14_2020" "3_15_2020" "3_16_2020" "3_17_2020" "3_18_2020" "3_19_2020" "3_20_2020" "3_21_2020" "3_22_2020" "3_23_2020" "3_24_2020" "3_25_2020" "3_26_2020" "3_27_2020" "3_28_2020" "3_29_2020" "3_30_2020" "3_31_2020" )

declare -a apr=("4_1_2020" "4_2_2020" "4_3_2020" "4_4_2020" "4_5_2020" "4_6_2020" "4_7_2020" "4_8_2020" "4_9_2020" "4_10_2020" "4_11_2020" "4_12_2020" "4_13_2020" "4_14_2020" "4_15_2020" "4_16_2020" "4_17_2020" "4_18_2020" "4_19_2020" "4_20_2020" "4_21_2020" "4_22_2020" "4_23_2020" "4_24_2020" "4_25_2020" "4_26_2020" "4_27_2020" "4_28_2020" "4_29_2020" "4_30_2020" "4_31_2020" )

declare -a may=("5_1_2020" "5_2_2020" "5_3_2020" "5_4_2020" "5_5_2020" "5_6_2020" "5_7_2020" "5_8_2020" "5_9_2020" "5_10_2020" "5_11_2020" "5_12_2020" "5_13_2020" "5_14_2020" "5_15_2020" "5_16_2020" "5_17_2020" "5_18_2020" "5_19_2020" "5_20_2020" "5_21_2020" "5_22_2020" "5_23_2020" "5_24_2020" "5_25_2020" "5_26_2020" "5_27_2020" "5_28_2020" "5_29_2020" "5_30_2020" "5_31_2020" )

declare -a jun=("6_1_2020" "6_2_2020" "6_3_2020" "6_4_2020" "6_5_2020" "6_6_2020" "6_7_2020" "6_8_2020" "6_9_2020" "6_10_2020" "6_11_2020" "6_12_2020" "6_13_2020" "6_14_2020" "6_15_2020" "6_16_2020" "6_17_2020" "6_18_2020" "6_19_2020" "6_20_2020" "6_21_2020" "6_22_2020" "6_23_2020" "6_24_2020" "6_25_2020" "6_26_2020" "6_27_2020" "6_28_2020" "6_29_2020" "6_30_2020" "6_31_2020" )

declare -a jul=("7_1_2020" "7_2_2020" "7_3_2020" "7_4_2020" "7_5_2020" "7_6_2020" "7_7_2020" "7_8_2020" "7_9_2020" "7_10_2020" "7_11_2020" "7_12_2020" "7_13_2020" "7_14_2020" "7_15_2020" "7_16_2020" "7_17_2020" "7_18_2020" "7_19_2020" "7_20_2020" "7_21_2020" "7_22_2020" "7_23_2020" "7_24_2020" "7_25_2020" "7_26_2020" "7_27_2020" "7_28_2020" "7_29_2020" "7_30_2020" "7_31_2020" )

declare -a nonrepro_list=("7480" "7640" "7555" "7477" "7641" "7553" "7644" "7652" "7648" "7646" "7645" "7472" "7655" "7554" "7548" "7557" "7639" "7558" "7654" "7565" "7566" "7625" "7559")

declare -a repro_list=("7620" "7623" "7621" "7649" "7563" "7561" "7556" "7547" "7632" "7469" "7468" "7471" "7657" "7470")

dateR=$(date "+%m-%d-%Y")
input_file="$1"

#####­#####Variables###############
#repro_list= animals maintained in reproductive groups
#non_reprolist= animals maintained in non-reprodcutive groups
##################################
#
##########Setup Environment#######
#N/A This script only uses bash functions.
##########Commands################
#
# STEP 1: Intake csv file with temperatures.
#
# STEP 2: Parse temperature reads by ID number.This first half parses ids from the reproductive list. The second half parses ids associated
# with animals who are non-reproductive.

if test -f "$input_file"; then
	for id in ${repro_list[@]}; do
		grep $id $input_file | awk -F',' '{print $1,$2,$5}' | sed 's/\//\_/g' | grep -v "Temp below range"> ${id}_temps.r.csv
	done
	mkdir Repro_temps-$dateR/
	mv *.r.csv Repro_temps-$dateR/
	cd Repro_temps-$dateR/
	for id in ${repro_list[@]}; do
		for day in ${sept[@]}; do
			grep $day ${id}_temps.r.csv  > ${day}_${id}.r.day
			cat ${day}_${id}.r.day | awk '{total+= $3; count++ } END {print $1, $2, total/count}' > ${day}_${id}.r.AVGday
		done
                for day in ${oct[@]}; do
                        grep $day ${id}_temps.r.csv  > ${day}_${id}.r.day
                        cat ${day}_${id}.r.day | awk '{total+= $3; count++ } END {print $1, $2, total/count}' > ${day}_${id}.r.AVGday
                done
                for day in ${nov[@]}; do
                        grep $day ${id}_temps.r.csv  > ${day}_${id}.r.day
                        cat ${day}_${id}.r.day | awk '{total+= $3; count++ } END {print $1, $2, total/count}' > ${day}_${id}.r.AVGday
                done
                for day in ${dec[@]}; do
                        grep $day ${id}_temps.r.csv  > ${day}_${id}.r.day
                        cat ${day}_${id}.r.day | awk '{total+= $3; count++ } END {print $1, $2, total/count}' > ${day}_${id}.r.AVGday
                done
                for day in ${jan[@]}; do
                        grep $day ${id}_temps.r.csv  > ${day}_${id}.r.day
                        cat ${day}_${id}.r.day | awk '{total+= $3; count++ } END {print $1, $2, total/count}' > ${day}_${id}.r.AVGday
                done
                for day in ${feb[@]}; do
                        grep $day ${id}_temps.r.csv  > ${day}_${id}.r.day
                        cat ${day}_${id}.r.day | awk '{total+= $3; count++ } END {print $1, $2, total/count}' > ${day}_${id}.r.AVGday
                done
                for day in ${mar[@]}; do
                        grep $day ${id}_temps.r.csv  > ${day}_${id}.r.day
                        cat ${day}_${id}.r.day | awk '{total+= $3; count++ } END {print $1, $2, total/count}' > ${day}_${id}.r.AVGday
                done
                for day in ${apr[@]}; do
                        grep $day ${id}_temps.r.csv  > ${day}_${id}.r.day
                        cat ${day}_${id}.r.day | awk '{total+= $3; count++ } END {print $1, $2, total/count}' > ${day}_${id}.r.AVGday
                done
                for day in ${may[@]}; do
                        grep $day ${id}_temps.r.csv  > ${day}_${id}.r.day
                        cat ${day}_${id}.r.day | awk '{total+= $3; count++ } END {print $1, $2, total/count}' > ${day}_${id}.r.AVGday
                done
                for day in ${jun[@]}; do
                        grep $day ${id}_temps.r.csv  > ${day}_${id}.r.day
                        cat ${day}_${id}.r.day | awk '{total+= $3; count++ } END {print $1, $2, total/count}' > ${day}_${id}.r.AVGday
                done
                for day in ${jul[@]}; do
                        grep $day ${id}_temps.r.csv  > ${day}_${id}.r.day
                        cat ${day}_${id}.r.day | awk '{total+= $3; count++ } END {print $1, $2, total/count}' > ${day}_${id}.r.AVGday
                done

	done
        mkdir Repro_temps_day-$dateR
        mv *.day Repro_temps_day-$dateR/
	mkdir Repro_temps_avg/
	mv *.AVGday Repro_temps_avg/
	cd Repro_temps_avg/
	for id in  ${repro_list[@]}; do
		grep $id *.r.AVGday | sed 's/:/\ /g'| awk -F' ' '{print $2,$3,$4}'| sed 's/_/\//g'| sort -k2 -M | sed 's/ /,/g' > ${id}_temp.merged.r.csv
	done
	mkdir Repro_merged_temps/
	mv *.merged.r.csv Repro_merged_temps/
	cd Repro_merged_temps/
	cat *merged.r.csv | sed 's/ /,/g'| sort -k2 -M > combined.merged.r.csv
#############################################
#######Non-Reproductives List
#############################################

	cd ../../../
	for id in ${nonrepro_list[@]}; do
		grep $id $input_file | awk -F',' '{print $1,$2,$5}' | sed 's/\//\_/g'| grep -v "Temp below range" > ${id}_temps.nr.csv
	done
	mkdir NonRepro_temps-$dateR/
	mv *.nr.csv NonRepro_temps-$dateR/
	cd NonRepro_temps-$dateR/
	for id in ${nonrepro_list[@]}; do
		for day in ${sept[@]}; do
			grep $day ${id}_temps.nr.csv  > ${day}_${id}.nr.day
			cat ${day}_${id}.nr.day | awk '{total+= $3; count++ } END {print $1, $2, total/count}' > ${day}_${id}.nr.AVGday
		done
                for day in ${oct[@]}; do
                        grep $day ${id}_temps.nr.csv  > ${day}_${id}.nr.day
                        cat ${day}_${id}.nr.day | awk '{total+= $3; count++ } END {print $1, $2, total/count}' > ${day}_${id}.nr.AVGday
                done
                for day in ${nov[@]}; do
                        grep $day ${id}_temps.nr.csv  > ${day}_${id}.nr.day
                        cat ${day}_${id}.nr.day | awk '{total+= $3; count++ } END {print $1, $2, total/count}' > ${day}_${id}.nr.AVGday
                done
                for day in ${dec[@]}; do
                        grep $day ${id}_temps.nr.csv  > ${day}_${id}.nr.day
                        cat ${day}_${id}.nr.day | awk '{total+= $3; count++ } END {print $1, $2, total/count}' > ${day}_${id}.nr.AVGday
                done
                for day in ${jan[@]}; do
                        grep $day ${id}_temps.nr.csv  > ${day}_${id}.nr.day
                        cat ${day}_${id}.nr.day | awk '{total+= $3; count++ } END {print $1, $2, total/count}' > ${day}_${id}.nr.AVGday
                done
                for day in ${feb[@]}; do
                        grep $day ${id}_temps.nr.csv  > ${day}_${id}.nr.day
                        cat ${day}_${id}.nr.day | awk '{total+= $3; count++ } END {print $1, $2, total/count}' > ${day}_${id}.nr.AVGday
                done
                for day in ${mar[@]}; do
                        grep $day ${id}_temps.nr.csv  > ${day}_${id}.nr.day
                        cat ${day}_${id}.nr.day | awk '{total+= $3; count++ } END {print $1, $2, total/count}' > ${day}_${id}.nr.AVGday
                done
                for day in ${apr[@]}; do
                        grep $day ${id}_temps.nr.csv  > ${day}_${id}.nr.day
                        cat ${day}_${id}.nr.day | awk '{total+= $3; count++ } END {print $1, $2, total/count}' > ${day}_${id}.nr.AVGday
                done
                for day in ${may[@]}; do
                        grep $day ${id}_temps.nr.csv  > ${day}_${id}.nr.day
                        cat ${day}_${id}.nr.day | awk '{total+= $3; count++ } END {print $1, $2, total/count}' > ${day}_${id}.nr.AVGday
                done
                for day in ${jun[@]}; do
                        grep $day ${id}_temps.nr.csv  > ${day}_${id}.nr.day
                        cat ${day}_${id}.nr.day | awk '{total+= $3; count++ } END {print $1, $2, total/count}' > ${day}_${id}.nr.AVGday
                done
                for day in ${jul[@]}; do
                        grep $day ${id}_temps.nr.csv  > ${day}_${id}.nr.day
                        cat ${day}_${id}.nr.day | awk '{total+= $3; count++ } END {print $1, $2, total/count}' > ${day}_${id}.nr.AVGday
                done
	done
        mkdir NonRepro_temps_day-$dateR
        mv *.nr.day NonRepro_temps_day-$dateR/
	mkdir NonRepro_temps_avg/
	mv *.nr.AVGday NonRepro_temps_avg/
	cd NonRepro_temps_avg/
	for id in  ${nonrepro_list[@]}; do
		grep $id *.nr.AVGday | sed 's/:/\ /g'| awk -F' ' '{print $2,$3,$4}' | sed 's/_/\//g'| sort -k2 -M | sed 's/ /,/g' > ${id}_temp.merged.nr.csv
	done
	mkdir NonRepro_merged_temps/
	mv *.merged.nr.csv NonRepro_merged_temps/
	cd NonRepro_merged_temps/
	cat *.merged.nr.csv | sed 's/ /,/g'| sort -k2 -M > combined.merged.nr.csv

else
	echo "$input_file not found. Aborting!"
fi
exit 0
