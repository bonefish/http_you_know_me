require "./lib/request"

class Game

  attr_accessor :num_guess, :game_in_progress, :correct_number, :guess_eval, :last_guess

  def initialize
    @num_guess = 0
    @game_in_progress = true
    @correct_number = rand(1..3)
    @guess_eval = ""
  end

  def end_game
    @game_in_progress = false
  end

  def record_guess
    @num_guess += 1
  end

  def eval_guess(guess) #doing a few different things
    if guess < correct_number
      @guess_eval = "too low"
    elsif guess > correct_number
      @guess_eval = "too high"
    else
      @guess_eval = "correct"
      end_game
    end
    @last_guess = guess
    return @guess_eval
  end

  def game_response
    "<pre>#{num_guess} guesses have been taken.\nYour guess was #{last_guess}.  Your guess was #{@guess_eval}.</pre>"
  end

  def send_game_response(connection, game_response)
    connection.puts headers(output(game_response))
    connection.puts output(game_response)
  end

  def send_redirect_response(connection, type, path)
    connection.puts redirect_headers(output(""), type, path)
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

  def redirect_headers(output, type, path)
    ["http/1.1 #{type}",
      "Location: http://127.0.0.1:9292/#{path}",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1", "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

end
