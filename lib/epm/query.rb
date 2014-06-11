#!/usr/bin/env ruby

module EPM
  class Query
    def initialize address, position, settings={}
      @uri      = URI.parse "http://localhost:#{settings['json-port']}"
      @settings = settings
      @address  = EPM::HexData.hex_guard address
      @position = EPM::HexData.hex_guard position
    end

    def query
      if @settings['preferred-client'] == 'cpp'
        params = {
          'a' => @address,
          'x' => @position
        }
        post_body = { 'method' => 'storageAt', 'params' => params, 'id' => 'epm-rpc', "jsonrpc" => "2.0" }.to_json
      elsif @settings['preferred-client'] == ('go' || 'ethereal')
        params = {
          'address' => @address,
          'key' => @position
        }
        post_body = { 'method' => 'EthereumApi.GetStorageAt', 'params' => params, 'id' => 'epm-rpc', "jsonrpc" => "2.0" }.to_json
      end
      return EPM::Server.http_post_request @uri, post_body
    end
  end
end