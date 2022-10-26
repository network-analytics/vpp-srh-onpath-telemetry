#!/bin/bash

tmux has-session -t dev_srh_export
if [ $? != 0 ]
then
    tmux new -s dev_srh_export -d
else 
    tmux kill-session -t dev_srh_export
    tmux new -s dev_srh_export -d
fi

tmux new -s dev_srh_export -d
tmux select-pane -t 0
tmux split-window -v -p 70
tmux select-pane -t 1
tmux split-window -v -p 50

tmux select-pane -t 0
tmux split-window -h -p 50
tmux select-pane -t 2
tmux split-window -h -p 45
tmux select-pane -t 2
tmux split-window -h -p 50

tmux select-pane -t 0
tmux send-keys 'cd /home/vagrant/vpp-master' C-m
tmux send-keys 'export STARTUP_CONF=/home/vagrant/Unyte/vpp/dev_srh_export/1_vpp.conf' C-m

tmux select-pane -t 1
tmux send-keys 'cd /home/vagrant/vpp-master' C-m
tmux send-keys 'export STARTUP_CONF=/home/vagrant/Unyte/vpp/dev_srh_export/2_vpp.conf' C-m

tmux select-pane -t 4
tmux send-keys 'cd /home/vagrant/vpp-master' C-m
tmux send-keys 'export STARTUP_CONF=/home/vagrant/Unyte/vpp/dev_srh_export/3_vpp.conf' C-m

tmux select-pane -t 2
tmux send-keys 'cd /home/vagrant/Unyte/vpp/dev_srh_export' C-m
# tmux send-keys 'sudo python3 sender-udp.py' C-m

tmux select-pane -t 3
tmux send-keys 'cd /home/vagrant/Unyte/' C-m
# tmux send-keys 'sudo tcpdump -i vpp2host' C-m

tmux select-pane -t 5
tmux send-keys 'cd /home/vagrant/Unyte/' C-m
tmux a -t dev_srh_export
