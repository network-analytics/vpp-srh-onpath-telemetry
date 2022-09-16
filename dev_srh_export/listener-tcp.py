
import socket
import sys
import threading


device="vpp2host"
listening_ip="2001:f4::1"
listening_port=4001
tcp_timeout_seconds=8

if len(sys.argv) == 3:
    device=sys.argv[1]
    listening_ip=sys.argv[2]

print("TCP: binding to %s - %s" % (device, listening_ip))


def accept_connection(connection):
    # print(connection)
    connection.settimeout(tcp_timeout_seconds)
    while True:
        try:
            data = connection.recv(1024)
            print(data)
            if not data:
                # print("close")
                connection.close()
                break
        except:
            # print("timeout")
            connection.close()
            break

# TCP
with socket.socket(socket.AF_INET6, socket.SOCK_STREAM) as s:
    if not hasattr(socket,'SO_BINDTODEVICE') :
        socket.SO_BINDTODEVICE = 25

    s.setsockopt(socket.SOL_SOCKET, socket.SO_BINDTODEVICE, str(device + '\0').encode('utf-8'))

    s.bind((listening_ip, listening_port))
    s.listen()
    while True:
        conn, addr = s.accept()
        # print('Connected by', addr)

        x = threading.Thread(target=accept_connection, args=(conn,))
        x.start()