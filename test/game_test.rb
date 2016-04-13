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

  def test_game_in_progress_false_at_initialization
    refute game.game_in_progress
  end

  def test_rand_number_between_1_100_at_initialization
    assert game.correct_number <= 100
    assert game.correct_number >= 1
  end

  def test_start_game_changes_game_in_progress
    assert game.start_game
  end

  def test_end_game_changes_game_in_progress
    game.start_game
    refute game.end_game
  end

  def test_it_evaluates_low_number
    game.correct_number = 6
    assert_equal "low", game.eval_guess(2)
  end

  def test_it_evaluates_high_number
    game.correct_number = 6
    assert_equal "high", game.eval_guess(10)
  end

  def test_it_evaluates_correct_number
    game.correct_number = 6
    assert_equal "correct", game.eval_guess(6)
  end

  def test_game_response_is_correct_for_all_circumstances
    game.num_guess = 4
    game.correct_number = 6

    too_high = "<pre>4 guesses have been taken.\nYour guess was too high.</pre>"
    too_low = "<pre>4 guesses have been taken.\nYour guess was too low.</pre>"
    correct = "<pre>4 guesses have been taken.\nYour guess was correct.</pre>"

    assert_equal too_high, game_response(game.num_guess, game.eval_guess(8))
    assert_equal too_low, game_response(game.num_guess, game.eval_guess(4))
    assert_equal correct, game_response(game.num_guess, game.eval_guess(6))
  end


end
