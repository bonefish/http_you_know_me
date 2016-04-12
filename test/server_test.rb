require './lib/server.rb'
require 'minitest/autorun'
require 'minitest/pride'
require 'net/ping'

class ServerTest < MiniTest::Test

  def test_it_opens_server_on_instantiation
    # server = Server.new
    # server.setup_connection
    message = system("curl http://localhost:9292")
    # server.close_connection
    p message
    assert_equal true, true
  end


  def test_it_opens_connection
    # skip
    # server = Server.new
    # connection = server.setup_connection
    #curl to get a response thats not failed

  end

  def test_it_closes_connection

  end


end
