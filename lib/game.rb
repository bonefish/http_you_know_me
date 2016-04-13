require "./lib/request"

class Game

  attr_accessor :num_guess, :game_in_progress, :correct_number

  def initialize
    @num_guess = 0
    @game_in_progress = true #remember to change tests
    @correct_number = rand(1..100)
  end

  # def start_game
  #   game_in_progress = true
  # end

  def end_game
    game_in_progress = false
  end



  def record_guess
    num_guess += 1
  end

  def eval_guess(guess)
    if guess < correct_number
      "too low"
    elsif guess > correct_number
      "too high"
    else
      "correct"
    end
  end

  def game_response(num_guess, guess_eval) #guess
    "<pre>#{num_guess} guesses have been taken.\nYour guess was #{guess_eval}.</pre>"
  end

  def send_game_response(connection, game_response)
    connection.puts headers(output(game_response))
    connection.puts output(game_response)
  end

  def send_redirect_response(connection)
    connection.puts redirect_headers(output(""))
    connection.puts output("")
  end

  def output(response)
    "<html><head></head><body>#{response}</body></html>"
  end

  def headers(output)
    ["http/1.1 200 ok",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def redirect_headers(output)
    ["http/1.1 302",
      "Location: http://127.0.0.1/game",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

end
