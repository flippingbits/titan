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
    end
  end
end
