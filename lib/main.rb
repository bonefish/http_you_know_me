require 'socket'
require 'pry'
require './lib/server.rb'
require './lib/request.rb'
require './lib/response.rb'

class Main

  attr_reader :server

  def initialize
    @server = Server.new(9292)
  end

  def response_by_paths(hello_count=0, request_count=0)

    while true
      connection = server.wait_for_connection

      request = Request.new

      request_lines = request.read_request(connection)
      request_hash = request.make_hash(request_lines)
      request_path = request_hash["Path"]
      request_type = request_hash["Verb"]

      if request_path == "/start_game"
        game= Game.new
      end

      response = Response.new

      if request_type == "POST"
        if request_path == "/game"
          request.content_length(request_hash)
          request.read_body(connection, request_hash)
          guess = request.find_guess
          game.eval_guess(guess)
          game.record_guess
          game.send_redirect_response(connection, "301 Permanent Redirect", "game")
        else
          game.send_redirect_response(connection, "301 Permanent Redirect", "start_game")
        end

      elsif request_path == "/game" && request_hash["Verb"] == "GET"
        game.send_game_response(connection, game.game_response)

      else
        response.send_response_by_path(connection, request_path, request_hash, hello_count, request_count)
      end

      hello_count += 1 if request_path == "/hello"

      request_count += 1
      server.close_connection
      return if request_path == "/shutdown"

    end

  end

end

main = Main.new
main.response_by_paths
