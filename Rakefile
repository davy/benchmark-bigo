require 'rake/testtask'
require 'bundler'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/test_*.rb']
  t.verbose = true
end

Bundler::GemHelper.install_tasks

task default: :test
