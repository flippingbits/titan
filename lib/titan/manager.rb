require "yaml" if RUBY_VERSION >= '1.9'

module Titan
  #
  # Titan::Manager provides access to created threads.
  # It serializes and deserializes them using YAML.
  #
  class Manager
    TITAN_FILE = "#{File.expand_path('~')}/.titan"

    @@threads = {}

    class << self
      def add(thread)
        load_threads
        @@threads[thread.id] = thread
        save_threads
      end

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
      def all_threads
        load_threads
        @@threads
      end

      #
      # Loads threads from the TITAN_FILE
      #
      def load_threads
        return unless File.exists?(TITAN_FILE)
        @@threads = YAML::load(File.open(TITAN_FILE)) || {}
      end

      #
      # Saves threads to the TITAN_FILE
      #
      def save_threads
        File.open(TITAN_FILE, 'w') { |file| file.write(YAML::dump(@@threads)) }
      end

      #
      # Removes threads that are not living anymore
      #
      def remove_dead_threads
        @@threads.each_value { |thread| @@threads.delete(thread.id) unless thread.alive? }
      end
    end
  end
end
