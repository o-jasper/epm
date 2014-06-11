# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'epm/version'

Gem::Specification.new do |s|
  s.name              = "epm"
  s.version           = VERSION
  s.platform          = Gem::Platform::RUBY
  s.summary           = "Ethereum Contracts Package Manager."
  s.homepage          = "https://github.com/ethereum-package-manager/epm"
  s.authors           = [ "Casey Kuhlman" ]
  s.email             = "caseykuhlman@watershedlegal.com"

  s.date              = Time.now.strftime('%Y-%m-%d')
  s.has_rdoc          = false

  s.files             = `git ls-files`.split($/)
  s.executables       = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files        = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths     = ["lib"]

  s.add_dependency    "commander", "~> 4.1.6"

  s.description       = <<desc
  This gem is designed to assist in distribution, dissemination, compilation, and deployment of Ethereum contracts.
desc
end