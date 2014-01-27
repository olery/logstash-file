# encoding: UTF-8

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
  # separate lines.
  example 'synchronize multi-threaded operations' do
    amount  = 50
    threads = []

    # Create the logger before using it amongst the different threads. Without
    # doing so we'd also have to wrap a mutex around the `let` block access.
    logger = self.logger

    amount.times do |n|
      thread = Thread.new { logger.info("thread #{n}") }

      thread.abort_on_exception = true

      threads << thread
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

  example 'writing UTF8 data' do
    logger.info('helló'.force_encoding(Encoding::UTF_8))

    output = read_output(buffer)

    output['@message'].should == 'helló'
  end
end
