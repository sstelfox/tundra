module StatsCollector
  module Loggers
    # Instances of this logger are useful for blackholing messages that would
    # otherwise by logged. It directly implements the most common called
    # methods from the standard Ruby logging class, doing nothing with the
    # arguments. Other calls are handled by method missing which is slower but
    # ensures complete compatibility with the Logger mechanism.
    class NullLogger
      # A logging method that does exactly nothing, as any good null logger
      # should.
      #
      # @params [Array<Object>] _args Completely ignored
      def add(*_args)
      end

      alias :<< :add
      alias :debug :add
      alias :error :add
      alias :fatal :add
      alias :info :add
      alias :log :add
      alias :unknown :add
      alias :warn :add

      alias :method_missing :add

      # Simple mechanism for indicating that we are able to respond and handle
      # any message. This is normally a bad idea, and I may need to handle some
      # additional specific functionality directly if this becomes an issue.
      # For a null object though this is probably pretty safe.
      def respond_to?(_method)
        true
      end
    end
  end
end
