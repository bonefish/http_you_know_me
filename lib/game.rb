require "./lib/request"

class Game

  attr_accessor :num_guess, :game_in_progress, :correct_number

  def initialize
    @num_guess = 0
    @game_in_progress = false
    @correct_number = rand(1..100)
  end

  def start_game
    game_in_progress = true
  end

  def end_game
    game_in_progress = false
  end

  def record_guess
    num_guess += 1
  end

  def eval_guess(guess) #pass in: request.find_guess
    if guess < correct_number
      "low"
    elsif guess > correct_number
      "high"
    else
      "correct"
    end
  end

end
