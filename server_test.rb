require 'socket'
require 'test/unit'

class ServerTest < Test::Unit::TestCase
  def test_client_42
    server = TCPSocket.open('yacs.dev', 80)

    request = "GET /customers/42 HTTP/1.1\r\nAccept: text/html\r\n\r\n"
    server.puts(request)

    response = ''

    while line = server.gets
      response += line
    end

    assert_equal "HTTP/1.1 200\r\nContent-Type: text/html\r\n\r\n<h1>Hey, 42!</h1>\n", response

    server.close
  end
end
