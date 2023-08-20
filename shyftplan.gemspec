$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "shyftplan/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name          = "shyftplan"
  s.version       = Shyftplan::VERSION
  s.authors       = ["Nisanth Chunduru"]
  s.email         = ["nisanth074@gmail.com"]
  s.homepage      = "https://github.com/nisanth074/shyftplan-ruby"
  s.summary       = "Ruby gem for Shyftplan's REST API"
  s.description   = "Ruby gem for Shyftplan's REST API"

  s.files = Dir["{lib}/**/*", "README.md"]

  s.add_dependency "httparty"

  s.add_development_dependency "rake"
  s.add_development_dependency "pry"
  s.add_development_dependency "rspec", '~> 3.9'
  s.add_development_dependency "webmock"
  s.add_development_dependency "factory_bot"
end
