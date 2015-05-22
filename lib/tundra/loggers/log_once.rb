module Tundra
  module Loggers
    # The maximum number of keys that will be tracked for whether or not a
    # message has been logged before. This is primarily a mechanism to prevent
    # runaway memory usage, though practically I doubt it'll ever get this
    # full. I should track this usage in a metric to prove that to myself
    # though.
    LOG_ONCE_MAX_KEYS = 250

    # Provides a mechanism to log certain types of messages only once. Expects
    # to be included in a class that implements a #log message.
    #
    # After inclusion the class should also call the #initialize_log_once
    # method to ensure the mutex is created before the logger is usable.
    #
    # @!attribute [r] logged_keys
    #   @return [Array<Symbol,String>] Unique keys that have already been
    #     marked as having logged once.
    # @!attribute [r] logged_mutex
    #   @return [Mutex] A safety mechanism to allow singular logging to safely
    #     occur between threads.
    module LogOnce
      # Empty out all the keys that have been accumulated in the logged keys
      # internal array. This will allow messages that would otherwise only be
      # logged to be able to be logged again.
      def clear_logged_keys
        logged_mutex.synchronize { logged_keys.clear }
      end

      # Quick boolean check to determine if the internal key cache has gotten
      # full yet or not.
      #
      # @return [Boolean]
      def full?
        logged_keys.count >= LOG_ONCE_MAX_KEYS
      end

      # A thread safe mechanism to ensure a key tagged message is logged only
      # once regardless of how many times the message may be getting triggered.
      # This doesn't support logging normalized exceptions or multiple lines
      # under the same log key.
      #
      # Exceptions could be switching the final log message to a #send and
      # 'virtually' supporting the log level type of :exception but that would
      # be a performance hit and I generally prefer to avoid usage of #send
      # until it absolutely becomes necessary.
      #
      # @param [Symbol] level The level to log the message at.
      # @param [String,Symbol] key The identifier to track whether or not this
      #   log message has been seen before or not.
      # @param [String] message The message that should be logged.
      def log_once(level, key, message)
        logged_mutex.synchronize do
          return unless should_log?(key)
          logged_keys << key
        end

        log(level, message)
      end

      protected

      attr_reader :logged_keys, :logged_mutex

      # Sets up the internal variables used by this module. This is expected to
      # be called in the initializer for any class that includes this module.
      def initialize_log_once
        @logged_keys = []
        @logged_mutex = ::Mutex.new
      end

      # Perform a check on whether or not we'd care to log the a message tagged
      # with the provided key.
      #
      # @param [String,Symbol] key Key to check
      # @return [Boolean]
      def should_log?(key)
        return false if logged_keys.include?(key)
        return false if full? && key.is_a?(String)
        true
      end
    end
  end
end
