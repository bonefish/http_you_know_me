require './lib/response'
require 'minitest/autorun'
require 'minitest/pride'

class ResponseTest < MiniTest::Test

  attr_reader :request_lines, :request_hash, :response

  def setup
    @request_lines = ["GET / HTTP/1.1", "Host: 127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: no-cache", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36", "Postman-Token: caad7182-899e-751e-acc0-dab87a96eca0", "Accept: */*", "Accept-Encoding: gzip, deflate, sdch", "Accept-Language: en-US,en;q=0.8"]

    @request_hash = {"Verb" => "GET", "Path" => "/", "Protocol" => "HTTP/1.1", "Host" => "127.0.0.1:9292"}
      # , "Connection"=> "keep-alive", "Cache-Control:" => "no-cache", "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36", "Postman-Token" => "caad7182-899e-751e-acc0-dab87a96eca0"}

    @response = Response.new
  end

  def test_diagnostic_response_format_is_correct
    expected = "Verb: GET\nPath: /\nProtocol: HTTP/1.1\nHost: 127.0.0.1:9292\n"
    assert_equal expected, response.format_diagnostic_response(request_hash)
  end

  def test_diagnostic_response_is_correct
    expected = "<pre>Verb: GET\nPath: /\nProtocol: HTTP/1.1\nHost: 127.0.0.1:9292\n</pre>"
    assert_equal expected, response.diagnostic_response(request_hash)
  end

  def test_hello_world_response_is_correct
    expected = "<pre>Hello, World!(3)</pre>"
    assert_equal expected, response.hello_response(3)
  end

  def test_response_to_root_is_correct
    expected = "<pre>Verb: GET\nPath: /\nProtocol: HTTP/1.1\nHost: 127.0.0.1:9292\n</pre>"
    assert_equal expected, response.response_by_path("/", request_hash,  0, 0)
  end

  def test_response_to_hello_is_correct
    expected = "<pre>Hello, World!(3)</pre>"
    assert_equal expected, response.response_by_path("/hello", request_hash, 3, 0)
  end

  def test_response_to_date_is_correct
    skip #keep because will fail due to current time
    expected = "<pre>3:43PM on Tuesday, April 12, 2016</pre>"
    assert_equal expected, response.response_by_path("/datetime", request_hash, 3, 0)
  end

  def test_response_to_shutdown_is_correct
    expected = "<pre>Total requests: 12</pre>"
    assert_equal expected, response.response_by_path("/shutdown", request_hash, 3, 12)
  end

  def test_response_to_empty_word_search_is_correct
    path = "/word_search"
    expected = "<pre> is not a known word</pre>"
    assert_equal expected, response.response_by_path(path, request_hash, 3, 0)
  end

  def test_response_to_real_word_search_is_correct
    path = "/word_search?word=fancy"
    expected = "<pre>FANCY is a known word</pre>"
    assert_equal expected, response.response_by_path(path, request_hash, 3, 0)
  end

  def test_response_to_bad_word_search_is_correct
    path = "/word_search?word=fanc"
    expected = "<pre>FANC is not a known word</pre>"
    assert_equal expected, response.response_by_path(path, request_hash, 3, 0)
  end

  def test_it_extracts_word_from_params
    path = "/word_search?word=dog"
    assert_equal "dog", response.extract_word(path)
  end

  def test_it_sends_known_word_response_to_valid
    word = "pizza"
    expected = "<pre>#{word.upcase} is a known word</pre>"
    assert_equal expected, response.word_search_response(word)
  end

  def test_it_sends_unknown_word_response_to_invalid
    word = "piz"
    expected = "<pre>#{word.upcase} is not a known word</pre>"
    assert_equal expected, response.word_search_response(word)
  end




end
