#!/bin/bash

# if [ "$EUID" -ne 0 ]
#   then echo "Please run as root"
#   exit
# fi

VPP_PROCESSES=$(ps aux | grep "vpp" | grep -v "grep" | awk '{print $2}')

for i in $VPP_PROCESSES ;
do 
    echo "Killing sender program $i process";
    sudo kill -9 $i;
done

# tmux attach -t dev_jbayaux_ioam

tmux select-pane -t 0
tmux send-keys 'make run' C-m

tmux select-pane -t 1
tmux send-keys 'make run' C-m

tmux select-pane -t 4
tmux send-keys 'make run' C-m

