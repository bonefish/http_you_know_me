require 'socket'
require 'faraday'

class Response

  def hello_response(count)
    "<pre>Hello, World!(#{count})</pre>"
  end

  def diagnostic_response(request_hash)
    "<pre>#{format_diagnostic_response(request_hash)}</pre>"
  end

  def format_diagnostic_response(request_hash)
    diagnostic_string = ""
    request_hash.each do |key, value|
      diagnostic_string = diagnostic_string + key + ": " + value + "\n"
    end
    diagnostic_string
  end

  def send_hello_response(connection, count)
    send_response(connection, hello_response(count))
  end

  def send_diagnostic_response(connection, request_lines)
    send_response(connection, diagnostics_response(request_lines))
  end

  def output_response_by_path(path, hello_count, request_count)
    response = id_response_by_path(path, hello_count, request_count)
  end

  def response_by_path(path, request_hash, hello_count, request_count)
    if path == "/"
      diagnostic_response(request_hash)
    elsif path == "/hello"
      hello_response(hello_count)
    elsif path == "/datetime"
      "<pre>#{Time.now.strftime('%l:%M%p on %A, %B %e, %Y ')}</pre>"
    elsif path == "/shutdown"
      "<pre>Total requests: #{request_count}</pre>"
    else
      "<pre>Invalid Path</pre>"
    end
  end

  def find_path(request_hash)
    request_hash["Path"]
  end

  def send_response(connection, response)
    connection.puts headers(output(response))
    connection.puts output(response)
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

end
