require 'logger'

require 'tundra/loggers'
require 'tundra/ring_buffer'
require 'tundra/version'

# Parent namespace for this codebase, encapsulating everything within this
# module. This parent namespace also contains accessors for singleton instances
# of utility sub-classes.
#
# @!attribute [w] logger
#   @return [Object] Replace the current singleton logger instance for the
#     logger with the provided one.
module Tundra
  # Access the singleton instance of the currently configured logger. If one
  # isn't defined then this will initialize the logger to an appropriate one.
  #
  # @return [Object] An appropriate logger instance.
  def self.logger
    @logger ||= Tundra::Loggers::StandardLogger.new
  end

  class << self
    attr_writer :logger
  end
end
