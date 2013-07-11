require 'fileutils'

module Broom
  VERSION = '0.3.5'
  
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
    
    def entries
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
    options[:log] ||= true

    dir = Directory.new(path, options)
    log = lambda do |msg| 
      puts "#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}: #{msg}" if options[:log]
    end

    @do_work = true

    Signal.trap('INT') do
      log.call("stopping...")
      @do_work = false
    end

    begin
      cache = dir.entries
      sleep(options[:sleep] || 1)

      cache.each do |file, modified_at|
        next if modified_at != File.mtime(file)
        begin
          yield(file, File.dirname(file), File.basename(file), File.extname(file))
        rescue Object => boom
          log.call("failure: #{File.basename(file)} [#{boom.message}]")
          FileUtils.mv(file, dir.failure_dir)
        else
          log.call("success: #{File.basename(file)}")
          FileUtils.mv(file, dir.success_dir)
        end
      end
    end while @do_work
  end
  
end
