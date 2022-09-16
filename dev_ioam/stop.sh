#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

SENDER_PROCESSES=$(ps aux | grep "vpp" | grep -v "grep" | awk '{print $2}')

for i in $SENDER_PROCESSES ;
do 
    echo "Killing sender program $i process";
    kill -9 $i;
done
