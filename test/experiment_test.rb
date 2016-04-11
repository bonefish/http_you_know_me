require_relative 'experiment'
require 'minitest/autorun'
require 'minitest/pride'

class WebServerTest < MiniTest::Test

  def test_server_at_port_9292
    skip
    #cannot figure out how to test a server?
    server = WebServer.new
    server.setup_connection
    assert_equal 9292, server.port
  end

  def test_response
    server = WebServer.new
    server.setup_connection
    server.read_request
    # assert_equal "GET / HTTP/1.1", server.request_lines[0]
    assert_equal "Host: localhost:9292", server.request_lines[1]


  end

end
