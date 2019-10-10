import bluetooth
import time
import sys


def server():
    s = bluetooth.BluetoothSocket(bluetooth.RFCOMM)

    server_address = 'B8:27:EB:43:05:5D'
    server_port = 1
    backlog = 1
    size = 1024

    s.bind((server_address, server_port))
    s.listen(backlog)
    try:
        print("Awaiting connection")
        client, clientInfo = s.accept()
        print("Connection established")
		
        while(1):
            j = 0
            msg = ""
            for i in range(1, 100):
                j += 0.1
                msg += str(i) + "," + str(j) + ";"
                time.sleep(0.01)
                if(i%10 == 0):
                    print(msg)
                    msg += "\n"
                    client.send(msg)
                    msg = ""

                if(i == 100):
                    i=0
                    if(j == 100):
                        j=0
				
    except:
        print("Closing socket" + str(sys.exc_info()[1]))
        s.close()

while(1):
    server()