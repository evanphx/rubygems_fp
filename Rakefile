# -*- ruby -*-

require 'rubygems'
require 'hoe'

# Hoe.plugin :compiler
# Hoe.plugin :email
# Hoe.plugin :gem_prelude_sucks
# Hoe.plugin :git
# Hoe.plugin :inline
# Hoe.plugin :minitest
# Hoe.plugin :perforce
# Hoe.plugin :racc
# Hoe.plugin :rubyforge
# Hoe.plugin :seattlerb

Hoe.spec 'rubygems_fp' do
  # HEY! If you fill these out in ~/.hoe_template/Rakefile.erb then
  # you'll never have to touch them again!
  # (delete this comment too, of course)

  developer("Evan Phoenix", "evan@fallingsnow.net")

  # self.rubyforge_name = 'rubygems_fpx' # if different than 'rubygems_fp'
end


rubygems_versions = %w(v1.3.6 v1.3.7
                       v1.4.0 v1.4.1 v1.4.2
                       v1.5.0 v1.5.1 v1.5.2 v1.5.3
                       v1.6.0 v1.6.1 v1.6.2
                       v1.7.0 v1.7.1 v1.7.2
                       v1.8.0 v1.8.1 v1.8.2 v1.8.3 v1.8.4 v1.8.5
                       master)

def git(arg)
  cmd = "git #{arg} 2>&1"
  str = `#{cmd}`

  if $?.exitstatus != 0
    puts "Git failed: #{cmd}"
    puts str
  end

  str
end

def switch_rubygems(version)
  unless File.directory?("tmp/rubygems")
    str = `git clone git://github.com/rubygems/rubygems.git tmp/rubygems`
    if $?.exitstatus != 0
      puts str
      raise "Unable to checkout rubygems"
    end
  end

  hash = nil

  Dir.chdir("tmp/rubygems") do
    git "remote update"
    git "checkout #{version}"
    git "pull origin master" if version == "master"
    hash = `git rev-parse HEAD`.strip
  end

  rubyopt = ENV["RUBYOPT"]
  ENV["RUBYOPT"] = "-I#{File.expand_path("tmp/rubygems/lib")} #{rubyopt}"

  puts "Switch rubygems to version #{version} (git:#{hash})"

  return hash
end

namespace :test do
  rubygems_versions.each do |ver|
    desc "Run tests against Rubygems #{ver}"
    Rake::TestTask.new(ver) do |t|
      t.test_files = FileList["test/test*.rb"]
      t.verbose = true
    end

    task "setup_#{ver}" do
      switch_rubygems(ver)
    end

    task ver => "setup_#{ver}"
  end

  task "all" => rubygems_versions
end

# vim: syntax=ruby
