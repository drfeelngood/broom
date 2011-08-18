# TODO: extract
require 'rb-fsevent'

module Broom
class Worker
  attr_reader :backend, :directory

  def initialize
    @backend = select_backend
  end

  def sweep(path, options={}, &block)
    @directory = Broom::Directory.new(path, &block)
  end

  def work
    @backend.watch(@directory.path) do |d|
      @directory.glob.each do |file|
        begin
          @directory.block.call(file, File.dirname(file), File.basename(file), 
            File.extname(file))
        rescue Object => boom
          FileUtils.mv(file, @directory.failure_dir)
        else
          FileUtils.mv(file, @directory.success_dir)
        end
      end
    end
    @backend.run
  end

  def stop
    @backend.stop
  end

  private

    def select_backend
      case RbConfig::CONFIG['target_os']
      when /darwin/i then ::FSEvent.new #Backends::FSEvent.new
      else Backends::Poll.new; end
    end

    def watch(directory)
      @backend.watch(directory)
    end

    def setup_signals
      Signal.trap('INT'){ stop }
    end

end
end