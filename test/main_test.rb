# require './lib/main.rb'
require 'minitest/autorun'
require 'minitest/pride'
require 'faraday'

class MainTest < MiniTest::Test

##don't work;hang open forever; and/or getting pipe error

  def test_status_response_sample
    response = Faraday.get('http://127.0.0.1:9292')
    assert_equal 200, response.status
  end

  def test_response_sample
    response = Faraday.get('http://127.0.0.1:9292')
    assert response.body.include?("Path")
  end

  def test_response_to_hello_is_correct
    response = Faraday.get('http://127.0.0.1:9292/hello')
    assert_equal 200, response.status
  end

  def test_response_to_datetime_is_correct
    response = Faraday.get('http://127.0.0.1:9292/datetime')
    assert_equal 200, response.status
  end

  def test_response_to_word_search_is_correct
    response = Faraday.get('http://127.0.0.1:9292/word_search?word=fancy')
    assert_equal 200, response.status
  end

  def test_response_to_start_game_is_correct
    response = Faraday.post('http://127.0.0.1:9292/start_game')
    refute_equal 200, response.status
    assert_equal 301, response.status
    assert_equal response.headers["location"], "http://127.0.0.1:9292/start_game"
    redirect_response = Faraday.get(response.headers["location"])
    assert_equal 200, redirect_response.status
    assert redirect_response.body.include?("Good Luck!")
  end

  def test_response_to_game_is_correct
    response = Faraday.post('http://127.0.0.1:9292/game',{:guess => 6})
    refute_equal 200, response.status
    assert_equal 301, response.status
    assert_equal response.headers["location"], "http://127.0.0.1:9292/game"
    redirect_response = Faraday.get(response.headers["location"])
    assert_equal 200, redirect_response.status
    assert redirect_response.body.include?("1 guesses have been taken")
    assert redirect_response.body.include?("Your guess was 6")
    assert redirect_response.body.include?("Your guess was too high")

    response = Faraday.post('http://127.0.0.1:9292/game',{:guess => 10})
    refute_equal 200, response.status
    assert_equal 301, response.status
    assert_equal response.headers["location"], "http://127.0.0.1:9292/game"
    redirect_response = Faraday.get(response.headers["location"])
    assert_equal 200, redirect_response.status
    assert redirect_response.body.include?("2 guesses have been taken")
    assert redirect_response.body.include?("Your guess was 10")
    assert redirect_response.body.include?("Your guess was too high")

  end

    # As for the broken pipe, that error occurs because the browser forcefully breaks the connection off while read is trying to access data.
    #  http://stackoverflow.com/questions/7540064/simple-http-server-in-ruby-using-tcpserver

end
