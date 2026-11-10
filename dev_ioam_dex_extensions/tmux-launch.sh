#!/bin/bash

tmux has-session -t dev_ioam_dex_extensions
if [ $? != 0 ]
then
    tmux new -s dev_ioam_dex_extensions -d
else 
    tmux kill-session -t dev_ioam_dex_extensions
    tmux new -s dev_ioam_dex_extensions -d
fi

tmux set -g mouse on

tmux select-pane -t 0
tmux split-window -v -l 67%
tmux select-pane -t 1
tmux split-window -v -l 50%

tmux select-pane -t 0
tmux split-window -h -l 50%
tmux select-pane -t 2
tmux split-window -h -l 45%
tmux select-pane -t 2
tmux split-window -h -l 50%

tmux select-pane -t 2
tmux send-keys 'cd /home/vagrant/on-path-delay/vpp' C-m
tmux send-keys 'export STARTUP_CONF=/home/vagrant/on-path-delay/vpp-srh-onpath-telemetry/dev_ioam_dex_extensions/1_vpp.conf' C-m

tmux select-pane -t 3
tmux send-keys 'cd /home/vagrant/on-path-delay/vpp' C-m
tmux send-keys 'export STARTUP_CONF=/home/vagrant/on-path-delay/vpp-srh-onpath-telemetry/dev_ioam_dex_extensions/2_vpp.conf' C-m

tmux select-pane -t 4
tmux send-keys 'cd /home/vagrant/on-path-delay/vpp' C-m
tmux send-keys 'export STARTUP_CONF=/home/vagrant/on-path-delay/vpp-srh-onpath-telemetry/dev_ioam_dex_extensions/3_vpp.conf' C-m

tmux select-pane -t 0
tmux send-keys 'cd /home/vagrant/on-path-delay/vpp-srh-onpath-telemetry/dev_ioam_dex_extensions' C-m
# tmux send-keys 'sudo python3 sender-udp.py' C-m

tmux select-pane -t 1
tmux send-keys 'cd /home/vagrant/shared' C-m
# tmux send-keys 'sudo tcpdump -i vpp2host' C-m

tmux select-pane -t 5
tmux send-keys 'cd /home/vagrant/shared' C-m
tmux a -t dev_ioam_dex_extensions
