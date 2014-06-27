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

  def rpc_from_args name, method, args, opts
    params = {}
    for a in method  # Go through all arguments, and use them.(keywords before real)
      val = (opts.send(a[0]) or args.shift)
      if val != nil && val != ''
        case a[1]  # Respond to kind of parameter.
        when :d, :p, :v, :i
          params[a[0]] = val
        when :a
          params[a[0]] = (EPM::HexData.hex_guard val)
        else
          raise 'Unidentified kind of data'
        end
      else
        params[a[0]] = rpc_default(name, a[0], params)
      end
    end
    return params
  end

  def rpc args, opts
    name = args.shift
    arg_list = rpc_arg_list name
    return post_rpc_with_params name, (rpc_from_args name, arg_list, args, opts)
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
