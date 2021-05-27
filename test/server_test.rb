require 'socket'
require 'test/unit'

class ServerTest < Test::Unit::TestCase
  def test_client_42
    server = TCPSocket.open('localhost', 80)

    request = "GET /users/42 HTTP/1.1\r\n\r\n"
    server.puts(request)

    response = ''

    while line = server.gets
      response += line
    end

    assert response.match(/HTTP\/1.1 200.*?/)

    server.close
  end
end
