module Tundra
  module Loggers
    # The normal logger for this gem, this handles writing all logs to the
    # configured location. For now that's just STDOUT but eventually it will be
    # a configured log location, though I'm not sure how I'm going to handle
    # that yet.
    #
    # @!attribute [r] logger
    #   @return [Object#log] Any object implementing the log method, will be
    #     used as the output for all logged messages. Defaults to an instance
    #     of the standard Ruby Logger class.
    class StandardLogger
      include ExceptionLogging
      include LevelShortcuts
      include LogOnce

      # A reverse lookup table from the log level constant to the associated
      # symbol that are easier to work with.
      #
      # @return [Hash<Fixnum=>Symbol>] The reverse lookup table.
      def self.level_lookup
        LOG_LEVELS.invert
      end

      # Given a string or symbol this will lookup the appropriate log level
      # constant matching the name. If the name is invalid it will fallback on
      # the unknown level.
      #
      # @param [String,Symbol] severity The severity to convert to the
      #   appropriate constant.
      # @param [Symbol] fallback In the event the severity provided isn't
      #   value, the fallback value will be used.
      # @return [Fixnum] The value of the severity constant.
      def self.severity_lookup(severity, fallback = :unknown)
        LOG_LEVELS[severity.to_sym] || LOG_LEVELS[fallback]
      end

      # Simple initialization of the standard logger. Just creates the backend
      # logger.
      def initialize
        @logger = ::Logger.new(STDOUT)
        self.level = :info
        initialize_log_once
      end

      # Log the provided message at the provided severity level.
      #
      # @param [Symbol] severity The severity to log the message.
      # @param [String] message The message to get logged.
      def log(severity, message)
        logger.log(self.class.severity_lookup(severity), message, LOG_NAME)
      end

      alias_method :add, :log

      # @!group Configuration

      # Returns the currently configured log level for this instance as a
      # symbol.
      #
      # @return [Symbol]
      def level
        self.class.level_lookup[logger.level]
      end

      # Set the log level output to the provided level. If the new level is
      # invalid it will default to info.
      def level=(new_level)
        logger.level = self.class.severity_lookup(new_level, :info)
      end

      # @!endgroup

      protected

      attr_reader :logger
    end
  end
end
