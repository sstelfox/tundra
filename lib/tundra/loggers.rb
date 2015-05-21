require 'tundra/loggers/memory_logger'
require 'tundra/loggers/null_logger'
require 'tundra/loggers/standard_logger'

module Tundra
  # All logging functionality is handled under this namespace.
  module Loggers
    # A simple mapping between symbolic representations of log level and the
    # associated constants in the native Ruby Logger class.
    LOG_LEVELS = {
      debug:    ::Logger::DEBUG,
      info:     ::Logger::INFO,
      warn:     ::Logger::WARN,
      error:    ::Logger::ERROR,
      fatal:    ::Logger::FATAL,
      unknown:  ::Logger::UNKNOWN
    }

    # The 'progname' value used when printing logs.
    LOG_NAME = 'Tundra'
  end
end
