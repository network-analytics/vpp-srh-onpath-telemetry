#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi


VPP_PROCESSES=$(ps aux | grep "vpp" | grep -v "grep" | awk '{print $2}')
VPP_REPO=/home/vagrant/vpp-master/

for i in $VPP_PROCESSES ;
do 
    echo "Killing sender program $i process";
    sudo kill -9 $i;
done
