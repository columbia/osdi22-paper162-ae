#!/bin/bash

cd ycsb-0.17.0
echo "Benchmarking..."
./mysqldb.sh | tee -a ../mysql.txt
