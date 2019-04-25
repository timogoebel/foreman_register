# frozen_string_literal: true

require File.expand_path('lib/foreman_register/version', __dir__)

Gem::Specification.new do |s|
  s.name        = 'foreman_register'
  s.version     = ForemanRegister::VERSION
  s.license     = 'GPL-3.0'
  s.authors     = ['Timo Goebel']
  s.email       = ['mail@timogoebel.name']
  s.homepage    = 'https://github.com/timogoebel/foreman_register'
  s.summary     = 'This plugin provides an endpoint that can be used to register an existing host to Foreman.'
  s.description = 'This Foreman plugin provides an endpoint that can be used to register an existing host.'

  s.files = Dir['{app,config,db,lib}/**/*'] + ['LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_development_dependency 'minitest-hooks'
  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'rubocop', '~> 0.67.2'
end
