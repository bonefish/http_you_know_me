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
    # response = server.connection.gets("http://127.0.0.1:9292")
    # assert response.success?
    assert_equal "127.0.0.1", server.connection.host
    assert_equal 9292, server.connection.port
  end

end
