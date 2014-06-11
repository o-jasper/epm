#!/usr/bin/env ruby
require 'epm.rb'

args = ARGV
command = ARGV.shift

case command
when 'start'
  EPM.start
when 'stop'
  EPM.stop
when 'restart'
  EPM.restart
when 'compile'
  result = EPM.compile args
  result.each{|l| print l + "\n"}
when 'create'
  result = EPM.create args
  result.each{|l| print l + "\n"}
when 'deploy'
  result = EPM.deploy args
  result.each{|l| print l + "\n"}
when 'transact'
  EPM.transact args
when 'query'
  print EPM.query(args) + "\n"
end