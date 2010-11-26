require 'rubygems'
require 'rake'

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "titan/version"

task :build do
  system "gem build titan.gemspec"
end

task :install => :build do
  system "gem install titan-#{Titan::VERSION}"
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "titan #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
