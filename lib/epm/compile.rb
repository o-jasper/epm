#!/usr/bin/env ruby

module EPM
  class Compile
    def initialize file, settings={}
      @file     = EPM::FileHelpers.file_guard file
      @settings = settings
    end

    def compile
      if @file
        if File.extname(@file) == '.lll'
          return compile_lll
        elsif File.extname(@file) == ('.mu' || '.mut')
          return compile_mutan
        elsif File.extname(@file) == ('.se' || '.ser')
          return compile_serpent
        end
      end
    end

    def compile_lll
      contract = `#{@settings["path-to-lllc"]} #{@file}`
      contract.chomp!
      contract = EPM::HexData.hex_guard contract
      return contract
    end

    def compile_serpent
      contract = `#{@settings['path-to-serpent']} #{Shellwords.escape(@file)}`
      contract.chomp!
      return EPM::HexData.hex_guard contract
    end

    def compile_mutan
      contract = `#{@settings['path-to-mutan']} #{Shellwords.escape(@file)}`
      contract.chomp!
      return EPM::HexData.hex_guard contract
    end
  end
end