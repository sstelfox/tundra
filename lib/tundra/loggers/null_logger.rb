module Tundra
  module Loggers
    # Instances of this logger are useful for blackholing messages that would
    # otherwise by logged. It directly implements the most common called
    # methods from the standard Ruby logging class, doing nothing with the
    # arguments. Other calls are handled by method missing which is slower but
    # ensures complete compatibility with the Logger mechanism.
    class NullLogger
      include ExceptionLogging
      include LevelShortcuts
      include LogOnce

      # We still need to support initializing the log once information even if
      # there isn't any other work to be done.
      def initialize
        initialize_log_once
      end

      # A logging method that does exactly nothing, as any good null logger
      # should. These could be handled by method missing but the direct method
      # provides a significant performance improvement.
      #
      # @param [Symbol] _severity Completely ignored
      # @param [Symbol] _message Completely ignored
      def log(_severity, _message)
      end

      alias_method :add, :log

      # Handle all other method calls simply and directly. Normally this would
      # potentially be a dangerous thing to do but anything that would be
      # calling this needs to explicitely do nothing.
      #
      # For edge cases that crop up in the future, specific methods may need to
      # be implemented directly.
      #
      # @param [Array<Object>] _args Unused
      def method_missing(*_args)
        true
      end

      alias_method :respond_to?, :method_missing
    end
  end
end
