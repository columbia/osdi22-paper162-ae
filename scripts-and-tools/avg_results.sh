#!/bin/bash

if [[ "$1" == "-help" || "$1" == "-h" ||  -z "$1" ]]; then
	echo "Usage: $0 <[workload].txt>"
	echo "    Obtains an average from a workload results file."
	exit 0
fi

awk '{ sum += $1; n++ } END { if (n > 0) print sum / n; }' "$1"
