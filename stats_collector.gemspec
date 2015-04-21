# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'stats_collector/version'

Gem::Specification.new do |spec|
  spec.name     = 'stats_collector'
  spec.version  = StatsCollector::VERSION
  spec.authors  = ['Sam Stelfox']
  spec.email    = ['sstelfox@bedroomprogrammers.net']
  spec.files    = `git ls-files`.split("\x0").reject { |f| f =~ %r{^spec\/} }

  spec.summary      = 'A generic stats collector for Ruby profiling'
  spec.description  = spec.summary
  spec.homepage     = 'https://github.com/sstelfox/stats_collector'
  spec.license      = 'MIT'

  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'capybara'

  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'simplecov'

  spec.add_development_dependency 'redcarpet'
  spec.add_development_dependency 'yard'

  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rspec'
end
