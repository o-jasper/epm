#!/usr/bin/env ruby

module Server
  extend self

  def start debug=false
    if debug
      debug = ''
    else
      debug = '>> /dev/null'
    end

    unless is_eth_running?
      case settings['preferred-client']
      when 'cpp'
        server = "#{settings["path-to-eth"]} --json-rpc-port #{settings['json-port']} -r #{settings["remote"]} -d #{settings["directory"]} -m off -l #{settings["eth-listen-port"]} -c #{settings["name"]} -s #{settings["address-private-key"]} #{debug}"
      when 'go'
        server = "#{settings['path-to-go-ethereum']}"
      when 'ethereal'
        server = "#{settings['path-to-ethereal']}"
      end
      pid = spawn server
      sleep 5
    end
    return pid
  end

  def stop
    if is_eth_running?
      processes = eth_processes.map{|e| e.split(' ')[1]}
      processes.each{|p| `kill #{p}`}
    end
  end

  def is_eth_running?
    eth = eth_processes
    return (! eth.empty?)
  end

  def eth_processes
   a = `ps ux`.split("\n").select{|e| e[/eth --json-rpc-port/]}
   # a << `ps ux`.split("\n").select{|e| e[/ethereum/]}
   a << `ps ux`.split("\n").select{|e| e[/ethereal/]}
   a = a.flatten
   return a
  end

  def http_post_request uri, post_body
    http    = Net::HTTP.new uri.host, uri.port
    request = Net::HTTP::Post.new uri.request_uri
    request.content_type = 'application/json'
    request.body = post_body
    return JSON.parse(http.request(request).body)['result']
  end
end

module Settings
  extend self

  def check
    install_setup_file unless have_setup_file
    return load_settings
  end

  def have_setup_file
    settings_file = File.join(ENV['HOME'], '.epm', 'epm-rpc.json')
    File.exists? settings_file
  end

  def install_setup_file
    settings_example = File.join(File.dirname(__FILE__), '..', '..', 'settings', 'epm-rpc.json')
    settings_file = File.join(ENV['HOME'], '.epm', 'epm-rpc.json')
    unless Dir.exists? File.dirname settings_file
      FileUtils.mkdir(File.dirname settings_file)
    end
    FileUtils.cp settings_example, settings_file
  end

  def install_log_file
    log_file = File.join(ENV['HOME'], '.epm', 'deployed-log.csv')
    unless File.exists? log_file
      File.open(log_file, "w") {}
    end
    return log_file
  end

  def load_settings
    settings = JSON.parse(File.read(settings_file))
    log_file = install_log_file
    settings["log_file"] = log_file
    return settings
  end
end

module HexData
  extend self

  def hex_guard data
    if data[0..1] != "0x"
      data = "0x" + data
    end
    return data
  end

  def construct_data deconstructed_data
    data = "0x"
    deconstructed_data.each do |bits|
      if bits[0..1] == "0x"
        piece = bits[2..-1]
        piece = piece.rjust(64,'0')
      else
        piece = bits.unpack('c*').map{|s| s.to_s(16)}.join('')
        piece = piece.ljust(64,'0')
      end
      data << piece
    end
    return data
  end
end