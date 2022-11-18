## Dependencies on Ubuntu
```shell
sudo apt update
sudo apt install build-essential libssl-dev
sudo snap install cmake --classic
sudo apt install ninja-build
sudo apt install pkg-config

git clone https://gerrit.fd.io/r/vpp
cd vpp

# Check vpp and dpdk are not already installed
dpkg -l | grep vpp
dpkg -l | grep DPDK

# Uninstall if installed
sudo apt-get remove --purge "vpp*"

# Note: Install and build does not work on a shared directory
make install-dep
make install-ext-deps

# Note: need 8GB or more for compiling
make build

sudo apt install emacs

make rebuild
make run

```
<!-- 
```shell
apt install vpp-ext-deps ?
``` -->

## RHEL9
```shell
sudo yum update
sudo yum install yum-utils
sudo yum install pygpgme yum-utils

# have to change the makefile, remove some dependencies and remove the dependencies check in `make build`
make build

# create vpp group 
groupadd vpp
sudo usermod -a -G vpp <current_user>
newgrp vpp
```
