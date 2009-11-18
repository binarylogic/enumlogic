require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "enumlogic"
    gem.summary = "Adds enumerations to your models"
    gem.description = "Adds enumerations to your models"
    gem.email = "bjohnson@binarylogic.com"
    gem.homepage = "http://github.com/binarylogic/enumlogic"
    gem.authors = ["binarylogic"]
    gem.rubyforge_project = "enumlogic"
    gem.add_development_dependency "rspec"
  end
  Jeweler::GemcutterTasks.new
  Jeweler::RubyforgeTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec