module Tundra
  module Loggers
    # This is a sort of meta-logger, allowing other loggers to be added to it.
    # All operations performed on this logger get passed through to all of the
    # loggers that have been added to this chain.
    #
    # Loggers that are added to this are expected to implement #log, #level,
    # and #level= at a minimum.
    class ChainLogger
      include ExceptionLogging
      include LevelShortcuts
      include LogOnce

      # Added the provided logger to the internal list of loggers that will
      # receive copies of any logged messages sent to this logger instance.
      #
      # @param [#log] logger
      def add_logger(logger)
        target_loggers << logger
      end

      # Setup an instance of the ChainLogger class. Defaults to no targetted
      # loggers.
      def initialize
        self.target_loggers = []
        initialize_log_once
      end

      # Returns the lowest log level all loggers can agree to. This can be a
      # bit deceiving as any individual logger may be configured to a more
      # verbose setting. If there are no configured loggers this will return
      # :debug.
      #
      # @return [Symbol]
      def level
        log = target_loggers.sort_by { |logr| LOG_LEVELS[logr.level] }.last
        log ? log.level : :debug
      end

      # Sets the severity log level of all configured loggers.
      #
      # @param [Symbol] severity
      def level=(severity)
        target_loggers.each { |logr| logr.level = severity }
      end

      # Send a log message to all the configured logger endpoints.
      #
      # @param [Symbol] severity
      # @param [String] message
      def log(severity, message)
        target_loggers.each { |logr| logr.log(severity, message) }
      end

      alias_method :add, :log

      protected

      attr_accessor :target_loggers
    end
  end
end
