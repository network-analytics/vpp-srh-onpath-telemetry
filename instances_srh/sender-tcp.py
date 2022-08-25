import socket
import sys
from time import sleep
from csv import DictReader
from datetime import datetime
from time import time, sleep, mktime

bind_device="vpp1host"
sending_ip="2001:f4::1"
sending_port=4001
tcp_timeout_seconds=8 # sets timeout to socket and waits until restarting connection

packet_size=200
packet=''

if len(sys.argv) == 3: # only bind_dev and ip
    bind_device=sys.argv[1]
    sending_ip=sys.argv[2]
elif len(sys.argv) == 4: # bind_dev, ip and packet_size in bytes
    bind_device=sys.argv[1]
    sending_ip=sys.argv[2]
    packet_size=int(sys.argv[3])


for i in range(packet_size):
    packet += 'A'

print("binding to %s - %s" % (bind_device, sending_ip))

# TCP
while True:
    try:
        with socket.socket(socket.AF_INET6, socket.SOCK_STREAM) as s:
            s.setsockopt(socket.SOL_SOCKET, socket.SO_BINDTODEVICE, str(bind_device + '\0').encode('utf-8'))
            s.settimeout(tcp_timeout_seconds)

            s.connect((sending_ip, sending_port))
            # print("Connected")
            #print("BOUND", sending_ip, sending_port)
            #sleep(2)
            while True:
                s.sendall(bytes(packet, encoding='utf-8'))
                sleep(1)
    except Exception as e:
        # print("Connect timeout")
        # print(e)
        sleep(tcp_timeout_seconds)