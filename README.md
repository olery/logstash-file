# Logstash File Logger

<a href="http://logstash.net/" title="Logstash">
  <img src="logstash.png" alt="Logstash" align="right">
</a>

The logstash-file Gem is yet another Logstash logger but instead of using a
network transporation layer such as TCP or UDP it writes JSON data to a file.

The LogstashFile::Logger class provides a Logger-like interface by supplying
methods such as `info`, `error`, etc. Unlike the Logger API they take a 2nd
optional argument that can be used to specify custom fields to set in the
logging message. See below for more information.

## Requirements

* Ruby 1.9.3 or newer

## Supported Rubies

* Ruby 1.9.3
* Ruby 2.x
* Jruby 1.7 and newer
* Rubinius 2.0 and newer, 2.1 or newer is recommended

Tests are ran on both Travis CI as well as the private Jenkins instance of
[Olery][olery]. Although this Gem may work on Ruby 1.8 we have not verified
this nor do we intend to.

## Usage

First install the Gem:

    gem install logstash-file

Basic logging is as following:

    require 'logstash-file'

    logger = LogstashFile::Logger.new(STDOUT)

    logger.info("Hello!") # => {"@fields": {"level": "info"}, "@message": "Hello!", "@timestamp": "..."}

    # Logging using custom fields
    logger.info("Hello!", :user => "Alice") # => {"@fields": {"user": "Alice", ...}, ...}

## License

The source code of this repository and logstash-file itself are licensed under
the MIT license unless specified otherwise. A copy of this license can be found
in the file "LICENSE" in the root directory of this repository.

[olery]: http://olery.com/
