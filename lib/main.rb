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
    response.send_experiment_response(connection, request.request_lines)
    server.close_connection
  end

  def hello_world_main(count=0)
    while true
      request = Request.new
      request.read_request(connection)
      response = Response.new
      response.send_hello_response(connection, count)
      server.close_connection #why close it? works with or without it
      count +=1
      #counting favicon requests, parse and exclude in future
    end
    #how do we stop loop on closing server
  end

  def output_diagnostics_main
    request = Request.new
    request.read_request(connection)
    request.display_request
    response = Response.new
    response.send_diagnostic_response(connection, request.request_lines)
    server.close_connection
  end

  def response_by_paths(hello_count=0, request_count=0)
    while true
      request = Request.new
      request.read_request(connection)
      request_hash = request.make_hash(request.request_lines)
      request_path = request_hash["Path"]
      response = Response.new
      response.output_response_by_path(connection, request_path, request_hash, hello_count, request_count)
      hello_count += 1 if request_path == "/hello"
      request_count +=1
      return false if request_path == "/shutdown"
    end
    server.close_connection
  end

end

main = Main.new
main.response_by_paths
