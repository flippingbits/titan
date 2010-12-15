require "thor"

module Titan
  class CLI < Thor
    include Thor::Actions

    def initialize(*)
      super
      @shell = Thor::Shell::Basic.new
    end

    desc "help", "Describes available command line options"
    def help
      @shell.say "The following methods are available through typing `titan method_name`"
      @shell.say ""
      available_methods = [
        ["method_name", "description"],
        ["", ""],
        ["help",        "Prints this page and describes available methods"],
        ["status",      "Prints the status of all threads managed by Titan"],
        ["version",     "Prints the currently installed version"]
      ]
      @shell.print_table(available_methods)
    end

    desc "status", "Prints the status of all threads managed by Titan"
    def status
      table_header = ["id", "pid", "status"]
      threads = Titan::Thread.all.each_value.collect do |thread|
        [thread.id.to_s, thread.pid.to_s, thread.alive? ? "alive" : "dead"]
      end
      @shell.print_table(threads.unshift(table_header)) unless threads.empty?
    end

    desc "version", "Prints the currently installed version"
    def version
      @shell.say Titan::VERSION
    end
    map %w(--version -v) => :version
  end
end
