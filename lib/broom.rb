require 'fileutils'
require 'digest/sha1'

module Broom
  LIB = "#{File.expand_path(File.dirname(__FILE__))}/broom"

  autoload :Directory, "#{Broom::LIB}/directory"
  autoload :Worker,    "#{Broom::LIB}/worker"

  module Backends
    autoload :Base,    "#{Broom::LIB}/backends/base"
    autoload :FSEvent, "#{Broom::LIB}/backends/fsevent"
  end

  def self.sweep(path, options={}, &block)
    worker = Worker.new
    worker.sweep(path, options, &block)
    worker.work
  end

end