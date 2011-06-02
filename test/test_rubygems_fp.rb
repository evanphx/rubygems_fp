require "minitest/autorun"
require "rubygems_fp"
require "yaml"
require "pathname"
require "fileutils"
require "rubygems"

STDERR.puts "===== Testing against RubyGems: #{Gem::VERSION}"

class TestRubyGemsFPSpecification < MiniTest::Unit::TestCase

  def setup
    tmpdir = File.expand_path("tmp/test")

    if ENV['KEEP_FILES'] then
      @tempdir = File.join(tmpdir, "test_rubygems_#{$$}.#{Time.now.to_i}")
    else
      @tempdir = File.join(tmpdir, "test_rubygems_#{$$}")
    end

    @tempdir.untaint
    @gemhome  = File.join @tempdir, 'gemhome'
    @userhome = File.join @tempdir, 'userhome'

    FileUtils.mkdir_p @gemhome
    FileUtils.mkdir_p @userhome

    Gem.use_paths @gemhome
  end

  def teardown
    FileUtils.rm_rf @tempdir unless ENV['KEEP_FILES']
  end

  def write_file(path)
    path = File.join @gemhome, path unless Pathname.new(path).absolute?
    dir = File.dirname path
    FileUtils.mkdir_p dir

    open path, 'wb' do |io|
      yield io if block_given?
    end

    path
  end

  def spec_path(spec)
    File.join @gemhome, "specifications", "#{spec.name}-#{spec.version}.gemspec"
  end

  def quick_gem(name, version='2')
    require 'rubygems/specification'

    spec = Gem::Specification.new do |s|
      s.platform    = Gem::Platform::RUBY
      s.name        = name
      s.version     = version
      s.author      = 'A User'
      s.email       = 'example@example.com'
      s.homepage    = 'http://example.com'
      s.summary     = "this is a summary"
      s.description = "This is a test description"

      yield(s) if block_given?
    end

    written_path = write_file spec_path(spec) do |io|
      io.write spec.to_ruby
    end

    spec.loaded_from = spec.loaded_from = written_path

    return spec
  end
  
  def test_gem_dir
    a = quick_gem "a", "2"

    s = RubyGemsFP::Specification.new(a)

    expected = File.join @gemhome, "gems", "a-2"

    assert_equal expected, s.gem_dir
  end
end
