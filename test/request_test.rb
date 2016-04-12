require './lib/request.rb'
require 'minitest/autorun'
require 'minitest/pride'
require 'faraday'

class RequestTest < MiniTest::Test

  def setup
    @url = "http://127.0.0.1:9292"
  end



  def test_response_is_hello_word_0_on_first_gets
    skip
    res = Faraday.get(@url)
    assert_equal "<html><head></head><body><pre>Hello, World!(0)</pre></body></html>", res.body

  end

  def test_response_is_hello_word_2_on_third_gets
    skip
    #program is closing for some reason after first response
    # As for the broken pipe, that error occurs because the browser forcefully breaks the connection off while read is trying to access data.
    # http://stackoverflow.com/questions/7540064/simple-http-server-in-ruby-using-tcpserver

    res1 = Faraday.get(@url)
    res2 = Faraday.get(@url)
    res3 = Faraday.get(@url)
    assert_equal "<html><head></head><body><pre>Hello, World!(2)</pre></body></html>", res3.body
  end


  def test_it_parses_correctly

  end

  def test_response_diagnostic_is_correct
    res = Faraday.get(@url)
    p res
    response =  "<pre>Verb: GET\nPath: /\nProtocol: HTTP/1.1\nHost: 127.0.0.1\nPort:9292\nOrigin: 127.0.0.1\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8\n</pre>"


    assert_equal "<html><head></head><body>#{response}</body></html>", res.body



  end






end
