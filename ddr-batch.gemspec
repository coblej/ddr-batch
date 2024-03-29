$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ddr/batch/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ddr-batch"
  s.version     = Ddr::Batch::VERSION
  s.authors     = ["Jim Coble"]
  s.email       = ["lib-drs@duke.edu"]
  s.homepage    = "https://github.com/duke-libraries/ddr-batch"
  s.summary     = %q{Batch processes for the Duke Digital Repository.}
  s.description = %q{Batch processes for the Duke Digital Repository.}
  s.license     = "BSD-3-Clause"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE.txt", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.1.8"
  s.add_dependency "devise"
  s.add_dependency "active-fedora", "~> 7.0"
  s.add_dependency "ddr-models", "~> 1.4.0"
  s.add_dependency "paperclip", "~> 4.2.0"
  s.add_dependency "resque", "1.25.2"
  s.add_dependency "resque-pool", "0.3.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails", "~> 3.1"
  s.add_development_dependency "factory_girl_rails", "~> 4.4"
  s.add_development_dependency "jettywrapper"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "equivalent-xml"
end
