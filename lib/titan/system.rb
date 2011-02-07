module Titan
  class System
    class << self
      #
      # Calls the ps function of the OS with a given command and process
      # id
      #
      # E.g., if you want to get the used memory of a given process
      # (pid=10), you can do this by:
      #
      #     Titan::System.ps('rss', 10).to_i
      #
      def ps(command, pid)
        if pid > 0
          `ps -o #{command}= -p #{pid}`
        else
          nil
        end
      end

      #
      # Checks the file system for neccessary directories and permissions
      #
      def check_filesystem
        Dir.mkdir(Titan::TITAN_DIRECTORY) unless File.directory?(Titan::TITAN_DIRECTORY)
      end

      #
      # Returns a list of all pid files available in the Titan::TITAN_DIRECTORY
      #
      def pid_files
        Dir.entries(Titan::TITAN_DIRECTORY) - [".", ".."]
      end
    end
  end
end
