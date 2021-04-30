require 'socket'
require 'test/unit'

class ServerTest < Test::Unit::TestCase
  def test_hello
    server = TCPSocket.open('yacs.dev', 4242)

    request = 'HELLO from client=42'
    server.puts(request)

    response = server.gets
    assert_equal "HEY, 42!\n", response
  end
end
