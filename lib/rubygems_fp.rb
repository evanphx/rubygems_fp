require "rubygems"
require "rubygems/package"

class RubyGemsFP
  VERSION = '1.0.0'

  class Specification
    def initialize(spec)
      @spec = spec
    end

    def gem_dir
      if @spec.respond_to? :gem_dir
        @spec.gem_dir
      else
        @spec.full_gem_path
      end
    end

    def file_exists?(path)
      File.exists? File.join(gem_dir, path)
    end
  end

  class GemFile
    def initialize(io)
      @io = io
    end

    def self.from_path(path)
      new File.open(path)
    end

    def read_file(path)
      Gem::Package.open(@io) do |pkg|
        pkg.each do |e|
          if e.full_name == path
            return e.read
          end
        end
      end

      nil
    end

  end
end
