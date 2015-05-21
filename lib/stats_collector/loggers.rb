require 'stats_collector/loggers/null_logger'
require 'stats_collector/loggers/standard_logger'

module StatsCollector
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
    LOG_NAME = 'StatsCollector'
  end
end