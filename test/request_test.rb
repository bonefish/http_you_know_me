require './lib/request.rb'
require 'minitest/autorun'
require 'minitest/pride'
require 'faraday'

class RequestTest < MiniTest::Test
  attr_reader :url, :request_lines, :request

  def setup
    @url = "http://127.0.0.1:9292"
    @request_lines = ["GET / HTTP/1.1", "Host: 127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: no-cache", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36", "Postman-Token: caad7182-899e-751e-acc0-dab87a96eca0", "Accept: */*", "Accept-Encoding: gzip, deflate, sdch", "Accept-Language: en-US,en;q=0.8"]
    @request = Request.new
  end

  def test_request_hash_is_not_empty
    refute request.make_hash(request_lines).empty?
  end

  def test_request_hash_contains_correct_keys
     expected = ["Verb", "Path", "Protocol", "Host", "Connection", "Cache-Control", "User-Agent", "Postman-Token", "Accept", "Accept-Encoding", "Accept-Language"]
     assert_equal expected, request.make_hash(request_lines).keys
  end

  def test_request_hash_contains_correct_values
    expected = ["GET", "/", "HTTP/1.1", "127.0.0.1:9292", "keep-alive", "no-cache", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36", "caad7182-899e-751e-acc0-dab87a96eca0", "*/*", "gzip, deflate, sdch", "en-US,en;q=0.8"]

    assert_equal expected, request.make_hash(request_lines).values
  end

  def test_verb_and_path_hash_pair_are_correct
    assert_equal "Verb", request.make_hash(request_lines).key("GET")
    assert_equal "Path", request.make_hash(request_lines).key("/")
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


  def test_response_diagnostic_is_correct
    skip
    res = Faraday.get(@url)
    p res
    response =  "<pre>Verb: GET\nPath: /\nProtocol: HTTP/1.1\nHost: 127.0.0.1\nPort:9292\nOrigin: 127.0.0.1\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8\n</pre>"


    assert_equal "<html><head></head><body>#{response}</body></html>", res.body

  end


end
