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
      request_hash = request.make_hash
      request_path = request_hash["Path"]

      if request_path == "/start_game"
        game= Game.new
      end

      response = Response.new

      if request_hash["Verb"] == "POST"
        request.content_length
        request.read_body(connection)
        game.send_redirect_response(connection)
      end

      response.output_response_by_path(connection, request_path, request_hash, hello_count, request_count)



      if request_path == "/game" && request_hash["Verb"] == "GET"
        guess = request.find_guess
        game_response = game.game_response(game.num_guess, game.eval_guess(guess))
        game.send_game_response(connection, game_response)
      end

      hello_count += 1 if request_path == "/hello"
      request_count +=1
      return false if request_path == "/shutdown"
    end
    server.close_connection
  end

end

main = Main.new
main.response_by_paths
