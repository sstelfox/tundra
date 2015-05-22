module Tundra
  module Loggers
    module LevelLookup
      # A reverse lookup table from the log level constant to the associated
      # symbol that are easier to work with.
      #
      # @return [Hash<Fixnum=>Symbol>] The reverse lookup table.
      def level_lookup
        LOG_LEVELS.invert
      end

      # Given a string or symbol this will lookup the appropriate log level
      # constant matching the name. If the name is invalid it will fallback on
      # the unknown level.
      #
      # @param [Symbol] severity The severity to convert to the appropriate
      #   constant.
      # @param [Symbol] fallback In the event the severity provided isn't
      #   value, the fallback value will be used.
      # @return [Fixnum] The value of the severity constant.
      def severity_lookup(severity, fallback = :unknown)
        LOG_LEVELS[severity] || LOG_LEVELS[fallback]
      end
    end
  end
end
