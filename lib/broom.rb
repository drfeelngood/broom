require 'fileutils'

Signal.trap('INT') do
  $stdout.puts "throwing in the towel..."
  exit
end

module Broom
  
  class Directory

    attr_reader :path, :pattern, :failure_dir, :success_dir

    def initialize(path, options={})
      @path        = File.expand_path(path)
      @pattern     = options[:pattern] || "*"
      @failure_dir = options[:failure_dir] || File.join(@path, "_failure")
      @success_dir = options[:success_dir] || File.join(@path, "_success")
      [@path, @failure_dir, @success_dir].each do |dir|
        FileUtils.mkdir(dir) unless File.exist?(dir)
      end
    end
    
    def cache
      files = {}
      Dir.glob(File.join(@path, @pattern)).each { |file|
        next if file == @success_dir || file == @failure_dir
        files[file] = File.mtime(file)
      }
      files
    end
        
  end
  
  extend self
  
  def sweep(path, options={}, &block)
    dir = Directory.new(path, options)
    loop do
      dir.cache.each do |file, modified_at|
        next if modified_at != File.mtime(file)
        begin
          yield(file)
        rescue Object => boom
          $stdout.puts "uncaught error #{boom.class}: #{boom.message}"
          $stdout.puts boom.backtrace.join("\n"))
          FileUtils.mv(file, dir.failure_dir)
        else
          FileUtils.mv(file, dir.success_dir)
        end
      end
      sleep 1
    end
  end
  
end