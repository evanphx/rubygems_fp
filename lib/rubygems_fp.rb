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
end
