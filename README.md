
# Creating host interfaces
```shell
sudo ip link add name vpp1out type veth peer name vpp1host
sudo ip link set dev vpp1out up
sudo ip link set dev vpp1host up
sudo ip addr add 10.10.1.1/24 dev vpp1host

sudo ip link add name vpp2out type veth peer name vpp2host
sudo ip link set dev vpp2out up
sudo ip link set dev vpp2host up
sudo ip addr add 10.11.1.1/24 dev vpp2host
```

# Launch
```shell
sudo systemctl is-active vpp.service
sudo systemctl stop vpp.service
sudo /usr/bin/vpp -c 1_vpp.conf
sudo /usr/bin/vpp -c 2_vpp.conf
```

# Entering CLI
```shell
sudo vppctl -s /run/vpp/1vpp-cli.sock
sudo vppctl -s /run/vpp/2vpp-cli.sock
```


# VPP CLI 
```shell
create host-interface name vpp1out
set int state host-vpp1out up
show hardware-interfaces
show int addr
set int ip address host-vpp1out 10.10.1.2/24
```

# delete
set interface ip address del host-vpp1out 10.10.3.2/24 


# Trace
show trace
clear trace
trace add af-packet-input 10
trace add memif-input 10

# ARP
show ip neighbours

# FIB
show ip fib

# Connecting VPPs
create interface memif id 0 master
create interface memif id 0 slave


# pcap
pcap dispatch trace on max 10000 file vppcapture.pcap buffer-trace dpdk-input 100
pcap dispatch trace off


# Services:
/usr/lib/systemd/system/vpp.service


https://s3-docs.fd.io/vpp/22.06/developer/corearchitecture/vnet.html
https://s3-docs.fd.io/vpp/22.06/developer/corearchitecture/vnet.html#buffer-initialization-example
https://vpp.flirble.org/stable-2110/dc/d7e/udp__input_8c_source.html

https://www.programmersought.net/article/389265850.html
https://www.mail-archive.com/vpp-dev@lists.fd.io/msg01820.html

https://www.asumu.xyz/blog/2018/03/22/how-to-develop-vpp-plugins/

#TODO: try probeflow ipfix
https://s3-docs.fd.io/vpp/22.06/developer/plugins/flowprobe.html?highlight=ipfix#sample-configuration
