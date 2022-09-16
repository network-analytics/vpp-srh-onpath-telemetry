import socket
import sys


device="vpp2host"
listening_ip="2001:f4::1"
listening_port=4001

if len(sys.argv) == 3:
    device=sys.argv[1]
    listening_ip=sys.argv[2]

print("UDP: binding to %s - %s" % (device, listening_ip))

# UDP
with socket.socket(socket.AF_INET6, socket.SOCK_DGRAM) as s:
    if not hasattr(socket,'SO_BINDTODEVICE') :
        socket.SO_BINDTODEVICE = 25

    s.setsockopt(socket.SOL_SOCKET, socket.SO_BINDTODEVICE, str(device + '\0').encode('utf-8'))

    s.bind((listening_ip, listening_port))

    while True:
        message, address = s.recvfrom(1024)
        # message = message.decode('utf-8')
        print(message)

