from time import sleep
from scapy.all import sendp
from scapy.layers.inet6 import IPv6, IPv6ExtHdrHopByHop
from scapy.layers.l2 import Ether
import socket

ip6_src = "2001:f1::1"
ip6_dst = "2001:f4::1"
sending_port = 4001
iface = "vpp1host"

ip6 = IPv6(src=ip6_src, dst=ip6_dst, hlim=10)
hbh_ext = IPv6ExtHdrHopByHop()

packet = Ether()/ip6/hbh_ext

packet.show()

while True:
    sendp(packet, iface=iface, return_packets=True)
    sleep(1)

# send(packet, iface=iface, loop=1, realtime=1, verbose=1)

# UDP
# with socket.socket(socket.AF_INET6, socket.SOCK_DGRAM) as s:
#     s.setsockopt(socket.SOL_SOCKET, socket.SO_BINDTODEVICE, str(iface + '\0').encode('utf-8'))
#     while True:
#         s.sendto(bytes(packet), (ip6_dst, sending_port)) #TODO: test in server
#         sleep(1)
#     # data = s.recv(1024)