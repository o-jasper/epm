#!/usr/bin/env ruby
require ('./epm.rb')

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
  EPM.compile args
when 'create'
  EPM.create args
when 'deploy'
  EPM.deploy args
when 'transact'
  EPM.transact args
when 'query'
  EPM.query args
end