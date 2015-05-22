module Tundra
  # A generic mechanism for tracking metrics about numerical data.
  #
  # @!attribute [rw] count
  #   @return [Float] The number of data points that have been added. This is
  #     stored as a float to prevent the necessity of converting it when
  #     performing division internally.
  # @!attribute [rw] minimum
  #   @return [Float,Nil] The smallest recorded value in the dataset. This
  #     will be nil if no data points have been recorded.
  # @!attribute [rw] maximum
  #   @return [Float,Nil] The largest recorded value in the dataset. This will
  #     be nil if no data points have been recorded.
  # @!attribute [rw] sum
  #   @return [Float] The running sum of all data points recorded.
  # @!attribute [rw] sum_of_squares
  #   @return [Float]
  class Stat
    attr_reader :count, :minimum, :maximum, :sum, :sum_of_squares

    # Check to see if any data has been recorded in this instance yet.
    #
    # @return [Boolean]
    def any_data?
      count != 0.0
    end

    # Setup a fresh instance of a stat tracker.
    def initialize
      reset
    end

    # Calculate and return the current mean for the data.
    #
    # @return [Float]
    def mean
      sum / count
    end

    # Merge this stat collection with another one. I'm concerned about the sum
    # of square addition here. The two stats will have different running means
    # as the sum of squares is being generated. It's already going to be
    # inaccurate though as it's not using the final mean of the dataset to
    # compare against. For now it's probably 'good enough'
    #
    # @param [::Tundra::Stat] stat
    def merge(stat)
      self.count += stat.count
      self.sum += stat.sum
      self.sum_of_squares += stat.sum_of_squares

      update_maximum(data_point.maximum)
      update_minimum(data_point.minimum)
    end

    # Record a new data point in the running statistics.
    #
    # @param [Fixnum,Float] data_point The value to record in the running
    #   metrics.
    def record(data_point)
      self.count += 1
      self.sum += data_point

      update_maximum(data_point)
      update_minimum(data_point)
      update_sum_of_squares(data_point)
    end

    # Simple mechanism for clearing out the contents of a stat instance.
    def reset
      self.count = 0.0
      self.sum = 0.0
      self.sum_of_squares = 0.0

      self.minimum = self.maximum = nil
    end

    # Returns the variance of the data calculated by this statistic. This uses
    # the (n - 1) denominator as it is assumed the values being measured are
    # part of a larger population.
    #
    # If there isn't enough data available to generate a proper variance this
    # will return nil.
    #
    # @return [Nil,Float] The variance data if it's available.
    def variance
      return unless count > 1
      sum_of_squares / (count - 1)
    end

    protected

    attr_writer :count, :minimum, :maximum, :sum, :sum_of_squares

    # Track a new maximum value if the data point is larger than all other
    # previous metrics or one hasn't been recorded yet.
    #
    # @param [Fixnum,Float] value
    def update_maximum(value)
      return unless maximum.nil? || value > maximum
      self.maximum = value
    end

    # Track a new minimum value if the data point is smaller than all other
    # previous metrics or one hasn't been recorded yet.
    #
    # @param [Fixnum,Float] value
    def update_minimum(value)
      return unless minimum.nil? || value < minimum
      self.minimum = value
    end

    # Sum over all observations, of the squared differences of each obversation
    #
    # @param [Fixnum,Float] value The data point used to update the internal
    #   tracking of the sum of squares.
    def update_sum_of_squares(value)
      self.sum_of_squares += ((value - mean)**2)
    end
  end
end
