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
      # Simple initialization of the standard logger. Just creates the backend
      # logger.
      def initialize
        @logger = ::Logger.new(STDOUT)
        self.level = :info
      end

      # Log the provided message at the provided severity level.
      #
      # @param [Symbol] severity The severity to log the message.
      # @param [String] message The message to get logged.
      def log(severity, message)
        logger.log(severity_lookup(severity), message, LOG_NAME)
      end

      alias_method :add, :log

      # @!group Configuration

      # Returns the currently configured log level for this instance as a
      # symbol.
      #
      # @return [Symbol]
      def level
        level_lookup[logger.level]
      end

      # Set the log level output to the provided level. If the new level is
      # invalid it will default to info.
      def level=(new_level)
        logger.level = severity_lookup(new_level, :info)
      end

      # @!endgroup
      # @!group Log Shortcut Methods

      # Log the provided message at the debug level.
      #
      # @param [String] message The message to get logged.
      def debug(message)
        log(:debug, message)
      end

      # Log the provided message at the error level.
      #
      # @param [String] message The message to get logged.
      def error(message)
        log(:error, message)
      end

      # Log the provided message at the fatal level.
      #
      # @param [String] message The message to get logged.
      def fatal(message)
        log(:fatal, message)
      end

      # Log the provided message at the info level.
      #
      # @param [String] message The message to get logged.
      def info(message)
        log(:info, message)
      end

      # Log the provided message at the unknown level.
      #
      # @param [String] message The message to get logged.
      def unknown(message)
        log(:unknown, message)
      end

      # Log the provided message at the warning level.
      #
      # @param [String] message The message to get logged.
      def warn(message)
        log(:warn, message)
      end

      # @!endgroup

      protected

      attr_reader :logger

      # A reverse lookup table from the log level constant to the associated
      # symbol that are easier to work with.
      #
      # @return [Hash<Fixnum=>Symbol>] The reverse lookup table.
      def level_lookup
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
      def severity_lookup(severity, fallback = :unknown)
        LOG_LEVELS[severity.to_sym] || LOG_LEVELS[fallback]
      end
    end
  end
end