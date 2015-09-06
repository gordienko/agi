require 'rake'

$LOAD_PATH.unshift('lib')

gem 'git'
require 'git'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "agi"
    gemspec.summary = "Ruby AGI interface into Asterisk"
    gemspec.description = "This is a fork of agi version 1.1.2 by Mohammad Khan."
    gemspec.email = "alx@anadyr.org"
    gemspec.homepage = "http://github.com/erichmond/agi"
    gemspec.authors = ["Alexey Gordienko"]
  end
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install jeweler"
end