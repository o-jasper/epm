#!/usr/bin/env ruby

# General RPC command handler

module EPM

  module RPC
    extend self

    # Returns the default, given other inputs.
    def rpc_default name, arg_name, params
      case arg_name
      when 'sec'
        return (EPM::setup)['address-private-key']
      when 'aOrigin'
        return (EPM::setup)['address-public-key']
      when 'aSend'
        return (params['aOrigin'] or (EPM::setup)['address-public-key'])
      when 'xEndowment', 'xValue'
        return '0'
      when 'bData'
        return ''
      when 'xGas'
        return '100000'
      when 'xGasPrice'
        return '100000000000000'
      end
    end
    
    # Returns the argument list under a particular method.
    def rpc_arg_list name
      case name
      when 'transact'
        return [["aDest", :a], ["bData", :d],     ["xValue", :v],
                ["xGas", :v],  ["xGasPrice", :v], ["sec", :p]]
      when 'simCall'
        return [["aDest", :a],   ["bData", :d],
                ["xValue", :v],  ["xGas", :v],  ["xGasPrice", :v],
                ["aOrigin", :a], ["aSend", :a]]
      when 'create'
        return [["bCode", :d], ["sec", :p], ["xEndowment", :v],
                ["xGas", :v], ["xGasPrice", :v]]
      when 'storageAt'
        return [['a', :a], ['x', :i]]
      when 'lll'
        return [['s', :s]]
      when 'balanceAt', 'check', 'isContractAt', 'secretToAddress', 'txCountAt'
        return [['a', :a]]
      when 'block', 'coinbase', 'gasPrice', 'isListening', 'isMining', 
        'key', 'keys', 'lastBlock', 'peerCount', 'procedures'
        return []
      else
        return 'Unknown RPC command.'
      end
    end

    def post_rpc_with_params name, params
      # TODO ethereal compatibility here?
      
      return post_rpc 'method' => name, 'params' => params,
      'id' => 'epm-rpc', 'jsonrpc' => '2.0'
    end
    
    def post_rpc post_body
      url = URI.parse "http://localhost:#{(EPM::setup)['json-port']}"
      return EPM::Server.http_post_request url, post_body.to_json
    end

    # Takes actual option map and argument list to determine `params`.
    def rpc_from_args name, method, args, opt_vals
      params = {}
      for a in method  # Go through all arguments, and use them.(keywords before real)
        val = (opt_vals[a[0]] or args.shift)
        if val != nil && val != ''
          case a[1]  # Respond to kind of parameter.
          when :a, :d, :p, :v, :i
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
  end # end RPC
end
