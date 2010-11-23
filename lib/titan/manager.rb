module Titan
  #
  # Titan::Manager handles created threads.
  # It serializes and deserializes them using YAML.
  #
  class Manager
    TITAN_FILE = "#{File.expand_path('~')}/.titan"

    def initialize
      @threads = {}
      load_threads
    end

    def attach(thread)
      @threads[thread.id] = thread
      save_threads
    end

    def find(id)
      @threads[id]
    end

    def kill(id)
      Process.kill('KILL', find(id))
    end

    def all_threads
      @threads
    end

    #
    # Loads threads from the TITAN_FILE
    #
    def load_threads
      return unless File.exists?(TITAN_FILE)
      @threads = YAML::load(File.open(TITAN_FILE)) || {}
      remove_dead_threads
    end

    #
    # Saves threads to the TITAN_FILE
    #
    def save_threads
      File.open(TITAN_FILE, 'w') {|f| f.write(YAML::dump(@threads)) }
    end

    #
    # Removes threads that are not living anymore
    #
    def remove_dead_threads
      @threads.each_value { |thread| @threads.delete(thread.id) unless thread.alive? }
    end
  end
end
