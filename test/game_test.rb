require './lib/game.rb'
require 'minitest/autorun'
require 'minitest/pride'

class GameTest < MiniTest::Test

  attr_reader :game

  def setup
    @game = Game.new
  end

  def test_num_guesses_is_0_at_initialization
    assert_equal 0, game.num_guess
  end

  def test_game_in_progress_true_at_initialization
    assert game.game_in_progress
  end

  def test_rand_number_between_1_100_at_initialization
    assert game.correct_number <= 100
    assert game.correct_number >= 1
  end

  def test_end_game_changes_game_in_progress
    refute game.end_game
  end

  def test_it_evaluates_low_number
    game.correct_number = 6
    assert_equal "too low", game.eval_guess(2)
  end

  def test_it_evaluates_high_number
    game.correct_number = 6
    assert_equal "too high", game.eval_guess(10)
  end

  def test_it_evaluates_correct_number
    game.correct_number = 6
    assert_equal "correct", game.eval_guess(6)
  end

  def test_guess_eval_set_correctly_for_all_circumstances
    game.num_guess = 4
    game.correct_number = 6
    guess = 2
    game.eval_guess(guess)

    assert_equal "too low", game.eval_guess(guess)

    guess = 10
    game.eval_guess(guess)

    assert_equal "too high", game.eval_guess(guess)

    guess = 6
    game.eval_guess(guess)

    assert_equal "correct", game.eval_guess(guess)

  end

  def test_game_response_is_correct_for_all_circumstances
    game.num_guess = 4
    game.guess_eval = "too_high"

    expected_too_high =  "<pre>4 guesses have been taken.\nYour guess was too high.</pre>"
    expected_too_low = "<pre>4 guesses have been taken.\nYour guess was too low.</pre>"
    expected_correct = "<pre>4 guesses have been taken.\nYour guess was correct.</pre>"

    game.guess_eval = "too low"

    assert_equal expected_too_low, game.game_response

    game.guess_eval = "too high"
    assert_equal expected_too_high, game.game_response

    game.guess_eval = "correct"
    assert_equal expected_correct, game.game_response
  end


end
