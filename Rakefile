require 'rubygems'
require 'rake'

$:.unshift(File.dirname(__FILE__))
require 'lib/broom'

desc "Publish gem and source."
task :publish => :gem do
  sh "gem push broom-#{Broom::VERSION}.gem"
  sh "git tag v#{Broom::VERSION}"
  sh "git push origin v#{Broom::VERSION}"
  sh "git push origin master"  
end

desc "Build broom gem."
task :gem do
  sh "gem build broom.gemspec"
end
