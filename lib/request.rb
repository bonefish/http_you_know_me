require 'socket'
require './lib/server'

class Request

  attr_reader :request_lines, :guess, :body, :request_hash

  def read_request(connection)
    @request_lines = []
    while line = connection.gets and !line.chomp.empty?
      @request_lines << line.chomp
    end
    @request_lines
  end

  def make_hash(request_lines)
    @request_hash = {}
    request_lines.each_with_index do |line, index|
      if index == 0
        split_line = line.split(" ")
        @request_hash["Verb"] = split_line[0]
        @request_hash["Path"] = split_line[1]
        @request_hash["Protocol"] = split_line[2]
      else
        split_line = line.split(":", 2)
        @request_hash[split_line[0]] = split_line[1].lstrip
      end
    end
    @request_hash
  end

  def content_length(request_hash)
    request_hash["Content-Length"].to_i
  end

  def read_body(connection, request_hash)
    @body = connection.read(content_length(request_hash))
  end

  def find_guess
    if @body
      @guess = body.split("=")[1].to_i
    else
      @guess = 0 #could be nil?
    end
  end

end
