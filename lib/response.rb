# require 'socket'
require './lib/word_search'
require './lib/game'
require 'pry'

class Response

  def response_by_path(path, request_hash, hello_count, request_count)
    if request_hash["Verb"] == "GET"
      if path == "/"
        diagnostic_response(request_hash)
      elsif path == "/hello"
        hello_response(hello_count)
      elsif path == "/datetime"
        "<pre>#{Time.now.strftime('%l:%M%p on %A, %B %e, %Y ')}</pre>"
      elsif path == "/shutdown"
        "<pre>Total requests: #{request_count}</pre>"
      elsif path && path.include?("/word_search")
        word_search_response(extract_word(path))
      elsif path == "/start_game"
        "Good Luck!"
      elsif path == "/game"
        return
      else
        "<pre>Invalid Path</pre>"
      end
    end
  end

  def hello_response(count)
    "<pre>Hello, World!(#{count})</pre>"
  end

  def diagnostic_response(request_hash)
    "<pre>#{format_diagnostic_response(request_hash)}</pre>"
  end

  def word_search_response(word)
    word_search = WordSearch.new
    if word_search.valid_word?(word)
      "<pre>#{word.upcase} is a known word</pre>"
    else
      "<pre>#{word.upcase} is not a known word</pre>"
    end
  end

  def send_response_by_path(connection, path, request_hash, hello_count, request_count)
    # binding.pry
    send_response(connection, response_by_path(path, request_hash, hello_count, request_count))
  end

  def extract_word(path)
    split = path.split("=")
    if split[1]
      word = split[1]
    else
      word = ""
    end
  end

  def send_response(connection, response)
    output = output(response)
    connection.puts headers(output)
    connection.puts output
    # puts headers(output)
    # puts output
  end

  def output(response)
    "<html><head></head><body>#{response}</body></html>"
  end

  def headers(output)
    ["http/1.1 200 ok",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def format_diagnostic_response(request_hash)
    diagnostic_string = ""
    request_hash.each do |key, value|
      diagnostic_string = diagnostic_string + key + ": " + value + "\n"
    end
    diagnostic_string
  end

end
