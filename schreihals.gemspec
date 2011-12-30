# -*- encoding: utf-8 -*-
require File.expand_path('../lib/schreihals/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Hendrik Mans"]
  gem.email         = ["hendrik@mans.de"]
  gem.description   = %q{A simple blog engine for hackers.}
  gem.summary       = %q{A simple blog engine for hackers.}
  gem.homepage      = "http://hmans.net"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "schreihals"
  gem.require_paths = ["lib"]
  gem.version       = Schreihals::VERSION

  gem.add_dependency 'rack', '~> 1.4.0'
  gem.add_dependency 'sinatra', '~> 1.3.2'
  gem.add_dependency 'activesupport'
  gem.add_dependency 'shotgun'
  gem.add_dependency 'haml'
  gem.add_dependency 'sass'
  gem.add_dependency 'document_mapper'
  gem.add_dependency 'coderay'
  gem.add_dependency 'redcarpet'
  gem.add_dependency 'rack-cache'
  gem.add_dependency 'rack-codehighlighter'
  gem.add_dependency 'schnitzelstyle', '>= 0.0.1'
  gem.add_dependency 'nokogiri'
  gem.add_dependency 'thor'

  gem.add_development_dependency 'rspec', '>= 2.0.0'
  gem.add_development_dependency 'watchr'
end
