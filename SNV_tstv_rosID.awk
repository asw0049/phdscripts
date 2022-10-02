{
if (($3 == "A-T") || ($3 == "A-C") || ($3 == "T-A") || ($3 == "T-G") || ($3 == "G-C") || ($3 == "C-G")) SNVType="Other Transversion";
else if (($3 == "A-G") || ($3 == "G-A") || ($3 == "T-C") || ($3 == "C-T")) SNVType="Replication Error Transition";
else if (($3 == "G-T") || ($3 == "C-A")) SNVType="ROS-Mediated Transversion";
else if ($3 ~ /[[:alpha:]]-[[:alpha:]]{2}+/) SNVType="Replication Error Insertion";
else if ($3 ~ /[[:alpha:]]{2}+-[[:alpha:]]/) SNVType="Replication Error Deletion";
print ($0)";"SNVType
if (($3 != "A-T")||($3 != "A-C")||($3 != "A-G")||($3 != "G-C")||($3 != "G-A")||($3 != "G-T")||($3 != "C-A")||($3 != "C-T")||($3 !="C-G")||($3 != /[[:alpha:]]-[[:alpha:]]{2}+/)||($3 != /[[:alpha:]]{2}+-[[:alpha:]]/)) SNVType="Other";
}

