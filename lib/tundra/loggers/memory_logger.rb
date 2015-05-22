module Tundra
  module Loggers
    # An in memory ring buffer based logger. This is useful for collecting and
    # containing a limited number of messages in memory before the program has
    # a chance to configure a more useful logger. At that point the messages
    # can be dumped into other logger.
    #
    # This logger doesn't support configuring a log level as the assumption is
    # this will be used before we're able to retrieve any user specified
    # configuration. Once a proper logger has been configured, it can handle
    # filtering the appropriate messages based on it's configured level.
    #
    # @!attribute [rw] messages
    #   @return [Array<Array(Symbol, String)>] List of backlogged messages.
    class MemoryLogger
      include ExceptionLogging
      include LevelShortcuts

      # Takes a logger and logs all the stored messages to the provided logger
      # instance. Once it's done dumping it empties the internal buffer to
      # prevent them from being logged again.
      #
      # @param [#log] logger The logger instance to dump to.
      def dump_to_logger(logger)
        messages.each { |severity, message| logger.log(severity, message) }
        messages.clear!
      end

      # Initialize an instance of a MemoryLogger
      def initialize
        self.messages = RingBuffer.new(LOG_MEMORY_RING_SIZE)
      end

      # No Op, only here to maintain API compatibility with all the other
      # loggers. Effectively this logger always operated in 'debug' mode so it
      # will respond as such.
      #
      # @param [Array<Object>] _args Unused
      # @return [:debug]
      def level(*_args)
        :debug
      end

      alias_method :level=, :level

      # Store the severity and message of the provided information for future
      # logging.
      #
      # @param [Symbol] severity The severity to log the message.
      # @param [String] message The message to get logged.
      def log(severity, message)
        messages << [severity, message]
      end

      alias_method :add, :log

      protected

      attr_accessor :messages
    end
  end
end
