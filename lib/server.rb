require 'socket'

socket = TCPServer.new(80)

def search_form_view
  File.read('./lib/views/search/form.html')
end

loop do
  client        = socket.accept
  first_line = client.gets

  request = ''

  while line = client.gets
    break if line == "\r\n"
    request += line
  end

  puts first_line
  puts request
  puts

  verb, path, _ = first_line.split(' ')

  if verb == 'GET' && path == '/'
    client.puts("HTTP/1.1 200\r\nContent-Type: text/html\r\n\r\n#{search_form_view}")
  elsif verb == 'POST' && path == '/login'
    client.puts("HTTP/1.1 301\r\nLocation: http://10.10.10.42:8080/\r\nSet-Cookie: email=live@example.com; path=/; HttpOnly\r\n")
  else
    client.puts("HTTP/1.1 404\r\nContent-Type: text/html\r\n\r\n<p>Not Found</p>")
  end

  client.close
end
