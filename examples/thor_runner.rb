#!/usr/bin/env ruby
require "rubygems"
require "titan"
require "thor"

#
# The runner prints every 10 seconds the current time.
#
# You can start the script by 'ruby thor_runner.rb start'.
# You can stop the script by  'ruby thor_runner.rb stop'.
#
# List the thread using 'ps aux | grep thor_runner.rb'.
#
class Runner < Thor
    include Thor::Actions

    def initialize(*)
      super
    end

    desc "start", "Starts printing the time"
    def start
      Titan::Thread.new(:id => "time_printer") do
        while(true)
          sleep(10)
          puts Time.now.strftime("%H:%m:%S")
        end
      end
    end

    desc "stop", "Stops printing the time"
    def stop
      thread = Titan::Thread.find("time_printer")
      if thread && thread.alive?
        thread.kill
        puts "Killed the thread"
      else
        puts "The thread is not alive"
      end
    end
end

Runner.start
