module Tundra
  # A one way communication pipe for communicating between different threads.
  # This class hold only the raw communication channel and mechanisms to
  # interacting with them.
  #
  # This class makes no assumptions around the messages being sent beyond them
  # being strings of bytes with a length less than 2^32 bytes. Performance of
  # larger bytestrings is untested.
  #
  # Messages traversing the pipe use a length framing technique. This can be
  # extended in the future to potentially reject excessively sizes messages
  # before read them off the pipe by simple closing it.
  #
  # @!attribute [r] read_pipe
  #   @return [IO] A read only IO file descriptor
  # @!attribute [r] write_pipe
  #   @return [IO] A write only IO file descriptor
  class IPCPipe
    attr_reader :read_pipe, :write_pipe

    # Reverses the length encoding, providing the number of bytes that need to
    # be read off the pipe to get the complete message.
    #
    # @param [String] bytes
    # @return [Fixnum]
    def self.decode_length(bytes)
      bytes.unpack('L>').first
    end

    # Encode the length in a 32 bit byte string ready to be sent preceeding any
    # socket messages.
    #
    # @param [Fixnum] len The length of a messages
    # @return [String]
    def self.encode_length(len)
      [len].pack('L>')
    end

    # Check to see whether this end of the pipe is still open (works regardless
    # of which side of the communications channel this gets called on).
    #
    # @return [Boolean]
    def closed?
      read_pipe.closed? && write_pipe.closed?
    end

    # Close the appropriate side of this pipe (works regardlesss of which side
    # of the communications channel this gets called on).
    #
    # @return [Boolean]
    def close
      read_pipe.close unless read_pipe.closed?
      write_pipe.close unless write_pipe.closed?
    end

    # If our pipe is still open but the other side has closed it this will
    # return true, allowing us to detect when the write side has exited or
    # otherwise completed it's use of this pipe.
    #
    # @return [Boolean]
    def eof?
      !read_pipe.closed? && read_pipe.eof?
    end

    # Setup the IPC pipe instance and ensure we're operating at the correct
    # encoding.
    def initialize
      @read_pipe, @write_pipe = IO.pipe
      read_pipe.binmode
      write_pipe.binmode
    end

    # Read an individual method from the pipe. If the read pipe is closed
    #
    # @return [String,Nil]
    def read_message
      return if read_pipe.closed?
      return unless (raw_bytes = read_pipe.readbyte(4))

      length = self.class.decode_length(raw_bytes)
      read_pipe.binread(length)
    end

    # Perform thread specific setup for the read side of the pipe.
    def read_thread_setup
      write_pipe.close unless write_pipe.closed?
    end

    # Write a message to the socket, properly giving it a length message frame.
    #
    # @param [String] msg The message to transfer
    def write_message(msg)
      return if write_pipe.closed?

      write_pipe.binwrite(self.class.encode_length(msg.length))
      write_pipe.binwrite(msg)
    end

    # Perform thread specific setup for the write side of the pipe.
    def write_thread_setup
      read_pipe.close unless read_pipe.closed?
    end
  end
end
