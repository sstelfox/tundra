module Tundra
  # This ring buffer class works a lot like a limited version of the standard
  # Array but only keeps a certain number of elements. Elements can be appended
  # to the end of the ring, iterated over, counted, cleared and explicitely
  # updated.
  #
  # @!attribute [r] ring
  #   @return [Array<Object>] The internal ring storing the currently stored
  #     elements.
  # @!attribute [rw] ring_size
  #   @return [Fixnum] The maximum number of elements allowed to be stored in
  #     the internal ring.
  class RingBuffer
    include Enumerable

    # Append a new value to the end of the internal ring. This will remove the
    # oldest entry from the ring if we exceed the set maximum size. If an
    # element is removed this will return the element that got removed,
    # otherwise it'll return a nil value.
    #
    # @param [Object] value Object to add to the ring
    # @return [Object,Nil] Element removed from the ring if any
    def <<(value)
      ring << value
      (count > ring_size ? ring.shift : nil)
    end

    alias_method :push, :<<

    # Returns the current number of elements stored in the ring.
    #
    # @return [Fixnum]
    def count
      ring.count
    end

    # Allow instances of this class to be enumerable. This allows the ring to
    # be evaluated lazily and iteratable.
    #
    # @yieldparam [Object] item Individual contents of the ring
    def each
      return ring.each unless block_given?
      ring.each { |item| yield(item) }
    end

    # Tests whether or not the ring has any contents.
    #
    # @return [Boolean]
    def empty?
      ring.empty?
    end

    # Setup a new instance of the RingBuffer class.
    #
    # @param [Fixnum] ring_size The maximum number of elements the ring buffer
    #   will hold at any given time.
    # @param [Array<Object>] initial_values Values to initialize the buffer
    #   with.
    def initialize(ring_size, initial_values = [])
      self.ring_size = ring_size
      self.ring = initial_values
    end

    # Update the contents of the ring to the provided values. If more values
    # are provided than the ring supports this will take the tail end of the
    # provided ring.
    #
    # @param [Array<Object>] values
    def ring=(values)
      @ring = (values.count >= ring_size) ? values[-ring_size..-1] : values
    end

    protected

    attr_reader :ring
    attr_accessor :ring_size
  end
end
