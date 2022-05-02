
# Launch
sudo systemctl is-active vpp.service
sudo systemctl stop vpp.service
sudo /usr/bin/vpp -c 1_vpp.conf
sudo /usr/bin/vpp -c 2_vpp.conf

# Entering CLI
sudo vppctl -s /run/vpp/1vpp-cli.sock
sudo vppctl -s /run/vpp/2vpp-cli.sock


# VPP CLI 
create host-interface name vpp1out
set int state host-vpp1out up
show hardware-interfaces
show int addr
set int ip address host-vpp1out 10.10.1.2/24

# delete
set interface ip address del host-vpp1out 10.10.3.2/24 


# Trace
show trace
clear trace
trace add af-packet-input 10

# ARP
show ip neighbours

# FIB
show ip fib

# Connecting VPPs
create interface memif id 0 master
create interface memif id 0 slave



# Services:
/usr/lib/systemd/system/vpp.service
