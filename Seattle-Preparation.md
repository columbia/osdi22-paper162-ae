# Seattle Preparation

To prepare an Arm Seattle server with a clean install of Ubuntu 16.04 for
evaluating BlackBox the steps below should be followed.

Note: These steps have already been performed on seattle.cs.columbia.edu and are
not necessary for reviewing the artifact.

## Clone This Repository

On the seattle server:

``git clone git@github.com:columbia/osdi-paper162-ae``

Then move everything from ``osdi-paper162-ae`` into ``/root`` and everything
from ``osdi-paper162-ae/scripts-and-tools`` to ``/root``

## Obtain Workloads

Download the workload source code into ``/root``:

```
curl https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.4.188.tar.xz | tar xJ
cd linux-5.4.188 && make allnoconfig && cd ..
curl http://www.memcached.org/files/memcached-1.6.9.tar.gz | tar xz
curl https://archive.apache.org/dist/httpd/httpd-2.4.46.tar.bz2 | tar xj
cd httpd-2.4.46
[build and install to /root/httpd-2.4.46/apache]
[uncomment the "LoadModule...mod_ssl.so" line in conf/httpd.conf]
[uncomment the "Include conf/extra/httpd-ssl.conf" line in conf/httpd.conf]
[create the /root/httpd-2.4.46/apache2/conf/{server.key,server.crt} keypair]
cd apache2/htdocs
curl 'https://bl.ocks.org/SunDi3yansyah/raw/c8e7a935a9f6ee6873a2/?raw=true' > index.html
cd /root
git clone https://github.com/HewlettPackard/netperf.git -b netperf-2.6.0
wget https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/sched/cfs-scheduler/hackbench.c
wget https://raw.githubusercontent.com/linux-test-project/ltp/master/utils/benchmark/kernbench-0.42/kernbench
chmod +x kernbench
mv kernbench linux-5.4.188/
```

Then build the workloads as per their build instructions and install Apache to ``httpd-2.4.46/apache2`` (``./configure --prefix /root/httpd-2.4.46/apache2``).


## Build Evaluation Containers

On the seattle server:

```
cd /root/containers
docker build . -t eval
docker build . -f Dockerfile.mysql -t eval-mysql
```

## Install Kernel Images

Install the kernel images in the ``kernels`` directory either by adding GRUB entries or manually swapping image files.
