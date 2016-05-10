require "packer/yaml/version"
require 'yaml'
require 'json'

module Packer
  class Yaml
    def initialize name, file_path
      @name = name
      @yaml = Packer::Yaml::read(file_path)
    end

    def self.read file_path
      YAML.load_file(file_path)
    end

    def to_json
      JSON.pretty_generate(@yaml)
    end

    def output_json
      $stdout.write(to_json)
    end
  end
end
