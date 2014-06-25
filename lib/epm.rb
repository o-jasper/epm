#!/usr/bin/env ruby
# std_lib
require 'fileutils'
require 'tempfile'
require 'shellwords'
require 'json'
require 'net/http'
require 'uri'
require 'optparse'

# this gem
Dir[File.dirname(__FILE__) + '/epm/*.rb'].each {|file| require file }

module EPM
  extend self

  def compile args
    output = []
    until args.empty?
      file = args.shift
      settings = setup
      output << EPM::Compile.new(file, settings).compile
    end
    output
  end

  def create args
    output = []
    until args.empty?
      file = args.shift
      settings = setup
      output << EPM::Create.new(file, settings).deploy
    end
    output
  end

  def deploy args
    file     = args.shift
    settings = setup
    output   = EPM::Deploy.new(file, settings).deploy_package
  end

  def transact args
    recipient = args.shift
    data = args
    settings = setup
    EPM::Transact.new(recipient, data, settings).transact
  end

  def query args
    address = args.shift
    position = args.shift
    settings = setup
    EPM::Query.new(address, position, settings).query
  end

  def sim args, opts  # TODO
    input = {
      :origin => opts.sender,
      :sender => opts.sender,
      :recipient => args.shift, 
      :value => opts.value,
      :data => args.shift,
      :gas => opts.gas,
      :gasprice => opts.gasprice
    }
    settings = setup
    EPM::SimCall.new(input, settings).sim_call
  end

  def version
    return VERSION
  end

  def start
    EPM::Server.start
  end

  def stop
    EPM::Server.stop
  end

  def restart
    EPM::Server.stop
    EPM::Server.start
  end

  def setup
    return EPM::Settings.check
  end
end
