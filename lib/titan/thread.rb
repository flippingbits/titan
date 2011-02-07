module Titan
  #
  # Titan::Thread helps you creating daemon threads that are independent from your application.
  # Each Titan::Thread is identified by an id that you can either pass on initialization or
  # that gets created automatically.
  #
  class Thread
    attr_accessor :id, :pid

    @@threads = {}

    #
    # Creates a new daemonized thread
    #
    def initialize(options = {}, &block)
      @id       = options[:id] || __id__
      @pid      = -1
      @programm = block
      @@threads[@id] = self
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
      Process.getpgid(@pid)
      true
    rescue Errno::ESRCH
      false
    end

    #
    # Changes the id of the thread and starts synchronization
    #
    def id=(id)
      @@threads.delete(@id)
      @id = id
      @@threads[id] = self
      Titan::Thread.save_threads
    end

    #
    # Returns the file where its pid gets saved
    #
    def pid_file
      File.expand_path(@id.to_s + ".pid", TITAN_DIRECTORY)
    end

    #
    # Returns the used memory
    #
    def used_memory
      used_memory = Titan::System.ps('rss', @pid)
      used_memory ? used_memory.to_i : nil
    end

    #
    # Returns the used CPU
    #
    def used_cpu
      used_cpu = Titan::System.ps('%cpu', @pid)
      used_cpu ? used_cpu.to_f : nil
    end

    #
    # Opens the pid file and save its pid in it
    #
    def save
      Titan::System.check_filesystem
      File.open(pid_file, 'w') { |file| file.write(@pid) }
      @@threads[@id] = self
    end

    #
    # Executes the given programm
    #
    def run
      @pid  = Process.fork do
        # ignore interrupts
        Signal.trap('HUP', 'IGNORE')
        # execute the actual programm
        @programm.call
        # exit the forked process cleanly
        Kernel.exit!
      end
      Process.detach(@pid)
      save
      self
    end

    class << self
      #
      # Returns a thread that has the given id
      #
      def find(id)
        load_threads
        @@threads[id]
      end

      def kill(id)
        find(id).kill
      end

      #
      # Returns all Titan-managed threads
      #
      def all
        load_threads
        @@threads
      end

      #
      # Loads threads from pid files inside the TITAN_DIRECTORY
      #
      def load_threads
        Titan::System.check_filesystem
        Titan::System.pid_files.each{ |pid_file|
          thread     = Titan::Thread.new(:id => File.basename(pid_file, ".pid"))
          thread.pid = File.read(File.expand_path(pid_file, TITAN_DIRECTORY)).to_i
          @@threads[thread.id] = thread
        }
      end

      #
      # Saves threads to pid files inside the TITAN_DIRECTORY
      #
      def save_threads
        Titan::System.pid_files.each { |pid_file| File.delete(File.expand_path(pid_file, TITAN_DIRECTORY)) }
        @@threads.each_value { |thread| thread.save }
      end

      #
      # Removes threads that are not living anymore
      #
      def remove_dead_threads
        @@threads.delete_if { |thread_id,thread| !thread.alive? }
        save_threads
        @@threads
      end
    end
  end
end
