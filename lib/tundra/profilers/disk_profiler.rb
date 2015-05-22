module Tundra
  module Profilers
    class DiskProfiler
      def line_data
        stat_file_lines.map do |line|
          key, value = line.split(': ')
          [key, value.to_i]
        end
      end

      def measure
      end

      def stat_file
        "/proc/#{$PID}/io"
      end

      def stat_file_lines
        File.read(stat_file).split("\n")
      end

      def to_h
        Hash[line_data]
      end
    end
  end
end
