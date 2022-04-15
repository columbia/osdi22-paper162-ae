#!/bin/bash

if [ "$1" == "prep" ]; then
	bin/ycsb load jdbc -P workloads/workloada -P db.properties -threads 100 -p recordcount=50000 -p operationcount=10000
	exit
fi

# Burn the first run - often an outlier
bin/ycsb run jdbc -P workloads/workloada -P db.properties -threads 100 -p recordcount=50000 -p operationcount=10000 >/dev/null 2>&1

for i in $(seq 1 50); do
	sleep 3
	bin/ycsb run jdbc -P workloads/workloada -P db.properties -threads 100 -p recordcount=50000 -p operationcount=10000 2>&1 | grep Throughput | awk '{ print $3 }'
done

sleep 30
