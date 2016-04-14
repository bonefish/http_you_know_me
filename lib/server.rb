require 'socket'

class Server

  # attr_reader :tcp_server

  def initialize (port)
    @tcp_server = TCPServer.new(port)
    @connection = nil
  end

  def wait_for_connection
    @connection = @tcp_server.accept
  end

  def close_connection
    @connection.close
  end


end
