require 'socket'
require 'faraday'
require './lib/server.rb'
require './lib/request.rb'
require './lib/response.rb'

class Main

  attr_reader :server, :connection

  def initialize
    @server = Server.new
    @connection = server.setup_connection
  end

  def experiment
    request = Request.new
    request.read_request(connection)
    request.display_request
    response = Response.new
    response.build_response(connection, request.request_lines)
    server.close_connection
  end

  def hello_world(count=0)
    while true
      request = Request.new
      request.read_request(connection)
      response = Response.new
      response.hello_world(connection, count)
      server.close_connection
      count +=1
      #counting favicon requests, parse and exclude

    end
  end




end

main = Main.new
main.hello_world
