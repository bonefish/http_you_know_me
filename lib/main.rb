# require 'socket'
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
      request.process_request(connection)

      game = Game.new if request.should_start_a_game

      response = Response.new

      if request.request_type == "POST"
        if request.request_path == "/game"
          # request.content_length(request_hash)
          request.read_body(connection)
          guess = request.find_guess
          game.eval_guess(guess)
          game.record_guess
          game.send_redirect_response(connection, "301 Permanent Redirect", "game")
        else
          game.send_redirect_response(connection, "301 Permanent Redirect", "start_game")
        end

      elsif request.request_path == "/game" && request.request_type == "GET"
        game.send_game_response(connection, game.game_response)

      else
        response.send_response_by_path(connection, request.request_path, request.request_hash, hello_count, request_count)
      end

      hello_count += 1 if request.request_path == "/hello"

      request_count += 1
      server.close_connection
      break if request.request_path == "/shutdown"

    end

  end

end

main = Main.new
main.response_by_paths
