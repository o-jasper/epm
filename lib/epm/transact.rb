#!/usr/bin/env ruby

module EPM
  class Transact
    def initialize recipient, data, settings={}
      @uri       = URI.parse "http://localhost:#{settings['json-port']}"
      @settings  = settings
      @recipient = EPM::HexData.hex_guard recipient
      @data      = EPM::HexData.construct_data data
    end

    def transact
      if @settings['preferred-client'] == 'cpp'
        params = {
          'sec' => @settings["address-private-key"],
          'xValue' => '',
          'aDest' => @recipient,
          'bData' => @data,
          'xGas' => '100000',
          'xGasPrice' => '100000000000000'
        }
        post_body = { 'method' => 'transact', 'params' => params, 'id' => 'epm-rpc', "jsonrpc" => "2.0" }.to_json
      elsif @settings['preferred-client'] == ('go' || 'ethereal')
        params = {
          'recipient' => @recipient,
          'value' => '',
          'gas' => '100000',
          'gasprice' => '100000000000000',
          'body' => @data,
        }
        post_body = { 'method' => 'EthereumApi.Transact', 'params' => params, 'id' => 'epm-rpc', "jsonrpc" => "2.0" }.to_json
      end
      return EPM::Server.http_post_request @uri, post_body
    end
  end
end