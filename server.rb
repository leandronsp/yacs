require 'socket'

socket = TCPServer.new(4242)

client = socket.accept
request = client.gets

response = 'HEY, 42!'
client.puts(response)

client.close
socket.close
