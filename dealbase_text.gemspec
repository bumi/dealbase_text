# -*- encoding: utf-8 -*-
require File.expand_path('../lib/dealbase_text/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Michael Bumann"]
  gem.email         = ["michael@railslove.com"]
  gem.description   = %q{dealbase text extractor}
  gem.summary       = %q{extracts dealbase related text information from a given text}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "dealbase_text"
  gem.require_paths = ["lib"]
  gem.version       = DealbaseText::VERSION
  gem.add_development_dependency 'rake'
end
