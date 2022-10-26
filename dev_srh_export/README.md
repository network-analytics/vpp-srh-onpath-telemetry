
# Deploy SRH topology
## Install
```shell
git clone https://gerrit.fd.io/r/vpp
cd vpp

git remote add insa git@github.com:insa-unyte/vpp-srh-export.git
git fetch insa
git checkout feature/srh-ipfix

make build
```

## Run

### Create virtual interfaces on the server:
```shell
sudo ip link add name vpp1out type veth peer name vpp1host
sudo ip link set dev vpp1out up
sudo ip link set dev vpp1host up
sudo ip addr add 10.10.1.1/24 dev vpp1host
sudo ip -6 addr add 2001:f1::1/126 dev vpp1host

sudo ip link add name vpp2out type veth peer name vpp2host
sudo ip link set dev vpp2out up
sudo ip link set dev vpp2host up
sudo ip addr add 10.11.4.1/24 dev vpp2host
sudo ip -6 addr add 2001:f4::1/126 dev vpp2host

sudo ip route add 10.10.2.0/24 via 10.10.1.2
sudo ip route add 2001:f2::0/126 via 2001:f1::2
sudo ip route add 10.10.3.0/24 via 10.10.1.2
sudo ip route add 2001:f3::0/126 via 2001:f1::2

sudo ip route add 2001:f4::1/126 via 2001:f1::2
```

### Running vpp nodes
4 terminals should be open

Multiple terminals can be launched using `tmux`. See the script [tmux-launch.sh](./tmux-launch.sh)

Terminal 1: Running encap node
```shell
cd <vpp-repository>
export STARTUP_CONF=/<this_repository>/dev_srh_export/1_vpp.conf
make run
```

Terminal 2: Running transit node
```shell
cd <vpp-repository>
export STARTUP_CONF=/<this_repository>/dev_srh_export/2_vpp.conf
make run
```

Terminal 3: Running decap node
```shell
cd <vpp-repository>
export STARTUP_CONF=/<this_repository>/dev_srh_export/3_vpp.conf
make run
```

Terminal 4: Sending packets 
```shell
sudo python3 ./sender-udp.py
```

### Debugging

Checking that the messages are been sent
```shell
sudo tcpdump -i vpp2host
```
