require './lib/request.rb'
require 'minitest/autorun'
require 'minitest/pride'

class ResponseTest < MiniTest::Test

  def set_up
    @request_lines = ["GET / HTTP/1.1", "Host: 127.0.0.1:9292", "Connection: keep-alive", "Cache-Control: no-cache", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36", "Postman-Token: caad7182-899e-751e-acc0-dab87a96eca0", "Accept: */*", "Accept-Encoding: gzip, deflate, sdch", "Accept-Language: en-US,en;q=0.8"]

  def test_hello_world_response_is_correct

  end


["GET", "/", "HTTP/1.1", "127.0.0.1:9292", "keep-alive", "no-cache", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36", "caad7182-899e-751e-acc0-dab87a96eca0", "*/*", "gzip, deflate, sdch", "en-US,en;q=0.8"]







end
