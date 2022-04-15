#!/bin/bash

source setup.sh


REPTS=${3-20}
#RESULTS=netperf.txt

echo "Measuring netperf performance of $SRV"

#UDP_RR
for _TEST in TCP_MAERTS TCP_STREAM TCP_RR; do
#	echo $_TEST >> $RESULTS
	if [ "$_TEST" == "TCP_RR" ]; then
		REPTS=50
	fi
	for i in `seq 1 $REPTS`; do
		if [[ "$_TEST" == "TCP_RR" ]]; then
			netperf -H $SRV -t $_TEST | tail -n2 | head -n1 | awk ' { print $6 }' | tee -a netperf_$_TEST.txt
		else
			netperf -H $SRV -t $_TEST | tail -n1 | awk '{ print $5 }' | tee -a netperf_$_TEST.txt
		fi
	done
done
