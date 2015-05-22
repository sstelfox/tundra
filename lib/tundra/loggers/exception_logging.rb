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
        (err.backtrace || ['No backtrace available.']).each do |msg|
          log(backtrace_level, msg)
        end
      end
    end
  end
end
