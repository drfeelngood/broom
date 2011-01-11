require 'rubygems'

$:.unshift(File.dirname(__FILE__))
require 'lib/broom'

Gem::Specification.new do |s|
  
  s.name        = "broom"
  s.version     = "#{Broom::VERSION}"
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.homepage    = "https://github.com/drfeelngood/broom"
  s.authors     = ["Daniel Johnston"]
  s.email       = "dan@dj-agiledev.com"
  
  s.summary     = "Simple file picker-upper"
  s.description = <<-DESC
  A small module for watching a directory for new files.
DESC

  s.files       = ['README.markdown', 'LICENSE', 'Rakefile', 'lib/broom.rb']

end