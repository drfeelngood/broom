require 'test/unit'
require 'fileutils'
require File.dirname(__FILE__) + '/../lib/broom'

class TestBroom < Test::Unit::TestCase
  
  def setup
    @test_dir = "#{File.dirname(__FILE__)}/broom"
    FileUtils.mkdir(@test_dir)
  end
  
  def teardown
    FileUtils.rm_r(@test_dir)
  end
  
  def test_success_and_failure
    ['good.test', 'bad.test'].each { |f| FileUtils.touch("#{@test_dir}/#{f}") }
    broom = Thread.new do
      Broom.sweep(@test_dir, :pattern => "*.test") do |f|
        raise "Danger! #{f}" if f =~ /bad/
      end
    end

    sleep 5
    Thread.kill(broom)

    assert(File.exist?("#{@test_dir}/_failure/bad.test"))
    assert(File.exist?("#{@test_dir}/_success/good.test"))
  end

end