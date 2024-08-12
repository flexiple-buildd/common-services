require_relative "lib/common_services/version"

Gem::Specification.new do |spec|
  spec.name        = "common_services"
  spec.version     = "0.1.0"
  spec.authors     = [ "Mosam" ]
  spec.summary     = "A library providing common services"
  spec.description = "Common services which can be used accorss flexiple projects"
  spec.license     = "MIT"
  spec.files       = Dir["lib/**/*", "README.md", "LICENSE.txt"]
  spec.require_paths = ['lib']
end
