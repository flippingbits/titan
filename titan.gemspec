$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "titan/version"

Gem::Specification.new do |s|
  s.name                      = %q{titan}
  s.version                   = Titan::VERSION
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors                   = ["Stefan Sprenger"]
  s.date                      = Time.now.strftime("%Y-%m-%d")
  s.description               = %q{Helps you creating and managing daemon threads with Ruby.}
  s.email                     = %q{info@stefan-sprenger.com}
  s.extra_rdoc_files          = ["LICENSE", "README.md"]
  s.files                     = Dir.glob("{lib}/**/*") + %w(LICENSE README.md CHANGELOG.md)
  s.executables               = ["titan"]
  s.homepage                  = %q{http://github.com/flippingbits/titan}
  s.rdoc_options              = ["--charset=UTF-8"]
  s.require_paths             = ["lib"]
  s.rubygems_version          = %q{1.3.7}
  s.summary                   = %q{Helps you creating and managing daemon threads with Ruby.}

  s.add_dependency("thor")
  s.add_development_dependency("rspec")
end
