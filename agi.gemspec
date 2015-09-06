# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{agi}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alexey Gordienko"]
  s.date = %q{2915-09-06}
  s.description = %q{This is a fork of ruby-agi version 1.1.2 by Mohammad Khan.}
  s.email = %q{alx@anadyr.org}
  s.extra_rdoc_files = [
     "LICENSE",
     "README"
  ]
  s.files = [
     "LICENSE",
     "README",
     "Rakefile",
     "VERSION",
     "examples/call_log.rb",
     "extconf.rb",
     "lib/agi.rb",
     "lib/agi/agi.rb",
     "lib/agi/asterisk_variable.rb",
     "lib/agi/command.rb",
     "lib/agi/error.rb",
     "lib/agi/return_status.rb",
     "agi.gemspec"
  ]
  s.homepage = %q{http://github.com/gordienko/agi}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Ruby AGI interface into Asterisk}
  s.test_files = [
    "examples/call_log.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
