#  encoding: utf-8
require File.expand_path('../lib/benchmark/bigo/version', __FILE__)

Gem::Specification.new do |s|
  s.name    = 'benchmark-bigo'
  s.version = Benchmark::BigO::VERSION

  s.authors  = ['Davy Stevenson']
  s.email    = ['davy.stevenson@gmail.com']
  s.homepage = 'http://github.com/davy/benchmark-bigo'
  s.licenses = ['MIT']

  s.summary     = 'Benchmark objects to help calculate Big O behavior'
  s.description = 'Benchmark objects to help calculate Big O behavior'

  s.require_paths    = ['lib']
  s.files            = Dir['lib/**/*.rb']
  s.extra_rdoc_files = ['README.md']
  s.rdoc_options     = ['--main', 'README.md']
  s.test_files       = Dir['test/**/*.rb']

  s.add_runtime_dependency 'benchmark-ips', '~> 2.0'
  s.add_runtime_dependency 'chartkick',     '~> 1.2'

  s.add_development_dependency 'minitest',  '~> 5.3'
  s.add_development_dependency 'rdoc',      '~> 4.0'
  s.add_development_dependency 'rake'
end
