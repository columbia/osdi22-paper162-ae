#!/bin/bash

if [[ "$1" == "--help" || "$1" == "-h" || "$#" -eq 0 ]]; then
        echo "Usage: $0 [--enclave] <workload>"
        echo "    --enclave: Run workload in a BlackBox enclaved container"
        echo "    workload: Either apache, netperf, memcached, mysql, hackbench, or kernbench"
        exit 0
fi

DETACH=""
if [[ "$1" == "apache" || "$2" == "apache" ]]; then
	DETACH="--detach"
fi

if [[ "$1" == "mysql" || "$2" == "mysql" ]]; then
	mkdir /var/run/mysqld > /dev/null 2>&1
	chown mysql.mysql /var/run/mysqld
	
	docker run \
		--net=host \
		--rm \
		-it \
		-u 106:111 \
		--cap-add SYS_NICE \
		-v /data:/data \
		-v /home/alexvh:/home/alexvh \
		-v /var/lib/mysql:/var/lib/mysql \
		-v /etc/mysql:/etc/mysql \
		-v /var/log/mysql:/var/log/mysql \
		-v /var/run/mysqld:/var/run/mysqld \
		test-mysql $@
	exit
fi


if [[ "$1" == "kernbench" || "$2" == "kernbench" ]]; then
	docker run \
		--net=host \
		--rm \
		-it \
		-v /root:/root \
		eval $@
	exit
fi

docker run \
	--net=host \
	--rm \
	$DETACH \
	-it \
	-v /usr:/usr \
	-v /root:/root \
	eval $@
