#!/bin/bash
#
# Print a horizontal line across the terminal
#
marker='='
let width=$(stty size | pcol NF)
let i=0;
while [ $i -lt $width ]
do
	echo -n ${1:-$marker}
	let i=i+1
done
echo 
