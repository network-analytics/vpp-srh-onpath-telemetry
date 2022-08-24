import socket
import sys
from time import sleep
from time import sleep

bind_device="vpp1host"
sending_ip="2001:f4::1"
sending_port=4001

packet_size=400
packet=''

for i in range(packet_size):
    packet += 'A'

if len(sys.argv) == 3:
    bind_device=sys.argv[1]
    sending_ip=sys.argv[2]

print("binding to %s - %s" % (bind_device, sending_ip))

# UDP
with socket.socket(socket.AF_INET6, socket.SOCK_DGRAM) as s:
    s.setsockopt(socket.SOL_SOCKET, socket.SO_BINDTODEVICE, str(bind_device + '\0').encode('utf-8'))
    s.connect((sending_ip, sending_port))
    #print("BOUND", sending_ip, sending_port)
    #sleep(2)
    while True:
        s.sendall(bytes(packet, encoding='utf-8')) #TODO: test in server
        sleep(1)
    # data = s.recv(1024)