"""
    Author: Leonardo Rossi Leao
    Date: January 30th, 2024
    Description: Emulate a TCP client to test communication with
    TCP server emulator.
"""

import socket
import numpy as np

class TCPClient:


    def __init__(self, host: str, port: int) -> None:

        """
        Constructor method for TCPClient class.

        Args:
            host (str): IP address of the server.
            port (int): Port number of the server.
        """

        self.host = host
        self.port = port
        self.is_connected = False

        # Instantiate a socket object and connect it to the server.
        try:
            self.client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            self.client.connect((self.host, self.port))
            self.is_connected = True
            print(f"Connected to {self.host}:{self.port}")
        except ConnectionRefusedError:
            print("Connection refused. Check if the server is running.")

    
    def send(self, message: str) -> str:

        """
        Method to send a message to the server.

        Args:
            message (str): Message to be sent to the server.

        Returns:
            str: Response from the server.
        """

        self.client.sendall(message.encode("utf-8"))

    
    def read(self) -> str:

        print("Waiting for response...")
        
        response = ""
        while response == "" or response[-1] != "\r":
            response += self.client.recv(1).decode("utf-8")
            
        return response
    
    def readFloatSequence(self) -> float:

        response = []
        while response == [] or response[-1] != "\r":
            response.append(self.client.recv(1))
            if len(response) == 4:
                data_bytes = np.array(response, dtype=np.uint8)
                data_as_float = data_bytes.view(dtype=np.float32)
                print(data_as_float)
                response = []
    

    def close(self) -> None:

        """
        Method to close the connection with the server.
        """

        self.client.close()


if __name__ == "__main__":
    client = TCPClient("10.31.24.28", 1001)
    if client.is_connected:
        
        message = ""
        while message != "exit\r":
            message = input("Enter a message: ")
            client.send(message + "\r")
        client.close()
