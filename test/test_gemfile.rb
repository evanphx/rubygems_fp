require "rubygems"
require "rubygems_fp"
require "test/unit"

class TestRubyGemsFPGemFile < Test::Unit::TestCase
  def setup
    @path = File.expand_path("../test-1.0.gem", __FILE__)
  end

  def test_read_file
    gf = RubyGemsFP::GemFile.from_path @path
    assert_equal "This is a file in the test gem\n", gf.read_file("test-file")
  end

  def test_read_file_nonexistant
    gf = RubyGemsFP::GemFile.from_path @path
    assert_equal nil, gf.read_file("not_there")
  end
end
