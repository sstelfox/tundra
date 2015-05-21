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
      def initialize
        @logger = ::Logger.new(STDOUT)
      end

      def debug(message)
        log(:debug, message)
      end

      def error(message)
        log(:error, message)
      end

      def fatal(message)
        log(:fatal, message)
      end

      def info(message)
        log(:info, message)
      end

      def log(severity, message)
        logger.log(severity_lookup(severity), message, APP_LOG_NAME)
      end

      alias_method :add, :log

      def severity_lookup(severity)
        LOG_LEVELS[severity.to_sym] || LOG_LEVELS[:unknown]
      end

      def unknown(message)
        log(:unknown, message)
      end

      def warn(message)
        log(:warn, message)
      end

      protected

      attr_reader :logger
    end
  end
end
