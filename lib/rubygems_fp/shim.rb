require 'rubygems'
require 'rubygems_fp'
require 'source_index_fp'

if Gem::VERSION >= '1.8.0'
  module Gem
    def self.source_index
      @fp_source_index ||= RubyGemsFP::SourceIndex.new
    end
  end
end
