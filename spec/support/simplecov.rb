require 'simplecov'

SimpleCov.configure do
  root         File.expand_path('../../../', __FILE__)
  command_name 'rspec'
  project_name 'logstash-file'

  add_filter 'spec'
  add_filter 'lib/logstash-file/version'
end

SimpleCov.start
