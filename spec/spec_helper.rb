require 'rspec'
require 'stringio'
require 'tempfile'

require_relative 'support/simplecov' if ENV['COVERAGE']
require_relative '../lib/logstash-file'

RSpec.configure do |config|
  config.color = true

  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end
