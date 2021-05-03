require 'socket'
require 'test/unit'

class ServerTest < Test::Unit::TestCase
  def test_client_42
    server = TCPSocket.open('yacs.dev', 80)

    request = "GET /customers/42 HTTP/1.1\r\n\r\n\r\n"
    server.puts(request)

    response = ''

    while line = server.gets
      response += line
    end

    assert_equal "HTTP/1.1 200\r\n\r\nHey, 42!\n", response

    server.close
  end
end
