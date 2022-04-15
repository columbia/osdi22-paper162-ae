#!/bin/bash

source setup.sh

REPTS=${2-50}

echo "Measuring performance of $SRV"

# requires that apache is installed with the gcc manual in place
NR_REQUESTS=100000
RESULTS=apache.txt
ab=/usr/bin/ab
CMD="$ab -n $NR_REQUESTS -c 100 http://$SRV/index.html"

for i in `seq 1 $REPTS`; do
	$CMD | tee >(grep 'Requests per second' | awk '{ print $4 }' >> $RESULTS)
done
