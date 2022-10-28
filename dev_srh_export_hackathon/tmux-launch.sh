#!/bin/bash

tmux has-session -t dev_srh_export_hackathon
if [ $? != 0 ]
then
    tmux new -s dev_srh_export_hackathon -d
else 
    tmux kill-session -t dev_srh_export_hackathon
    tmux new -s dev_srh_export_hackathon -d
fi

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
tmux send-keys 'cd /home/taahual9/vpp' C-m
tmux send-keys 'export STARTUP_CONF=/home/taahual9/vpp-srh-onpath-telemetry/dev_srh_export_hackathon/1_vpp.conf' C-m

tmux select-pane -t 1
tmux send-keys 'cd /home/taahual9/vpp' C-m
tmux send-keys 'export STARTUP_CONF=/home/taahual9/vpp-srh-onpath-telemetry/dev_srh_export_hackathon/2_vpp.conf' C-m

tmux select-pane -t 4
tmux send-keys 'cd /home/taahual9/vpp' C-m
tmux send-keys 'export STARTUP_CONF=/home/taahual9/vpp-srh-onpath-telemetry/dev_srh_export_hackathon/3_vpp.conf' C-m

tmux select-pane -t 2
tmux send-keys 'cd /home/taahual9/vpp-srh-onpath-telemetry/dev_srh_export_hackathon/' C-m
# tmux send-keys 'sudo python3 sender-udp.py' C-m

tmux select-pane -t 3
tmux send-keys 'cd /home/taahual9/Unyte/' C-m
# tmux send-keys 'sudo tcpdump -i vpp2host' C-m

tmux select-pane -t 5
tmux send-keys 'cd /home/taahual9/Unyte/' C-m
tmux a -t dev_srh_export_hackathon
