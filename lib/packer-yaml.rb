require 'yaml'
require 'json'
class PackerYaml
  def self.read file_path
    YAML.load_file(file_path)
  end

  def self.to_json yaml

  end
end