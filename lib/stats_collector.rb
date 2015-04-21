require 'logger'

require 'stats_collector/loggers'
require 'stats_collector/version'

# Parent namespace for this codebase, encapsulating everything within this
# module. This parent namespace also contains accessors for singleton instances
# of utility sub-classes.
module StatsCollector
  # Access the singleton instance of the currently configured logger. If one
  # isn't defined then this will initialize the logger to an appropriate one.
  #
  # @return [Object] An appropriate logger instance.
  def self.logger
    @logger ||= StatsCollector::Loggers::StandardLogger.new
  end

  # Replace the current singleton instance for the logger with the provided
  # one.
  #
  # @param [Object] An appropriate logger instance.
  def self.logger=(logger)
    @logger = logger
  end
end
