require 'socket'
require 'test/unit'

class ServerTest < Test::Unit::TestCase
  def test_hey_42
    server = TCPSocket.open('yacs.dev', 4242)

    request = 'HELLO from client=42'
    server.puts(request)

    response = server.gets
    assert_equal "HEY, 42!\n", response

    server.close
  end

  def test_hey_312
    server = TCPSocket.open('yacs.dev', 4242)

    request = 'HELLO from client=312'
    server.puts(request)

    response = server.gets
    assert_equal "HEY, 312!\n", response

    server.close
  end

  def test_not_found
    server = TCPSocket.open('yacs.dev', 4242)

    request = 'UNKNOWN request'
    server.puts(request)

    response = server.gets
    assert_equal "Not found\n", response

    server.close
  end
end
