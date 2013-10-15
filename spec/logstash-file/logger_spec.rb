require 'spec_helper'

describe LogstashFile::Logger do
  let :buffer do
    StringIO.new
  end

  let :logger do
    LogstashFile::Logger.new(buffer)
  end

  def read_output(buffer)
    buffer.rewind

    return JSON(buffer.read.strip)
  end

  example 'log an info message' do
    logger.info('info message')

    output = read_output(buffer)

    output['@message'].should == 'info message'
    output['@fields'].should  == {'level' => 'info'}

    output.key?('@timestamp').should == true
  end

  example 'add custom fields to a log entry' do
    logger.info('info message', :number => 10)

    output = read_output(buffer)

    output['@fields']['number'].should == 10
  end

  # Half-assed test to ensure that multiple entries are actually written on
  # separate lines. It doesn't *actually* test thread-safety though, that's a
  # pretty difficult thing to test reliably.
  example 'synchronize multi-threaded operations' do
    amount  = 50
    threads = []

    amount.times do |n|
      threads << Thread.new { logger.info("thread #{n}") }
    end

    threads.each(&:join)

    buffer.rewind

    lines = buffer.read.split("\n")

    lines.length.should == amount
  end

  example 'create a logger using a filepath' do
    file   = Tempfile.new('logstash-file')
    logger = LogstashFile::Logger.new(file.path)

    logger.info('testing')
    logger.close

    output = read_output(file)

    output['@message'].should == 'testing'
  end
end
