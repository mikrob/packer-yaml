Gem::Specification.new do |s|
  s.name        = 'packer-yaml'
  s.version     = '0.0.1'
  s.date        = '2016-05-09'
  s.summary     = "Gem to make packer file in yaml"
  s.description = "Gem to make packer file in yaml, allowing to use include and comments that are not possible in json"
  s.authors     = ["Mikael Robert"]
  s.email       = 'mikaelrob@gmail.com'
  s.files       = ["lib/packer-yaml.rb"]
  s.add_runtime_dependency "test-unit", ["= 1.2.3"]
  s.add_development_dependency "bourne", [">= 0"]
  s.homepage    =
    'http://www.botsunit.com'
  s.license       = 'MIT'
end