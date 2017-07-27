# -*- encoding: utf-8 -*-
$:.unshift File.expand_path("../lib", __FILE__)
require "hammer_cli_experimental/version"

Gem::Specification.new do |s|

  s.name          = "hammer_cli_experimental"
  s.version       = HammerCLIExperimental.version.dup
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Tomáš Strachota"]
  s.email         = "tstracho@redhat.com"
  s.homepage      = "http://github.com/tstrachota/hammer-cli-experimental"
  s.license       = "GPL v3+"

  s.summary       = %q{Experimental extensions for Hammer CLI}
  s.description   = <<EOF
Experimental extensions for Hammer CLI
EOF

  s.files            = Dir['{lib,doc,test,locale,config}/**/*', 'README*']
  s.test_files       = Dir['{test}/**/*']
  s.extra_rdoc_files = Dir['{doc}/**/*', 'README*']
  s.require_paths = ["lib"]

  s.add_dependency 'hammer_cli', '>= 0.4.0'
  s.add_dependency 'colorize'
  s.add_dependency 'pry'
  s.add_dependency 'pry-byebug'
end
