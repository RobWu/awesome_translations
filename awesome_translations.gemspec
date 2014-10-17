$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "awesome_translations/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "awesome_translations"
  s.version     = AwesomeTranslations::VERSION
  s.authors     = ["Kasper Johansen"]
  s.email       = ["k@spernj.org"]
  s.homepage    = "https://www.github.com/kaspernj/awesome_translations"
  s.summary     = "Semi-automatic maintenance of most translations in a Rails app."
  s.description = "Semi-automatic maintenance of most translations in a Rails app."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.0.10"
  s.add_dependency "haml"
  s.add_dependency "string-cases"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "forgery"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "codeclimate-test-reporter"
end
