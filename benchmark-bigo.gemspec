# -*- encoding: utf-8 -*-
# stub: benchmark-bigo 0.0.1.20140808093808 ruby lib

Gem::Specification.new do |s|
  s.name = "benchmark-bigo"
  s.version = "0.0.1.20140808093808"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Davy Stevenson"]
  s.date = "2014-08-08"
  s.description = "Benchmark objects to help calculate Big O behavior"
  s.email = ["davy.stevenson@gmail.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.md"]
  s.files = [".gemtest", "History.txt", "Manifest.txt", "README.md", "Rakefile", "lib/benchmark/bigo.rb", "lib/benchmark/bigo/chart.erb", "lib/benchmark/bigo/job.rb", "lib/benchmark/bigo/report.rb", "test/benchmark/test_bigo.rb"]
  s.homepage = "http://github.com/davy/benchmark-bigo"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--main", "README.md"]
  s.rubygems_version = "2.2.2"
  s.summary = "Benchmark objects to help calculate Big O behavior"
  s.test_files = ["test/benchmark/test_bigo.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<benchmark-ips>, ["~> 2.0"])
      s.add_runtime_dependency(%q<chartkick>, [">= 1.2.4", "~> 1.2"])
      s.add_development_dependency(%q<minitest>, ["~> 5.3"])
      s.add_development_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_development_dependency(%q<hoe>, ["~> 3.12"])
    else
      s.add_dependency(%q<benchmark-ips>, ["~> 2.0"])
      s.add_dependency(%q<chartkick>, [">= 1.2.4", "~> 1.2"])
      s.add_dependency(%q<minitest>, ["~> 5.3"])
      s.add_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_dependency(%q<hoe>, ["~> 3.12"])
    end
  else
    s.add_dependency(%q<benchmark-ips>, ["~> 2.0"])
    s.add_dependency(%q<chartkick>, [">= 1.2.4", "~> 1.2"])
    s.add_dependency(%q<minitest>, ["~> 5.3"])
    s.add_dependency(%q<rdoc>, ["~> 4.0"])
    s.add_dependency(%q<hoe>, ["~> 3.12"])
  end
end
