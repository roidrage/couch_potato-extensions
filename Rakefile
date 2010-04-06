require 'rake'
require 'spec/rake/spectask'

Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/*_spec.rb']
end

NAME='couch_potato-extensions'

def gemspec_file
  "#{NAME}.gemspec"
end

def gem_file
  "#{NAME}-#{source_version}.gem"
end

def source_version
  line = File.read("lib/#{NAME.gsub(/-/, "/")}.rb")[/^\s*VERSION\s*=\s*.*/]
  line.match(/.*VERSION\s*=\s*['"](.*)['"]/)[1]
end

task :build do
  sh "mkdir -p pkg"
  sh "gem build #{gemspec_file}"
  sh "mv #{gem_file} pkg"
end