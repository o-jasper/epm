#!/usr/bin/env ruby

class Compile
  def initialize file, settings={}
    if file
      if File.extname(file) == '.lll'
        return compile_lll settings
      elsif File.extname(file) == ('.mu' || '.mut')
        return compile_mutan settings
      elsif File.extname(file) == ('.se' || '.ser')
        return compile_serpent settings
      end
    end
  end

  def compile_lll settings
    contract = `#{settings["path-to-lllc"]} #{Shellwords.escape(file)}`
    contract.chomp!
    return HexData.hex_guard contract
  end

  def compile_serpent settings
    contract = `#{settings['path-to-serpent']} #{Shellwords.escape(file)}`
    contract.chomp!
    return HexData.hex_guard contract
  end

  def compile_mutan settings
    contract = `#{settings['path-to-mutan']} #{Shellwords.escape(file)}`
    contract.chomp!
    return HexData.hex_guard contract
  end
end