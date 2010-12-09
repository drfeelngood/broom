require 'rubygems'

$:.unshift(File.dirname(__FILE__))

Gem::Specification.new do |s|
  
  s.name        = "broom"
  s.version     = "0.0.1"
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.homepage    = "http://github.com/djohnston/broom"
  s.authors     = ["Daniel Johnston"]
  s.email       = "dan@dj-agiledev.com"
  
  s.summary     = "Simple file picker-upper"
  s.description = <<-DESC
  A small module for watching a directory for new files.
DESC

  s.files       = %w(README.markdown LICENSE Rakefile)
  s.files      += 'lib/broom'

end