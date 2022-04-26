# Paper #162 -- BlackBox: Secure Containers on Untrusted Operating Systems using Arm Virtualization Hardware

This is the website for Paper #162's Artifact Evaluation for OSDI 2022,
evaluating the performance overhead of application workloads.

Instructions to run and test BlackBox are as follows:

# Getting Started Instructions

Below is an example of how to run the Apache workload inside an enclaved
BlackBox container after providing us with your public ssh key.

```
ssh sekvm@libation.cs.columbia.edu
tmux attach
[switch to tab 0, right pane]
reboot
[select "Ubuntu 5.4 BlackBox" in GRUB menu]
[switch to tmux tab 1, left pane]
ssh seattle.cs.columbia.edu
sudo su
cd /root
./run_test.sh --enclave apache
[switch to right tmux pane]
ssh ds1.cs.columbia.edu # If not already there! (ds1 is "@gangan" on the bash prompt)
cd ~/artifact
./apache.sh
[collect results from apache.txt]
[switch to tmux tab 0, right pane]
docker stop $(docker ps -q)
```

# Detailed Instructions

## Prerequisites

* We have set up Arm seattle hardware for evaluating BlackBox. The steps in
  ``Seattle-Preparation.md`` were performed to make it ready. It is **not**
  necessary to perform these steps again.

* Please send us your public key so we can give you access to the machines.

* The workloads run on the Arm seattle server, Seattle, either with the unmodified Linux kernel or the BlackBox kernel. You should first log on to the Seattle machine and then the client machine, both via ssh.

* On the Seattle server, we have the environment installed for you already. You can simply use the Grub menu which we made available for you to select what kernel binary to use. We provide 2 configurations.

| Configuration                 | Grub Boot Menu     
|-------------------------------|--------------------
| Unmodified 5.4 Linux          | Ubuntu 5.4
| BlackBox based on Linux 5.4   | Ubuntu 5.4 BlackBox

## Overview
We set up a hop machine for you to connect to the Arm server and the client machine. You can connect to the **hop server** by ssh as follows. Note that you can only login to the server after you send us your public key.
```
# ssh sekvm@libation.cs.columbia.edu
```

Once you login, we have a tmux session setup for you already, so you can simply attach to it using:
```
# tmux attach
```

You will notice there are **2** tabs in the tmux session.
* To switch between tabs, the key combination is Ctrl+B followed by either 0 or 1.
* To switch between window panes within a tab, the key combination is Ctrl+B followed by either the left or right arrow key.
* To detach from tmux, the key combination is Ctrl+B followed 'd'. Please leave the tmux session intact.
* The first tab connects to the serial output of the Seattle server. You will need to switch to the right pane to select which kernel to boot in the grub menu.
* The second tab is for running measurements. You can use the pane on the left to connect to the Seattle server, and the right pane for the client, both via ssh from the hop machine (libation).
```
# ssh seattle.cs.columbia.edu    //for server
# ssh ds1.cs.columbia.edu    //for client
```

## Client Setup

Assuming you have logged on to the client machine (ds1.cs.columbia.edu) following the [instructions above](#Overview).

At the home directory you will find a directory, ``artifact``. Please cd there for testing.
```
# cd /home/sekvm/artifact    //this is on the client machine
```

## Scenarios

Since the workloads perform very similarly when run natively on the unmodified
kernel and while within a container, we recommend skipping running the workloads
natively and outside the evaluation containers on the unmodified kernel to save
time. If desired, native tests can be performed by running ``docker.sh``
directly.

* Containerized workloads on unmodified Linux (Grub entry: Ubuntu 5.4)
* Containerized workloads on BlackBox w/o enclaving (Grub entry: Ubuntu BlackBox 5.4)
* Enclaved containerized workloads on BlackBox (Grub entry: Ubuntu BlackBox 5.4)

## Running Application Benchmarks and Collecting Results

The experiments measure various application performance on one machine, the server Arm seattle machine, and the client machine, which sends workloads to the server machine over the network.


In the ``scripts`` directory, you can find the all the scripts you need to run the benchmarks. These have already been added to Seattle in ``/root`` and the client's ``~/artifact`` directory.

Client (ds1) Scripts:
| Benchmark            | Script        |
| ---------------------| --------------|
| Apache               | apache.sh     |
| Apache - SSL         | apache_ssl.sh |
| Netperf - TCP_STREAM | netperf.sh    |
| Netperf - TCP_MAERTS | netperf.sh    |
| Netperf - TCP_RR     | netperf.sh    |
| Memcached            | memcached.sh  |
| MySQL                | mysql.sh      |


Server (Seattle) Scripts:
| Benchmark                                               | Script              |
|---------------------------------------------------------|---------------------|
| Apache, Netperf, Memcached, MySQL, Hackbench, Kernbench | ./run_test.sh       |


For each workload, on Seattle run:
```
./run_test.sh [--enclave] <apache|hackbench|netperf|memcached|kernbench|mysql>

--enclave must be used for scenarios involving BlackBox enclaves.
```
This script resides in ``/root``. After each workload, ensure that the Docker container created for that workload is stopped before starting a new workload. This can be achieved by running ``docker stop $(docker ps -q)`` on Seattle.


For each workload on the server, run the respective workload's script on the
client. hackbench and kernbench are run directly on seattle via ``run_test.sh
[hackbench|kernbench]``:
```
./[workload].sh
```

The results will be saved to ``[workload].txt`` files. Hackbench and Kernbench
results will be saved on Seattle in ``/root/{hackbench,kernbench}.txt``.

Note: the result text files are always appended to, not overwritten. Ensure
previous result text files are removed or renamed before changing scenarios.

## Notes

* If the seattle server hangs, it can be power cycled using the left pane in the
  first tmux tab. When there, enter ``power reset``.
