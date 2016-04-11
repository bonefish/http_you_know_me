require 'socket'
require 'faraday'

class WebServer

  attr_reader :tcp_server, :connection, :request_lines

  def initialize
    @tcp_server = TCPServer.new(9292)
    @connection = nil
  end

  def setup_connection
    @connection = tcp_server.accept
    # @connection = Faraday.new(:url => "http://127.0.0.1:9292")
  end

  def close_connection
    @connection = tcp_server.close
  end

  def read_request
    puts "Ready for a request"
    @request_lines = []
    while line = connection.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
  end

  def display_request
    puts "Got this request:"
    puts request_lines.inspect
  end

  def build_response
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

end

server = WebServer.new
server.setup_connection
server.read_request
server.display_request
server.build_response
server.close_connection
