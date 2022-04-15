#!/bin/bash

########
# XXX: BlackBox must be in permissive mode for this!
####X###

INIT=""
BASE="/root"

if [[ "$1" == "--help" || "$1" == "-h" || "$#" -eq 0 ]]; then
	echo "Usage: $0 [--enclave] <workload>"
	echo "    --enclave: Run workload in a BlackBox enclaved container"
	echo "    workload: Either apache, netperf, memcached, mysql, hackbench, or kernbench"
	exit 0
fi

if [ "$1" == "--enclave" ]; then
	INIT="/root/init"
	echo "Running enclaved container..."
	shift
else
	echo "Running standard container..."
fi

case "$1" in
apache)
	echo "Apache starting..." ;
	rm -f $BASE/httpd-2.4.46/apache2/logs/httpd.pid ;
	$INIT $BASE/httpd-2.4.46/apache2/bin/apachectl -D FOREGROUND --isatty
	exit
	;;
netperf)
	echo "Netperf server starting..."
	$INIT $BASE/netperf/src/netserver -p 12865 -L 0.0.0.0,inet -D
	exit
	;;
memcached)
	echo "Memcached started"
	$INIT $BASE/memcached-1.6.9/memcached -u daemon
	exit
	;;
mysql)
	echo "MySQL starting..."
	if [ -z "$INIT" ]; then
		/usr/bin/mysqld_safe
	else
		/home/alexvh/init /usr/bin/mysqld_safe --innodb-use-native-aio=OFF --myisam_use_mmap=OFF
	fi
	exit
	;;
hackbench)
	echo "Running hackbench 10 times... saving results to /root/hackbench.txt"
	for i in $(seq 1 10); do
		$INIT $BASE/hackbench 100 process 500 | tail -n1 | awk '{ print $2 }' | tee -a /root/hackbench.txt
	done
	exit
	;;
kernbench)
	echo "Running kernbench for 5 runs... saving average result to /root/kernbench.txt"
	cd $BASE/linux-5.4.188
	$INIT $BASE/linux-5.4.188/kernbench -n 5 -f -H -M | tee /root/kernbench.txt
	cp /root/kernbench.txt /tmp/
	grep 'Elapsed Time' /tmp/kernbench.txt | awk '{ print $3 }' > /root/kernbench.txt
	exit
	;;
*)
	echo "error: invalid workload: $1"
	echo "valid workloads are: apache, netperf, memcached, mysql, hackbench, kernbench"
	exit
esac
