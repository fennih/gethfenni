#!/bin/bash

nop=`awk /'new mining work/ {print $2,$3}' /home/ubuntu/geth-general/node1.txt | wc -l`
echo $nop >> nop.txt

unlocked=`awk /'Unlocked / {print $2}' /home/ubuntu/testlog/node1.txt |cut -c 8- | rev | cut -c 2- | rev`
last_info=`awk 'END{print $2}' /home/ubuntu/testlog/node1.txt | cut -c 8- | rev | cut -c 2- | rev`

timestamp() {
   date '+%s%N' --date="$1"
}

total="$(( $(timestamp "$last_info") - $(timestamp "$unlocked") ))"

totalmod=${total::-6}
echo $totalmod / 1000 | bc -l | rev | cut -c 18- | rev >> totaltime.txt

v1=`cat totaltime.txt`
v2=`cat nop.txt`

real=$(echo `tr ' ' '\n' < /home/ubuntu/geth-general/node1.txt | grep lost | wc -l`)

v3=$(echo "($v2 / $v1)" | bc -l)
echo $v3 "operations per seconds" >> /home/ubuntu/result_throughput.txt
echo "File created"

count=$(echo "$v2 - $real"|bc)
echo $count

v4=$(echo "($count / $v1)" | bc -l)
echo $v4 "operations per seconds" >> /home/ubuntu/real_throughput.txt
echo "File created (real)"

