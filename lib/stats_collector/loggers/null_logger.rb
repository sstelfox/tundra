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
      alias :method_missing :add
      alias :responds_to? :add
      alias :unknown :add
      alias :warn :add
    end
  end
end
