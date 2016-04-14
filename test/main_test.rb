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



    # As for the broken pipe, that error occurs because the browser forcefully breaks the connection off while read is trying to access data.
    #  http://stackoverflow.com/questions/7540064/simple-http-server-in-ruby-using-tcpserver

end
