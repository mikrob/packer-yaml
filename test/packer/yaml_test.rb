require 'test_helper'

class Packer::YamlTest < Minitest::Test
  CONFIG_PATH = File.expand_path("../../../examples/", __FILE__)

  def test_that_it_has_a_version_number
    refute_nil ::Packer::Yaml::VERSION
  end

  def test_load_yaml
    yaml = Packer::Yaml.read("#{CONFIG_PATH}/packer1.yaml")
    assert_equal "googlecompute", yaml["builders"][1]["type"]
    assert_equal "amazon-ebs", yaml["builders"][0]["type"]
    assert_equal "#!/bin/bash", yaml["provisioners"].first["inline"].first
    assert_equal "sudo apt-get -y install ssh", yaml["provisioners"].first["inline"][6]
  end

  def test_yaml_and_json_are_equal
    yaml = Packer::Yaml.read("#{CONFIG_PATH}/packer1.yaml")
    json = JSON.parse(File.read("#{CONFIG_PATH}/packer1.json"))
    assert_equal yaml, json
  end

  def test_to_json
    packer_yaml = Packer::Yaml.new("example1", "#{CONFIG_PATH}/packer1.yaml")
    json_generated = packer_yaml.to_json
    parsed_json_generated = JSON.parse(json_generated)
    json_real = JSON.parse(File.read("#{CONFIG_PATH}/packer1.json"))
    assert_equal json_real, parsed_json_generated
  end
end