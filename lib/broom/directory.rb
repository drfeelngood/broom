module Broom
class Directory
  attr_reader :path, :pattern, :options, :failure_dir, :success_dir
  attr_reader :cache, :block

  def initialize(path, options={}, &block)
    @path  = File.realpath(path)
    @block = block
    @pattern     = options[:pattern] || "*"
    @failure_dir = options[:failure_dir] || File.join(@path, "_failure")
    @success_dir = options[:success_dir] || File.join(@path, "_success")
    [@path, @failure_dir, @success_dir].each do |dir|
      FileUtils.mkdir(dir) unless File.exist?(dir)
    end
  end
  
  def glob
    Dir.glob(File.join(@path, @pattern)).delete_if do |file|
      file == @success_dir || file == @failure_dir
    end
  end
  
  def entries
    # files = {}
    # Dir.glob(File.join(@path, @pattern)).each { |file|
      # next if file == @success_dir || file == @failure_dir
      # files[file] = File.mtime(file)
    # }
    # files
  end
  
  # def take_snapshot
  #   glob.each do |file|
  #     @cache[encrypt(file)] = File.mtime(file).to_i
  #   end
  # end
  
  private
  
    def encrypt(path)
      Digest::SHA1.file(path)
    end

end
end