require './lib/request.rb'
require 'minitest/autorun'
require 'minitest/pride'
require 'faraday'

class RequestTest < MiniTest::Test
  attr_reader :url, :request_lines, :request

  def setup
    @url = "http://127.0.0.1:9292"
    @request_lines = ["GET / HTTP/1.1", "Host: 127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: no-cache", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36", "Postman-Token: caad7182-899e-751e-acc0-dab87a96eca0", "Accept: */*", "Accept-Encoding: gzip, deflate, sdch", "Accept-Language: en-US,en;q=0.8", "Content-Length: 32"]
    @request = Request.new
  end

  def test_request_hash_is_not_empty
    refute request.make_hash(request_lines).empty?
  end

  def test_request_hash_contains_correct_keys
     expected = ["Verb", "Path", "Protocol", "Host", "Connection", "Cache-Control", "User-Agent", "Postman-Token", "Accept", "Accept-Encoding", "Accept-Language", "Content-Length"]
     assert_equal expected, request.make_hash(request_lines).keys
  end

  def test_request_hash_contains_correct_values
    expected = ["GET", "/", "HTTP/1.1", "127.0.0.1:9292", "keep-alive", "no-cache", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36", "caad7182-899e-751e-acc0-dab87a96eca0", "*/*", "gzip, deflate, sdch", "en-US,en;q=0.8", "32"]

    assert_equal expected, request.make_hash(request_lines).values
  end

  def test_verb_and_path_hash_pair_are_correct
    assert_equal "Verb", request.make_hash(request_lines).key("GET")
    assert_equal "Path", request.make_hash(request_lines).key("/")
  end

  def test_finds_content_length
    assert_equal 32, request.content_length(request.make_hash(request_lines))
  end


end
