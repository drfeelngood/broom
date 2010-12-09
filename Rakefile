require 'rubygems'
require 'rake'

$:.unshift(File.dirname(__FILE__))
require 'lib/broom'

desc "Publish gem and source."
task :publish => :build do
  sh "gem push broom-#{Broom::VERSION}.gem"
  sh "git tag v#{Broom::VERSION}"
  sh "git push origin v#{Broom::VERSION}"
  sh "git push origin master"  
end

desc "Build gem."
task :build do
  puts "gem build broom.gemspec"
end
