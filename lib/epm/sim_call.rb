#!/usr/bin/env ruby

module EPM
  class SimCall
    def initialize input, settings
      @uri       = URI.parse "http://localhost:#{settings['json-port']}"
      @input = input
      setup settings
    end

    def sim_call
      pubkey = @settings['address-public-key']
      origin = EPM::HexData.hex_guard (@input[:origin] or pubkey)

      if @settings['preferred-client'] == 'cpp'
        params = {
          'aOrigin' => origin,
          'aSender' => (EPM::HexData.hex_guard (@input[:sender] or origin)),
          'xValue'    => (@input[:value] or '0'),
          'aDest'     => @input[:recipient],
          'bData'     => (@input[:data] or ''),
          'xGas'      => (@input[:gas] or '100000'),
          'xGasPrice' => (@input[:gasprice] or '100000000000000')
        }
        post_body = { 'method' => 'sim_call', 'params' => params, 'id' => 'epm-rpc', "jsonrpc" => "2.0" }.to_json
      end
#      elsif @settings['preferred-client'] == ('go' || 'ethereal')
#        print 'go client not supported yet, does it have a simulated call yet?'
      return EPM::Server.http_post_request @uri, post_body
    end

    def setup settings
      unless settings.empty?
        @settings = settings
      else
        @settings = EPM::Settings.check
      end
    end
  end
end

