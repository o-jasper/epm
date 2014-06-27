#!/usr/bin/env ruby

# General RPC command handler

module EPM

#  module RPC

    # Returns the default, given other inputs.
    def rpc_default name, arg_name, params
      case arg_name
      when 'aOrigin'
        return (setup)['address-public-key']
      when 'aSender'
        return (params['aOrigin'] or (setup)['address-public-key'])
      when 'xValue', 'bData'
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
        return [["aDest", :a], ["bData", :d],     ["sec", :p],
                ["xGas", :v],  ["xGasPrice", :v], ["xValue", :v]]
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
      url = URI.parse "http://localhost:#{(setup)['json-port']}"
      return EPM::Server.http_post_request url, post_body.to_json
    end
#  end # end RPC
end
