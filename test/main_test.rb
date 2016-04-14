require './lib/main.rb'
require 'minitest/autorun'
require 'minitest/pride'
require 'faraday'

class MainTest < MiniTest::Test

  def test_status_response_sample
    response = Faraday.get('http://127.0.0.1:9292')
    assert_equal 200, response.status
  end

  def test_response_sample
    response = Faraday.get('http://127.0.0.1:9292')
    assert response.body.include?("Path")
  end

end
