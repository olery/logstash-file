require File.expand_path('../lib/logstash-file/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'logstash-file'
  gem.version     = LogstashFile::VERSION
  gem.authors     = ['Yorick Peterse']
  gem.summary     = 'Simple file based logging for Logstash.'
  gem.description = gem.summary
  gem.has_rdoc    = 'yard'

  gem.required_ruby_version = '>= 1.9.3'

  gem.files       = `git ls-files`.split("\n").sort
  gem.executables = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files  = gem.files.grep(%r{^(test|spec|features)/})

  gem.add_dependency 'json'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'yard'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'kramdown'
  gem.add_development_dependency 'ci_reporter'
end
