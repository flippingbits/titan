module Titan
  #
  # Titan::Thread helps you creating daemon threads that are independent from your application.
  # Each Titan::Thread is identified by an id that you can either pass on initialization or
  # that gets created automatically.
  #
  class Thread
    attr_accessor :id, :pid

    #
    # Creates a new daemonized thread
    #
    def initialize(options = {}, &block)
      @id   = options[:id] || __id__
      @pid  = Process.fork do
        # ignore interrupts
        Signal.trap('HUP', 'IGNORE')
        # execute the actual programm
        block.call
        # exit the forked process cleanly
        Kernel.exit!
      end

      Process.detach(@pid)
      self
    end

    #
    # Kills the daemonized thread
    #
    def kill
      Process.kill('KILL', @pid)
    end

    #
    # Returns whether the thread is alive or not
    #
    def alive?
      begin
        Process.getpgid(@pid)
        true
      rescue Errno::ESRCH
        false
      end
    end
  end
end
