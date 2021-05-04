require 'socket'

socket = TCPServer.new(80)

loop do
  client = socket.accept
  first_line = client.gets
  verb, path, _ = first_line.split

  if verb == 'GET'
    if result = path.match(/^\/customers\/(.*?)$/)
      client_id = result[1]
      response = "HTTP/1.1 200\r\nContent-Type: text/html\r\n\r\n<h1>Hey, #{client_id}!</h1>"
      client.puts(response)
    end
  end

  client.close
end

socket.close
