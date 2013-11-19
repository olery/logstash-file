module LogstashFile
  ##
  # The {LogstashFile::Logger} class is a simple Logstash JSON logger with an
  # API similar to the Logger class provided by the Ruby standard library.
  #
  # This logger class internally uses a mutex to synchronize write operations,
  # thus it should be fine to share an instance of this class between multiple
  # threads. Having said that, you might experience a performance bottleneck if
  # you're logging a lot across different threads.
  #
  class Logger
    ##
    # The format used for formatting the times of each log entry.
    #
    # @return [String]
    #
    TIME_FORMAT = '%Y-%m-%dT%H:%M:%S%z'

    ##
    # @param [String|IO] path Path to the file to write logging data to. You
    #  can also supply an IO object to use.
    #
    # @todo Investigate to see if a mutex is really required for write-only
    #  operations.
    #
    def initialize(path)
      @handle = path.respond_to?(:write) ? path : File.open(path, 'a+')
      @mutex  = Mutex.new
    end

    ##
    # Closes the associated stream.
    #
    def close
      @handle.close
    end

    [:info, :error, :warning, :debug].each do |level|
      define_method(level) do |message, fields = {}|
        log(message, fields.merge(:level => level))
      end
    end

    private

    ##
    # @param [String] message The message to log.
    # @param [Hash] fields Extra fields to log.
    #
    def log(message, fields = {})
      time  = Time.now.utc.strftime(TIME_FORMAT)
      entry = {:@timestamp => time, :@fields => fields, :@message => message}

      write(entry)
    end

    ##
    # @param [Hash] hash
    #
    def write(hash)
      @mutex.synchronize do
        @handle.puts(JSON(hash))
        @handle.flush
      end
    end
  end # Logger
end # LogstashFile
