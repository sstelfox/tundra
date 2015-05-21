module StatsCollector
  module Loggers
    # The normal logger for this gem, this handles writing all logs to the
    # configured location. For now that's just STDOUT but eventually it will be
    # a configured log location, though I'm not sure how I'm going to handle
    # that yet.
    #
    # @attr_reader [Object#log] :logger Any object implementing the log method,
    #   will be used as the output for all logged messages. Defaults to an
    #   instance of the standard Ruby Logger class.
    class StandardLogger
      # Simple initialization of the standard logger. Just creates the backend
      # logger.
      def initialize
        @logger = ::Logger.new(STDOUT)
      end

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

      # Log the provided message at the provided severity level.
      #
      # @param [Symbol] severity The severity to log the message.
      # @param [String] message The message to get logged.
      def log(severity, message)
        logger.log(severity_lookup(severity), message, APP_LOG_NAME)
      end

      alias_method :add, :log

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

      protected

      attr_reader :logger

      # Given a string or symbol this will lookup the appropriate log level
      # constant matching the name. If the name is invalid it will fallback on
      # the unknown level.
      #
      # @param [String,Symbol] severity The severity to convert to the
      #   appropriate constant.
      # @return [Fixnum] The value of the severity constant.
      def severity_lookup(severity)
        LOG_LEVELS[severity.to_sym] || LOG_LEVELS[:unknown]
      end
    end
  end
end
