module Tundra
  class IPCPipe
    attr_reader :read_pipe, :write_pipe

    def after_child_fork
      read_pipe.close unless read_pipe.closed?
      write_pipe.syswrite('.')
    end

    def after_parent_fork
      write_pipe.close unless write_pipe.closed?
    end

    def closed?
      read_pipe.closed? && write_pipe.closed?
    end

    def close
      read_pipe.close unless read_pipe.closed?
      write_pipe.close unless write_pipe.closed?
    end

    def eof?
      !read_pipe.closed? && read_pipe.eof?
    end

    def initialize
      @read_pipe, @write_pipe = IO.pipe
      write_pipe.set_encoding(::Encoding::ASCII_8BIT)
    end
  end
end
