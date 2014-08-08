# -*- ruby -*-

require "rubygems"
require "hoe"

Hoe.plugin :minitest
Hoe.plugin :gemspec

Hoe.spec "benchmark-bigo" do

  developer("Davy Stevenson", "davy.stevenson@gmail.com")

  extra_deps << ["benchmark-ips", '~> 2.0']
  extra_deps << ["chartkick", '~> 1.2', '>= 1.2.4']

  self.readme_file = 'README.md'

  license "MIT" # this should match the license in the README
end

# vim: syntax=ruby
