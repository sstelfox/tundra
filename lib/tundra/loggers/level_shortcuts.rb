module Tundra
  module Loggers
    # Provides common shortcuts to logging at the provided log level. This
    # assumes that the class this module is included in implements the #log
    # message (taking two arguments severity as a symbol, and the message as a
    # string).
    module LevelShortcuts
      # @!group Log Shortcut Methods

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

      # @!endgroup
    end
  end
end
