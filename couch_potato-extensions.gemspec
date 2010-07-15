Gem::Specification.new do |gem|
  gem.name    = 'couch_potato-extensions'
  gem.version = '0.0.7'
  gem.date    = Date.today.to_s

  gem.add_dependency 'couch_potato'
  gem.add_dependency 'ezcrypto'
  gem.add_development_dependency 'rspec', '~> 1.2.9'

  gem.summary = "Some extensions for CouchPotato, because more awesome is always a good thing."
  gem.description = "See summary, it says it all, trust me."

  gem.authors  = ['Mathias Meyer']
  gem.email    = 'meyer@paperplanes.de'
  gem.homepage = 'http://github.com/mattmatt/couch_potato-extensions'

  gem.rubyforge_project = nil
  gem.has_rdoc = true
  gem.rdoc_options = ['--charset=UTF-8']
  gem.extra_rdoc_files = ['README.md']

  gem.files = Dir['Rakefile', 'lib/*', '{bin,lib,man,test,spec}/**/*', 'README*', 'LICENSE*'] & `git ls-files -z`.split("\0")
end
