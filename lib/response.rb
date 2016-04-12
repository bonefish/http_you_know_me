require 'socket'
require 'faraday'

class Response
  # attr_reader :response_count
  #
  # def initialize
  #   @response_count = 0
  # end

  def build_response(connection, request_lines)
    puts "Sending response."
    response = "<pre>" + request_lines.join("\n") + "</pre>"
    output = "<html><head></head><body>#{response}</body></html>"
    headers = ["http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    connection.puts headers
    connection.puts output
  end

  def hello_world(connection, count)
    response = "<pre>Hello, World!(#{count})</pre>"
    output = "<html><head></head><body>#{response}</body></html>"
    headers = ["http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    connection.puts headers
    connection.puts output
    #return response, output, headers #for testing later
  end

  def output_diagnostics(connection, request_lines)
    response =  "<pre>Verb: #{parse_verb(request_lines)}\nPath: #{parse_path(request_lines)}\nProtocol: #{parse_protocol(request_lines)}\nHost: #{parse_host(request_lines)}\nPort: #{parse_port(request_lines)}\nOrigin: #{parse_origin(request_lines)}\nAccept: #{parse_accept(request_lines)}\n</pre>"
    output = "<html><head></head><body>#{response}</body></html>"
    headers = ["http/1.1 200 ok",
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    connection.puts headers
    connection.puts output
  end

  def parse_verb(request_lines)
    request_lines[0].split(" ")[0]
  end

  def parse_path(request_lines)
    request_lines[0].split(" ")[1]
  end

  def parse_protocol(request_lines)
    request_lines[0].split(" ")[2]
  end

  def parse_host(request_lines)
    request_lines[1].split(":")[1].lstrip!
  end

  def parse_port(request_lines)
    request_lines[1].split(":")[2]
  end

  def parse_origin(request_lines)
    request_lines[1].split(":")[1].lstrip!
  end

  def parse_accept(request_lines)
    request_lines[5].split(":")[1].lstrip!
  end



end
