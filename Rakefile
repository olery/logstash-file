require_relative 'lib/logstash-file/version'

require 'bundler/gem_tasks'

Dir['./task/*.rake'].each do |task|
  import(task)
end

task :default => :test
