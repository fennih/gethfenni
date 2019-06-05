#!/bin/bash
x=`wc -l < /home/ubuntu/geth-general/node1.txt`
echo $x
for ((c=1; c<=$x; c++))
do
	lat=`awk '/work/ { if (NR==v1) print $2 }' v1="${c}" /home/ubuntu/geth-general/node1.txt | cut -c 8- | rev | cut -c 2- | rev`
	echo $lat >> dateblocchi.txt
done
sed '/^$/d' dateblocchi.txt > timestampblocchi.txt
rm dateblocchi.txt
y=`wc -l < timestampblocchi.txt`

timestamp() {
   date '+%s%N' --date="$1"
}

echo $y

for (( n=1; n<=$y; n++ ))
do
	var1=`sed -n "$n"p timestampblocchi.txt`
	echo $n
	var2=`grep -A 1 "$var1" /home/ubuntu/geth-general/node1.txt`
	mod2=`echo $var2 | sed 's/INFO/\n/g' | tail -n 1 | awk '{print $1}' |  cut -c 8- | rev | cut -c 2- | rev `
	echo $var1 >> check1.txt
	echo $mod2 >> check2.txt

	total="$(( $(timestamp "$mod2") - $(timestamp "$var1") ))"
	echo $total >> check3.txt
	totalmod=${total::-6}
	echo $totalmod >>  medialatenze.txt
done
sed 's/^-.*/0/' medialatenze.txt
average_lat=`awk '{s+=$1} END {print s/NR}' medialatenze.txt`
clear

echo "The latency on average is" $average_lat "ms"
echo $average_lat >> average_latency.txt
