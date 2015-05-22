module Tundra
  module Loggers
    # Module that grants loggers the ability to consistently log exceptions
    # that get raised. Expects to be included in a class that implements a #log
    # message.
    module ExceptionLogging
      # Log an exception in a standardized way at the provided error levels.
      # Backtraces are handled independently from the normal class / message
      # reported.
      #
      # This mechanism varies in it's API from the rest of the logging
      # mechanisms. The pattern of arguments for the other methods is severity
      # followed by thing to log.
      #
      # @param [Exception] err The exception that needs to get logged
      # @param [Symbol] level Severity to log the standard message at.
      # @param [Symbol] backtrace_level Severity to log the backtrace at.
      def exception(err, level = :error, backtrace_level = :debug)
        log(level, format('%p: %s', err.class, err.message))
        backtrace_messages(err).each { |msg| log(backtrace_level, msg) }
        true
      end

      protected

      # Extracts the backtrace from the provided object. If there isn't a
      # backtrace available this will return a message to send in it's place.
      #
      # @param [Exception] error_obj
      # @return [Array<String>]
      def backtrace_messages(error_obj)
        return ['No backtrace available.'] if error_obj.backtrace.nil?
        error_obj.backtrace
      end
    end
  end
end
