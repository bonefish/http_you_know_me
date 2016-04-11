require 'socket'
require 'faraday'

class Server
  def initialize
    @tcp_server = TCPServer.new(9292)
    @connection = nil
  end

  def setup_connection
    @connection = tcp_server.accept
  end

  def close_connection
    @connection = tcp_server.close
  end


end