require "titan/version"

module Titan
  TITAN_DIRECTORY = File.expand_path('.titan_threads', '~')

  autoload :CLI,      "titan/cli"
  autoload :System,   "titan/system"
  autoload :Thread,   "titan/thread"
end
