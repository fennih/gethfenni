#!/bin/bash

timestamp() {
   date '+%s%N' --date="$1"
}

echo "Insert number of sealers nodes"
read sealers
echo "Insert total number of nodes"
read nodes

threshold=160

for((c=1;c<=$sealers;c++))
do
        awk /'mined/ {print $8}' node$c.txt | cut -c 6- >> hashnode$c.txt
done
cat hashnode*.txt > totalhash.txt
rm hashnode*.txt
tot=`wc -l < totalhash.txt`
for((x=1;x<=$tot;x++))
do
	for ((y=1;y<=$nodes;y++))
	do
		var1=`sed -n "$x"p totalhash.txt`
		mod=`grep -- "$var1" node$y.txt | awk '{print $2}'`
		echo $mod | cut -c 8- | rev | cut -c 2- | rev >> temp/filenode$x.txt
	done
	awk '{ print $1}' temp/filenode$x.txt > temp/finalfilenode$x.txt
done
sed -i '/^$/d' temp/*.txt
rm temp/filenode*.txt
for((u=1;u<=$tot;u++))
do
	cut -d ']' -f 1 temp/finalfilenode$u.txt > temp/final$u.txt
done
rm temp/finalfile*.txt
for((p=1;p<=$tot;p++))
do
	min=`sort temp/final$p.txt | head -1`
	max=`sort temp/final$p.txt | tail -1`
	difference="$(( $(timestamp "$max") - $(timestamp "$min") ))"
	totaldiff=`echo $difference / 1000000 | bc -l`
	try=`echo ${totaldiff%\.*}`
	if (("$try" <= "$threshold")); then echo $totaldiff >> timepropagation.txt
	else
	echo $min "is min and "$max "is max"
	fi
done

average_prop=`awk '{s+=$1} END {print s/NR}' timepropagation.txt`
echo "The propagation time on average is " $average_prop "ms"
echo $average_prop >> /home/ubuntu/prova/cc_prop.txt
